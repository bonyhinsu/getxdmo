import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_loading_mixin.dart';
import 'package:game_on_flutter/presentation/screens/authentication/forgot_password/providers/forgot_password_provider.dart';
import 'package:game_on_flutter/presentation/screens/authentication/verify/controllers/verify.controller.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../../../../infrastructure/navigation/route_config.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../infrastructure/network/api_utils.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../values/common_utils.dart';
import '../../../../app_widgets/form_validation_mixin.dart';
import '../../../../app_widgets/user_feature_mixin.dart';

class ForgotPasswordController extends GetxController
    with FormValidationMixin, UserFeatureMixin, AppLoadingMixin {
  late TextEditingController emailController;

  late FocusNode emailFocusNode;

  /// email error.
  RxString emailError = "".obs;

  /// forgot password form key
  final forgotPasswordFormKey = GlobalKey<FormState>();

  /// Provider
  final _provider = ForgotPasswordProvider();

  String _email = "";

  /// bool to check field are valid or not.
  ///
  /// if true then enable button.
  RxBool isValidField = RxBool(false);

  /// logger
  final logger = Logger();

  @override
  void onInit() {
    _initialiseFields();
    super.onInit();
  }

  /// Setup initial fields.
  void _initialiseFields() {
    emailController = TextEditingController(text: "");

    emailFocusNode = FocusNode();
  }

  /// on Submit called.
  void onSubmit() {
    removeFocus(Get.context!);
    _clearFieldErrors();
    if (forgotPasswordFormKey.currentState!.validate()) {
      isValidField.value = false;
      forgotPasswordAPI();
    }
  }

  /// navigate to OTP screen.
  _navigateToOtpScreen() {
    Get.toNamed(Routes.VERIFY, arguments: {
      RouteArguments.verifyTypeEnum: VerifyTypeEnum.FORGOT_PASSWORD,
      RouteArguments.email: _email
    });
  }

  /// Clear all fields.
  void _clearFieldErrors() {
    emailError.value = "";
  }

  /// Set email.
  ///
  /// required [value] as email
  void setEmail(String value) {
    _email = value;
    _checkFieldValid();
  }

  /// Check if field is valid or not.
  void _checkFieldValid() {
    isValidField.value = _email.isNotEmpty;
  }

  /// forgot password API.
  void forgotPasswordAPI() async {
    try {
      if (await NetworkConnectivity.instance.hasNetwork()) {
        showGlobalLoading();
        dio.Response? response = await _provider.forgotPassword(
          email: _email,
        );
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _forgotPasswordSuccess(response);
        } else {
          /// On Error
          _forgotPasswordError(response);
        }
      }
    } catch (ex) {
      logger.e(ex);
      hideGlobalLoading();
      CommonUtils.showErrorSnackBar(message: ex.toString());
    }
  }

  /// Perform login api success
  void _forgotPasswordSuccess(dio.Response response) {
    hideGlobalLoading();
    _clearFields();
    _navigateToOtpScreen();
  }

  /// Perform api error.
  void _forgotPasswordError(dio.Response response) {
    hideGlobalLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }

  /// clear fields.
  void _clearFields() {
    _clearFieldErrors();
    emailController.clear();
  }
}
