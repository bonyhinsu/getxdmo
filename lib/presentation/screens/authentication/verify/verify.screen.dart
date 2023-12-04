import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_on_flutter/values/app_colors.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../infrastructure/navigation/routes.dart';
import '../../../../values/app_images.dart';
import '../../../../values/app_string.dart';
import '../../../../values/app_values.dart';
import '../../../app_widgets/app_button_mixin.dart';
import '../../../app_widgets/base_view.dart';
import '../../../app_widgets/user_feature_mixin.dart';
import 'controllers/verify.controller.dart';

class VerifyScreen extends StatelessWidget
    with AppBarMixin, AppButtonMixin, UserFeatureMixin {
  final VerifyController _controller = Get.find(tag: Routes.VERIFY);

  VerifyScreen({Key? key}) : super(key: key);

  late TextTheme textTheme;
  late BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: buildAppBar(
          title: "",
          onBackClick: () => _controller.onBackPress(),
          backEnable: false),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppValues.screenMargin,
          ),
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: AppValues.screenMargin,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      buildCenterContent(),
                      const SizedBox(
                        height: 50.0,
                      ),
                      buildCountDownText(),
                      const SizedBox(
                        height: 20.0,
                      ),
                      buildOTPTextField(),
                      if (!isKeyboardHidden(context))
                        const SizedBox(
                          height: 50.0,
                        ),
                    ],
                  ),
                ),
              ),
              buildBottomView
            ],
          ),
        ),
      ),
    );
  }

  /// Build bottom view widget.
  Widget get buildBottomView => Obx(
        () => Hero(
          tag: 'verify_otp_bottom_view',
          child: Column(
            children: [
              appWhiteButton(
                  title: AppString.strSubmit,
                  isValidate: _controller.isValidated.value,
                  onClick: () => _controller.onSubmit()),
              const SizedBox(
                height: AppValues.screenMargin,
              ),
              buildResendCode(),
              const SizedBox(
                height: AppValues.screenMargin,
              ),
            ],
          ),
        ),
      );

  /// Build resend button widget.
  Widget buildResendCode() {
    return Obx(
      () => EasyRichText(
        AppString.resendText,
        patternList: [
          EasyRichTextPattern(
            targetString: AppString.resend,
            style: textTheme.displayLarge?.copyWith(
                color: _controller.counterTime.value == 0
                    ? AppColors.appRedButtonColor
                    : AppColors.appRedButtonColorDisable,
                fontWeight: FontWeight.w500),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                _controller.resendOTPAPI();
              },
          ),
        ],
        defaultStyle:
            textTheme.displayLarge?.copyWith(fontWeight: FontWeight.w300),
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
          // buildCenterLogoWidget(),
          const SizedBox(
            height: 20,
          ),
          Text(
            AppString.verification,
            style: textTheme.headlineLarge,
          ),
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0),
            child: Text(
              AppString.verificationMessage,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium
                  ?.copyWith(color: AppColors.textColorTernary),
            ),
          ),
        ],
      ),
    );
  }

  /// Build center logo widget.
  Widget buildCenterLogoWidget() {
    return SvgPicture.asset(
      AppImages.authenticationPlaceholder,
      height: AppValues.forgotPasswordLogo,
      width: AppValues.forgotPasswordLogo,
    );
  }

  Widget buildCountDownText() {
    return Obx(() => Text(
          "00.${(_controller.counterTime.value).toString().padLeft(2, "0")}",
          style:
              textTheme.bodyMedium?.copyWith(color: AppColors.textColorTernary),
        ));
  }

  /// Return widget for otp text field.
  Widget buildOTPTextField() {
    const fieldRadius = 5.0;

    return PinCodeTextField(
      onChanged: _controller.setOTP,
      length: VerifyController.PIN_LENGTH,
      cursorColor: AppColors.textFieldBackgroundColor,
      showCursor: false,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      enablePinAutofill: false,
      useHapticFeedback: false,
      focusNode: _controller.otpFocusNode,
      hapticFeedbackTypes: HapticFeedbackTypes.vibrate,
      appContext: buildContext,
      animationType: AnimationType.scale,
      hintCharacter: '-',
      pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderWidth: 0,
          fieldHeight: GetPlatform.isWeb
              ? (buildContext.width / 6) * 0.45
              : (buildContext.width / 4) * 0.45,
          fieldWidth: GetPlatform.isWeb
              ? (buildContext.width / 6) * 0.45
              : (buildContext.width / 4) * 0.45,
          activeFillColor: AppColors.textFieldBackgroundColor,
          activeColor: AppColors.textFieldBackgroundColor,
          selectedFillColor: AppColors.textPlaceholderColor,
          selectedColor: AppColors.textPlaceholderColor,
          inactiveFillColor: AppColors.textFieldBackgroundColor,
          inactiveColor: AppColors.textFieldBackgroundColor,
          disabledColor: AppColors.textColorLightTheme,
          borderRadius: BorderRadius.circular(fieldRadius)),
      keyboardType: TextInputType.number,
      animationDuration: const Duration(milliseconds: 300),
      textStyle: const TextStyle(color: AppColors.textColorLightTheme),
      backgroundColor: Colors.transparent,
      enableActiveFill: true,
      errorAnimationController: _controller.errorController,
      controller: _controller.otpTextFieldController,
    );
  }
}
