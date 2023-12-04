import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_loading_mixin.dart';
import 'package:game_on_flutter/presentation/screens/authentication/login/providers/login_provider.dart';
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
import '../../verify/controllers/verify.controller.dart';

class LoginController extends GetxController
    with FormValidationMixin, UserFeatureMixin, AppLoadingMixin {
  String _email = "";
  String _password = "";

  late TextEditingController emailController;
  late TextEditingController passwordController;

  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;

  RxString emailError = "".obs;
  RxString passwordError = "".obs;

  final loginFormKey = GlobalKey<FormState>();

  final _provider = LoginProvider();

  /// bool to check field are valid or not.
  ///
  /// if true then enable button.
  RxBool isValidField = RxBool(false);

  /// True when password not visible.
  RxBool isPasswordNotVisible = RxBool(true);

  /// Logger.
  final logger = Logger();

  @override
  void onInit() {
    _initialiseFields();
    super.onInit();
  }

  /// Setup initial fields.
  void _initialiseFields() {
    emailController = TextEditingController(text: "");
    passwordController = TextEditingController(text: "");

    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
  }

  /// on Submit called.
  void onSubmit() {
    if (loginFormKey.currentState!.validate()) {
      ///TODO: Add API call here.
      FocusScope.of(Get.context!).unfocus();
      _clearFieldErrors();
      loginAPI();
    }
  }

  /// Check for field focus if any field has focus then un-focus them and go
  /// back otherwise go back.
  void onBackClick() {
    if (emailFocusNode.hasFocus || passwordFocusNode.hasFocus) {
      emailFocusNode.unfocus();
      passwordFocusNode.unfocus();
      Future.delayed(const Duration(milliseconds: 400), () {
        Get.back();
      });
    } else {
      Get.back();
    }
  }

  /// Clear all fields.
  void _clearFieldErrors() {
    emailError.value = "";
    passwordError.value = "";
  }

  /// Clear fields.
  void _clearFields() {
    _clearFieldErrors();
    emailController.clear();
    passwordController.clear();
  }

  /// On forgot password click.
  void onForgotPassword() => Get.toNamed(Routes.FORGOT_PASSWORD);

  /// Set email
  void setEmail(String value) {
    _email = value;
    checkFieldValid();
  }

  /// Set Password.
  void setPassword(String value) {
    _password = value;
    checkFieldValid();
  }

  void checkFieldValid() {
    isValidField.value = _email.isNotEmpty && _password.isNotEmpty;
  }

  /// return true if password field is valid otherwise false.
  bool isPasswordValid() {
    if (_password.isEmpty) {
      return false;
    }
    return _password.length >= 6;
  }

  /// login API.
  void loginAPI() async {
    try {
      if (await NetworkConnectivity.instance.hasNetwork()) {
        showGlobalLoading();
        dio.Response? response =
            await _provider.loginUser(email: _email, password: _password);
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _loginSuccess(response);
        } else {
          /// On Error
          _loginError(response);
        }
      }
    } catch (ex) {
      logger.e(ex);
      hideGlobalLoading();
      CommonUtils.showErrorSnackBar(message: ex.toString());
    }
  }

  /// Perform login api success
  void _loginSuccess(dio.Response response) {
    hideGlobalLoading();

    _navigateToDashboard();
  }

  /// Perform api error.
  void _loginError(dio.Response response) {
    hideGlobalLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response, isFromLogin: true);
  }

  /// Go to dashboard
  void _navigateToDashboard() {
    _clearFields();
    // FireStoreManager.instance
    //     .getUserDetails(userId: GetIt.I<PreferenceManager>().userUUID)
    //     .then((value) {
    //   GetIt.I<PreferenceManager>()
    //       .setUserName(value.data()?[FirebaseModelParams.USER_NAME]);
    //   GetIt.I<PreferenceManager>().setUserProfile(
    //       value.data()?[FirebaseModelParams.PROFILE_PICTURE] ?? "");
    //   GetIt.I<PreferenceManager>()
    //       .setUserEmail(value.data()?[FirebaseModelParams.EMAIL]);
    // });
    hideGlobalLoading();
    Get.toNamed(Routes.VERIFY, arguments: {
      RouteArguments.verifyTypeEnum: VerifyTypeEnum.LOGIN,
      RouteArguments.email: _email
    });
  }

  void _addPasswordFieldError(String error) {
    passwordError.value = error;
  }

  /// navigate to signup screen
  void gotoSignUp() {
    Get.offAllNamed(Routes.WELCOME);
  }
}
