import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_on_flutter/presentation/app_widgets/user_feature_mixin.dart';
import 'package:get/get.dart';

import '../../../../../../../infrastructure/navigation/routes.dart';
import '../../../../../../../values/app_colors.dart';
import '../../../../../../../values/app_icons.dart';
import '../../../../../../../values/app_string.dart';
import '../../../../../../../values/app_values.dart';
import '../../../../../../app_widgets/app_button_mixin.dart';
import '../../../../../../app_widgets/app_dropdown_widget.dart';
import '../../../../../../app_widgets/app_input_field.dart';
import '../../../../../../app_widgets/app_textfield.dart';
import '../../../../../../app_widgets/base_bottomsheet.dart';
import '../../../../../../app_widgets/base_view.dart';
import '../../../club_board_members/controllers/club_board_members.controller.dart';
import '../../../club_board_members/model/club_member_model.dart';
import '../controller/add_club_coach.controller.dart';

class AddClubCoachBottomSheet extends StatelessWidget
    with AppBarMixin, AppButtonMixin, UserFeatureMixin {
  late AddClubCoachController _controller =
      Get.find(tag: Routes.CLUB_ADD_COACHING_STAFF);

  AddClubCoachBottomSheet(
      {bool editDetail = false, ClubMemberModel? model, Key? key}) {
    _controller.isEditMember = editDetail;
    if (editDetail && model != null) {
      _controller.addExistingDataToFields(model);
    }
  }

  late TextTheme textTheme;
  late BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    textTheme = Theme.of(context).textTheme;
    buildContext = context;
    return BaseBottomsheet(
      title: _controller.isEditMember
          ? AppString.updateCoachingStaff
          : AppString.addCoachingStaff,
      child: SizedBox(
        height: (!isKeyboardHidden(context)) ? deviceHeight * 0.80 : deviceHeight * 0.85 ,
        child: Obx(
          () => Form(
            key: _controller.formKey,
            child: SingleChildScrollView(
              controller: _controller.scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildName,
                  buildEmail,
                  buildPhoneNumber,
                  buildPersonalDetailRow(),
                  buildExperience(),
                  buildSpeciality,
                  SizedBox(
                    height: isKeyboardHidden(context) ? 20.0 : 20,
                  ),
                  buildNextButton(),
                  SizedBox(
                    height: !isKeyboardHidden(context) ? 350 : 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build personal detail row
  Widget buildPersonalDetailRow() => Row(
        children: [
          Expanded(child: buildDateOfBirth()),
          const SizedBox(
            width: 10,
          ),
          Expanded(child: buildGenderRow())
        ],
      );

  /// Build name field.
  Widget get buildName => AppInputField(
      label: AppString.name,
      controller: _controller.nameController,
      focusNode: _controller.nameFocusNode,
      errorText: _controller.nameError.value,
      isMandatory: true,
      isPlainText: true,
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

  /// Build speciality field.
  Widget get buildSpeciality => AppInputField(
      label: AppString.strSpeciality,
      controller: _controller.specialityController,
      focusNode: _controller.specialityFocusNode,
      isMandatory: true,
      fromBottomSheet: true,
      isCapWords: true,
      isLastField: true,
      onChange: _controller.setSpeciality);

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

  /// Build date of birth text field.
  Widget buildDateOfBirth() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: AppValues.margin_20,
          ),
          buildRichTextWidget(
              text: AppString.strDateOfBirth, isMandatory: true),
          const SizedBox(
            height: AppValues.margin_10,
          ),
          buildDateOfBirthInputField(),
        ],
      );

  /// Build experience text field.
  Widget buildExperience() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: AppValues.margin_20,
          ),
          buildRichTextWidget(text: AppString.experience, isMandatory: true),
          const SizedBox(
            height: AppValues.margin_10,
          ),
          AppDropdownWidget(
            items: _controller.experience,
            onItemChanged: _controller.setExperience,
            selectedItem: _controller.experienceValue.value,
            fromBottomSheet: true,
          ),
        ],
      );

  /// Build date of birth input field.
  Widget buildDateOfBirthInputField() {
    return AppTextField.underLineTextField(
      context: buildContext,
      contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
      isFocused: _controller.dobFocusNode.hasFocus,
      errorText: _controller.dobError.value,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppString.fieldDoesNotEmptyMessage;
        }
        return null;
      },
      fromBottomSheet: true,
      enabledWithTapOnly: true,
      enabled: false,
      onTap: () => _controller.openDatePicker(),
      suffixIcon: buildDateIcon(),
      hasError: _controller.dobError.value.isNotEmpty,
      controller: _controller.dobController,
      onTextChange: _controller.setDob,
      focusNode: _controller.dobFocusNode,
    );
  }

  /// Build time icon
  Widget buildDateIcon() => Container(
      padding: const EdgeInsets.only(
          right: AppValues.padding_16,
          top: AppValues.mediumPadding,
          bottom: AppValues.mediumPadding,
          left: AppValues.padding_16),
      child: SvgPicture.asset(AppIcons.dateIcon));

  /// Build gender row
  Widget buildGenderRow() {
    Get.log(_controller.gender.value);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: AppValues.height_20,
        ),
        buildRichTextWidget(text: AppString.gender, isMandatory: true),
        const SizedBox(
          height: AppValues.margin_10,
        ),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _controller.genders.length,
            itemBuilder: (_, index) => GestureDetector(
              onTap: () => _controller.setGender(_controller.genders[index]),
              child: Row(
                children: [
                  Radio(
                    key: Key(_controller.gender.value),
                    groupValue: _controller.gender.value,
                    value: _controller.genders[index],
                    visualDensity: VisualDensity.compact,
                    fillColor: MaterialStateColor.resolveWith(
                        (states) => AppColors.appRedButtonColor),
                    //<-- SEE HERE
                    onChanged: (value) {
                      _controller.setGender(_controller.genders[index]);
                    },
                  ),
                  Text(
                    _controller.genders[index],
                    style: textTheme.displaySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Widget build Text widget
  Widget buildRichTextWidget({required String text, bool isMandatory = true}) {
    return EasyRichText(
      "$text${isMandatory ? '*' : ''}",
      patternList: [
        EasyRichTextPattern(
          targetString: '(\\*)',
          matchLeftWordBoundary: false,
          style: textTheme.displayLarge?.copyWith(
            color: AppColors.errorColor,
          ),
        ),
      ],
      defaultStyle: textTheme.displayLarge,
    );
  }

  /// Build save button.
  Widget buildNextButton() => appWhiteButton(
        title:
            _controller.isEditMember ? AppString.strUpdate : AppString.strSave,
        isValidate: _controller.isValidField.value,
        onClick: () => _controller.submitForm(),
      );
}
