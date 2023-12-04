import 'dart:async';

import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_button_mixin.dart';
import 'package:game_on_flutter/presentation/app_widgets/user_feature_mixin.dart';
import 'package:get/get.dart';

import '../../../../values/app_colors.dart';
import '../../../../values/app_images.dart';
import '../../../../values/app_string.dart';
import '../../../../values/app_values.dart';
import '../../../app_widgets/app_input_field.dart';
import '../../../app_widgets/base_view.dart';
import 'controllers/login.controller.dart';

class LoginScreen extends StatefulWidget
    with AppBarMixin, AppButtonMixin, UserFeatureMixin {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController _controller = Get.find();

  late TextTheme textTheme;

  late BuildContext buildContext;

  late bool isKeyboardOpen = false;

  // Subscribe
  late StreamSubscription<bool> keyboardSubscription;

  @override
  void initState() {
    var keyboardVisibilityController = KeyboardVisibilityController();
    // Subscribe
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {
        isKeyboardOpen = visible;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: !isKeyboardOpen
            ? widget.buildAppBar(
                centerTitle: true,
                backEnable: false,
                title: !isKeyboardOpen ? AppString.welcomeMessage : "",
                onBackClick: _controller.onBackClick)
            : null,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppValues.screenMargin,
            ),
            width: double.infinity,
            child: Obx(
              () => Form(
                key: _controller.loginFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            buildCenterContent(),
                            const SizedBox(
                              height: 5.0,
                            ),
                            buildScrollableFields(),
                            const SizedBox(
                              height: 40.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    buildBottomWidget()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBottomWidget() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.appWhiteButton(
              title: AppString.strLogin,
              isValidate: _controller.isValidField.value,
              onClick: () => _controller.onSubmit()),
          const SizedBox(
            height: AppValues.screenMargin,
          ),
          buildSignUp(),
          const SizedBox(
            height: AppValues.screenMargin,
          ),
        ],
      );

  /// Build center logo widget.
  Widget buildCenterLogoWidget() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: !isKeyboardOpen
          ? AppValues.loginLogoWidth
          : AppValues.logoAfterOpenKeyboard,
      height: !isKeyboardOpen
          ? AppValues.loginLogoWidth
          : AppValues.logoAfterOpenKeyboard,
      child: !isKeyboardOpen
          ? SvgPicture.asset(
              AppImages.gameLogoIcon,
              height: AppValues.loginLogoWidth,
              width: AppValues.loginLogoWidth,
            )
          : SvgPicture.asset(
              AppImages.gameLogoIcon,
              height: AppValues.logoAfterOpenKeyboard,
              width: AppValues.logoAfterOpenKeyboard,
            ),
    );
  }

  /// Build center content of welcome screen.
  Widget buildCenterContent() {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildCenterLogoWidget(),
          !isKeyboardOpen
              ? const SizedBox(
                  height: AppValues.height_10,
                )
              : Container(),
          !isKeyboardOpen
              ? Text(
                  AppString.strLoginInfo,
                  textAlign: TextAlign.center,
                  style: textTheme.displayLarge
                      ?.copyWith(color: AppColors.textColorTernary),
                )
              : Container(),
        ],
      ),
    );
  }

  /// Build scrollable fields.
  Widget buildScrollableFields() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [buildClubEmail, buildPasswordField, buildForgotPassword],
    );
  }

  /// Build club email field.
  Widget get buildClubEmail => AppInputField(
        label: AppString.strEmail,
        isEmail: true,
        controller: _controller.emailController,
        focusNode: _controller.emailFocusNode,
        errorText: _controller.emailError.value,
        isMandatory: true,
        denySpaces: true,
        onChange: _controller.setEmail,
      );

  /// Build password field.
  Widget get buildPasswordField => AppInputField(
        label: AppString.strPassword,
        isPassword: true,
        skipPasswordSpecialValidation: true,
        controller: _controller.passwordController,
        focusNode: _controller.passwordFocusNode,
        errorText: _controller.passwordError.value,
        enablePasswordToggle: true,
        isLastField: true,
        isMandatory: true,
        onChange: _controller.setPassword,
      );

  /// Forgot password text button
  Widget get buildForgotPassword => Align(
        alignment: Alignment.centerRight,
        child: TextButton(
            style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                textStyle: textTheme.displaySmall,
                padding: EdgeInsets.zero),
            onPressed: () => _controller.onForgotPassword(),
            child: const Text(AppString.strForgotPassword)),
      );

  /// build widget for navigate sign up screen

  Widget buildSignUp() {
    return EasyRichText(
      AppString.strSignUpAccount,
      patternList: [
        EasyRichTextPattern(
          targetString: AppString.strSignUp,
          style: textTheme.displayLarge?.copyWith(
              color: AppColors.appRedButtonColor, fontWeight: FontWeight.w500),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              _controller.gotoSignUp();
            },
        ),
      ],
      defaultStyle:
          textTheme.displayLarge?.copyWith(fontWeight: FontWeight.w300),
    );
  }
}
