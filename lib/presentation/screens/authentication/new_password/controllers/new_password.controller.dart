import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:game_on_flutter/infrastructure/navigation/route_config.dart';
import 'package:game_on_flutter/infrastructure/storage/preference_manager.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../infrastructure/network/api_utils.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../values/common_utils.dart';
import '../../../../app_widgets/app_loading_mixin.dart';
import '../providers/new_password_provider.dart';

class NewPasswordController extends GetxController with AppLoadingMixin {
  /// logger
  final logger = Logger();

  /// Text controllers.
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;
  late TextEditingController existingPasswordController;

  /// Focus node.
  late FocusNode newPasswordFocusNode;
  late FocusNode confirmPasswordFocusNode;
  late FocusNode existingPasswordFocusNode;

  /// Error text field widget.
  RxString newPasswordError = "".obs;
  RxString confirmPasswordError = "".obs;
  RxString existingPasswordError = "".obs;

  /// Form key to validate fields.
  final newPasswordFormKey = GlobalKey<FormState>();

  /// Store true if fields are valid otherwise false.
  RxBool isValidFields = false.obs;

  /// Store true if screen belongs to reset user password.
  RxBool isChangePassword = false.obs;

  /// Local fields to store user input.
  String _newPassword = '';
  String _confirmPassword = '';
  String _existingPassword = '';
  String _email = '';

  final _provider = NewPasswordProvider();

  @override
  void onInit() {
    _getArguments();
    _initialiseFields();
    super.onInit();
  }

  /// Set Arguments.
  void _getArguments() {
    if (Get.arguments != null) {
      isChangePassword.value =
          Get.arguments[RouteArguments.updateDetails] ?? false;

      _email = Get.arguments[RouteArguments.email] ?? '';
    }
    // _email = PreferenceManager.instance.userEmail;
  }

  /// Set new password.
  void setNewPassword(String value) {
    _newPassword = value;
    checkField();
  }

  /// Set confirmation password.
  void setConfirmPassword(String value) {
    _confirmPassword = value;
    checkField();
  }

  /// Set existing password.
  void setExistingPassword(String value) {
    _existingPassword = value;
    checkField();
  }

  /// Setup initial fields.
  void _initialiseFields() {
    newPasswordController = TextEditingController(text: "");
    confirmPasswordController = TextEditingController(text: "");
    existingPasswordController = TextEditingController(text: "");

    newPasswordFocusNode = FocusNode();
    confirmPasswordFocusNode = FocusNode();
    existingPasswordFocusNode = FocusNode();
  }

  /// Check for valid fields.
  void checkField() {
    isValidFields.value =
        _newPassword.isNotEmpty && _confirmPassword.isNotEmpty;
  }

  /// on Submit called.
  void onSubmit() {
    if (newPasswordFormKey.currentState!.validate()) {
      if (!isPasswordMatch()) {
        confirmPasswordError.value = AppString.passwordNotMatchedError;
        return;
      }
      _clearFieldErrors();
      FocusManager.instance.primaryFocus?.unfocus();
      if (isChangePassword.value) {
        _changePassword();
      } else {
        _resetPassword();
      }
    }
  }

  /// Clear all fields.
  void _clearFieldErrors() {
    newPasswordError.value = "";
    confirmPasswordError.value = "";
    existingPasswordError.value = "";
  }

  /// clear fields.
  void _clearFields() {
    _clearFieldErrors();
    newPasswordController.clear();
    confirmPasswordController.clear();
    existingPasswordController.clear();
  }

  /// Return true if both passwords are matched otherwise false.
  bool isPasswordMatch() => _newPassword.trim() == _confirmPassword.trim();

  /// Change Password API.
  void _changePassword() async {
    try {
      if (await NetworkConnectivity.instance.hasNetwork()) {
        showGlobalLoading();

        dio.Response? response =
            await _provider.changePassword(password: _newPassword);
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _changePasswordSuccess(response);
        } else {
          /// On Error
          _changePasswordError(response);
        }
      } else {
        hideGlobalLoading();
        GetIt.I<CommonUtils>().showNetworkError();
      }
    } catch (ex) {
      logger.e(ex);
      hideGlobalLoading();
      CommonUtils.showErrorSnackBar(message: ex.toString());
    }
  }

  /// Reset Password API.
  void _resetPassword() async {
    try {
      if (await NetworkConnectivity.instance.hasNetwork()) {
        showGlobalLoading();
        dio.Response? response = await _provider.resetPassword(
            email: _email.trim(), password: _newPassword.trim());
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _resetPasswordSuccess(response);
        } else {
          /// On Error
          _changePasswordError(response);
        }
      } else {
        hideGlobalLoading();
        GetIt.I<CommonUtils>().showNetworkError();
      }
    } catch (ex) {
      logger.e(ex);
      hideGlobalLoading();
      CommonUtils.showErrorSnackBar(message: ex.toString());
    }
  }

  /// Change password API success
  void _changePasswordSuccess(dio.Response response) {
    hideGlobalLoading();
    _clearFields();

    /// Show success dialog.
    _showSuccessDialog();
  }

  /// Reset password API error
  void _changePasswordError(dio.Response response) {
    hideGlobalLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }

  /// Show buyer detail update dialog
  void _showSuccessDialog() {
    CommonUtils.showSuccessSnackBar(
        message: AppString.passwordChangeSuccessMessage);
    _navigateToBack();
  }

  void _navigateToBack() {
    Future.delayed(const Duration(seconds: 2), () {
      if (PreferenceManager.instance.isClub) {
        Get.until((route) => route.settings.name == Routes.CLUB_MAIN);
      } else {
        Get.until((route) => route.settings.name == Routes.PLAYER_MAIN);
      }
    });
  }

  /// Reset password API success
  void _resetPasswordSuccess(dio.Response response) {
    hideGlobalLoading();
    _clearFields();

    /// Show success dialog.
    _showPasswordResetDialog();
  }

  /// Show buyer detail update dialog
  void _showPasswordResetDialog() {
    CommonUtils.showSuccessSnackBar(
        message: AppString.resetPasswordConfirmation);
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed(Routes.LOGIN);
    });
  }
}
