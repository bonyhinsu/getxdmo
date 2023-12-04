import 'package:flutter/material.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_button_mixin.dart';
import 'package:game_on_flutter/presentation/app_widgets/user_feature_mixin.dart';
import 'package:get/get.dart';

import '../../../../../values/app_string.dart';
import '../../../../app_widgets/app_input_field.dart';
import '../../../../app_widgets/base_bottomsheet.dart';
import '../club_board_members/model/club_member_model.dart';
import 'controllers/add_member_bottomsheet.controller.dart';

class AddMemberBottomsheet extends StatelessWidget
    with AppButtonMixin, UserFeatureMixin {
  String bottomSheetTag;

  late AddMemberBottomsheetController _controller;

  AddMemberBottomsheet(
      {required this.bottomSheetTag,
      String bottomSheetTitle = "",
      bool enableRole = false,
      bool isEditMember = false,
      int editMemberIndex = -1,
      ClubMemberModel? details,
      int? userId,
      int? role,
      Key? key}) {
    _controller = Get.find(tag: bottomSheetTag);
    _controller.bottomSheetTitle = bottomSheetTitle;
    _controller.enableRole = enableRole;
    _controller.userId = userId ?? -1;
    _controller.setBottomSheetTag(bottomSheetTag);
    if (isEditMember) {
      if (details != null) {
        _controller.setMemberData(details, editMemberIndex);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final bottomBarHeight = deviceHeight * 0.5;
    final bottomBarHeight2 = deviceHeight * 0.4;
    return BaseBottomsheet(
      title: _controller.bottomSheetTitle,
      child: Obx(
        () => SizedBox(
          height: _controller.enableRole && (!isKeyboardHidden(context))
              ? bottomBarHeight
              : !(isKeyboardHidden(context))
                  ? bottomBarHeight2
                  : null,
          child: Form(
            key: _controller.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildName,
                        if (_controller.enableRole) buildRoleWidget,
                        buildEmail,
                        buildPhoneNumber,
                        const SizedBox(
                          height: 20.0,
                        ),
                        buildNextButton(),
                        const SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build name field.
  Widget get buildName => AppInputField(
      label: AppString.name,
      controller: _controller.nameController,
      focusNode: _controller.nameFocusNode,
      errorText: _controller.nameError.value,
      isMandatory: true,
      isCapWords: true,
      fromBottomSheet: true,
      onChange: _controller.setName);

  /// Build email field.
  Widget get buildEmail => AppInputField(
      label: AppString.email,
      controller: _controller.emailController,
      focusNode: _controller.emailFocusNode,
      errorText: _controller.emailError.value,
      isMandatory: true,
      denySpaces: true,
      isEmail: true,
      fromBottomSheet: true,
      onChange: _controller.setEmail);

  /// Build user role field.
  Widget get buildRoleWidget => AppInputField(
      label: AppString.strRole,
      controller: _controller.roleController,
      focusNode: _controller.roleFocusNode,
      isMandatory: true,
      fromBottomSheet: true,
      isCapWords: true,
      onChange: _controller.setRole);

  /// Build phone number field.
  Widget get buildPhoneNumber => AppInputField(
      label: AppString.strContact,
      isPhoneNumber: true,
      controller: _controller.phoneController,
      focusNode: _controller.phoneFocusNode,
      errorText: _controller.phoneError.value,
      isMandatory: true,
      denySpaces: true,
      fromBottomSheet: true,
      isLastField: true,
      onChange: _controller.setPhone);

  /// Build save button.
  Widget buildNextButton() => appWhiteButton(
        title:
            _controller.isEditMember ? AppString.strUpdate : AppString.strSave,
        isValidate: _controller.isValidField.value,
        onClick: () => _controller.submitForm(),
      );
}
