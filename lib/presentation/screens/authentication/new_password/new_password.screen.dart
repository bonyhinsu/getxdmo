import 'package:flutter/material.dart';
import 'package:game_on_flutter/presentation/app_widgets/user_feature_mixin.dart';
import 'package:get/get.dart';

import '../../../../infrastructure/navigation/routes.dart';
import '../../../../values/app_colors.dart';
import '../../../../values/app_string.dart';
import '../../../../values/app_values.dart';
import '../../../app_widgets/app_button_mixin.dart';
import '../../../app_widgets/app_input_field.dart';
import '../../../app_widgets/base_view.dart';
import 'controllers/new_password.controller.dart';

class NewPasswordScreen extends GetView<NewPasswordController>
    with AppBarMixin, AppButtonMixin, UserFeatureMixin {
  NewPasswordScreen({Key? key}) : super(key: key);

  final NewPasswordController _controller = Get.find(tag: Routes.NEW_PASSWORD);

  late TextTheme textTheme;
  late BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    textTheme = Theme.of(context).textTheme;
    return Obx(()=>GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: buildAppBar(
            title: _controller.isChangePassword.isTrue
                ? AppString.strChangePassword
                : AppString.createNewPassword, backEnable: _controller.isChangePassword.isTrue),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppValues.screenMargin,
            ),
            width: double.infinity,
            child: Obx(
              () => Form(
                key: _controller.newPasswordFormKey,
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
                              height: 30.0,
                            ),
                            newPasswordText,
                            buildNewPasswordField,
                            buildConfirmPasswordField,
                            SizedBox(
                              height: isKeyboardHidden(context) ? 20.0 : 60,
                            ),

                          ],
                        ),
                      ),
                    ),
                    buildBottomButton,
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
    ),
    );
  }

  /// Build new password text.
  Text get newPasswordText => Text(
        AppString.createNewPasswordInfoText,
        textAlign: TextAlign.center,
        style: textTheme.bodyMedium?.copyWith(
          color: AppColors.textColorTernary,
        ),
      );

  /// Build new password field.
  Widget get buildNewPasswordField => AppInputField(
        label: AppString.newPassword,

        isPassword: true,
        controller: _controller.newPasswordController,
        focusNode: _controller.newPasswordFocusNode,
        errorText: _controller.newPasswordError.value,
        isMandatory: true,
        denySpaces: true,
        onChange: _controller.setNewPassword,
      );

  /// Build confirm password field.
  Widget get buildConfirmPasswordField => AppInputField(
        label: AppString.strConfirmPassword,

        isPassword: true,
        controller: _controller.confirmPasswordController,
        focusNode: _controller.confirmPasswordFocusNode,
        errorText: _controller.confirmPasswordError.value,
        isMandatory: true,
        denySpaces: true,
        isLastField: true,
        onChange: _controller.setConfirmPassword,
      );

  /// Build old password field.
  Widget get buildOldPasswordTextField => AppInputField(
        label: AppString.strOldPassword,

        isPassword: true,
        controller: _controller.existingPasswordController,
        focusNode: _controller.existingPasswordFocusNode,
        errorText: _controller.existingPasswordError.value,
        isMandatory: _controller.isChangePassword.isTrue,
        denySpaces: true,
        onChange: _controller.setExistingPassword,
      );

  /// Build bottom button.
  Widget get buildBottomButton => appWhiteButton(
      title: AppString.strUpdate,
      isValidate: _controller.isValidFields.value,
      onClick: () => _controller.onSubmit());
}
