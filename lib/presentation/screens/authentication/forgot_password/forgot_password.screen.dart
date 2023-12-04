import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_on_flutter/presentation/app_widgets/user_feature_mixin.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:get/get.dart';

import '../../../../infrastructure/navigation/routes.dart';
import '../../../../values/app_images.dart';
import '../../../../values/app_values.dart';
import '../../../app_widgets/app_button_mixin.dart';
import '../../../app_widgets/app_input_field.dart';
import '../../../app_widgets/base_view.dart';
import 'controllers/forgot_password.controller.dart';

class ForgotPasswordScreen extends GetView<ForgotPasswordController>
    with AppBarMixin, AppButtonMixin, UserFeatureMixin {
  final ForgotPasswordController _controller =
      Get.find(tag: Routes.FORGOT_PASSWORD);

  ForgotPasswordScreen({Key? key}) : super(key: key);

  late TextTheme textTheme;
  late BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: buildAppBar(title: AppString.forgotPassword),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppValues.screenMargin,
            ),
            width: double.infinity,
            child: Obx(
              () => Form(
                key: _controller.forgotPasswordFormKey,
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: AppValues.screenMargin,
                          ),
                          buildClubEmail,
                          const SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                    appWhiteButton(
                        title: AppString.strSubmit,
                        isValidate: _controller.isValidField.value,
                        onClick: () => _controller.onSubmit()),
                    const SizedBox(
                      height: AppValues.screenMargin,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
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

  /// Build center content of welcome screen.
  Widget buildCenterContent() {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildCenterLogoWidget(),
        ],
      ),
    );
  }

  // /// Build scrollable fields.
  // Widget buildScrollableFields() {
  //   return Expanded(
  //     child: Column(
  //       children: [
  //         buildClubEmail,
  //         if (!isKeyboardHidden(buildContext))
  //           const SizedBox(
  //             height: 40,
  //           ),
  //         if (!isKeyboardHidden(buildContext))
  //           appWhiteButton(
  //               title: AppString.strSubmit,
  //               isValidate: _controller.isValidField.value,
  //               onClick: () => _controller.onSubmit()),
  //       ],
  //     ),
  //   );
  // }

  /// Build club email field.
  Widget get buildClubEmail => AppInputField(
        label: AppString.strEmail,
        isEmail: true,
        isLastField: true,
        controller: _controller.emailController,
        focusNode: _controller.emailFocusNode,
        errorText: _controller.emailError.value,
        isMandatory: true,
        denySpaces: true,
        onChange: _controller.setEmail,
      );
}
