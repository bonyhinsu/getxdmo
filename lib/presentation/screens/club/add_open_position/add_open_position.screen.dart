import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../infrastructure/navigation/routes.dart';
import '../../../../values/app_colors.dart';
import '../../../../values/app_string.dart';
import '../../../../values/app_values.dart';
import '../../../app_widgets/app_button_mixin.dart';
import '../../../app_widgets/app_dropdown_widget.dart';
import '../../../app_widgets/app_input_field.dart';
import '../../../app_widgets/base_view.dart';
import '../../../app_widgets/user_feature_mixin.dart';
import 'controllers/add_open_position.controller.dart';

class AddOpenPositionScreen extends GetView<AddOpenPositionController>
    with AppBarMixin, AppButtonMixin, UserFeatureMixin {
  AddOpenPositionScreen({Key? key}) : super(key: key);

  final AddOpenPositionController _controller =
      Get.find(tag: Routes.ADD_OPEN_POSITION);

  late TextTheme textTheme;
  late BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    buildContext = context;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: WillPopScope(
        onWillPop: _controller.willPopCallback,
        child: Obx(() => Scaffold(
          appBar: buildAppBar(
              title: _controller.postModel == null
                  ? AppString.addOpenPosition
                  : AppString.updateOpenPosition,
              onBackClick: _controller.onBackPressed),
          body: SafeArea(
            child: buildBody()),
          ),
        ),
      ),
    );
  }

  /// Build body widget
  Widget buildBody() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppValues.screenMargin),
        child: Form(
          key: _controller.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildPositionNameWidget,
                      Row(
                        children: [
                          Expanded(child: buildAgeField),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(child: buildGenderRow()),
                        ],
                      ),
                      buildLocationWidget,
                      buildLevelRow(),
                      buildDetailsField,
                      buildReferenceField,
                      buildSkillField,
                      if (!isKeyboardHidden(buildContext))
                        const SizedBox(
                          height: AppValues.screenMargin,
                        ),
                      if (!isKeyboardHidden(buildContext))
                        appWhiteButton(
                            title: AppString.post,
                            isValidate: _controller.isValidField.value,
                            onClick: () => _controller.onSubmit()),
                      if (!isKeyboardHidden(buildContext))
                        const SizedBox(
                          height: AppValues.screenMargin,
                        ),
                    ],
                  ),
                ),
              ),
              if (isKeyboardHidden(buildContext))
                const SizedBox(
                  height: AppValues.screenMargin,
                ),
              if (isKeyboardHidden(buildContext))
                appWhiteButton(
                    title: AppString.post,
                    isValidate: _controller.isValidField.value,
                    onClick: () => _controller.onSubmit()),
              if (isKeyboardHidden(buildContext))
                const SizedBox(
                  height: AppValues.screenMargin,
                ),
            ],
          ),
        ),
      );

  /// Build position name field.
  Widget get buildPositionNameWidget => AppInputField(
      label: AppString.positionName,
      controller: _controller.positionController,
      focusNode: _controller.positionFocusNode,
      errorText: _controller.positionError.value,
      isCapWords: true,
      isMandatory: true,
      onChange: _controller.setPositionName);

  /// Build location field.
  Widget get buildLocationWidget => AppInputField(
      label: AppString.location,
      controller: _controller.locationController,
      focusNode: _controller.locationFocusNode,
      errorText: _controller.locationError.value,
      isMandatory: true,
      onChange: _controller.setLocation);

  /// Build age field.
  Widget get buildAgeField => AppInputField(
      label: AppString.age,
      controller: _controller.ageController,
      focusNode: _controller.ageFocusNode,
      isMandatory: true,
      maxLength: 2,
      onChange: _controller.setAge);

  /// Build reference field.
  Widget get buildDetailsField => AppInputField(
      label: AppString.description,
      isMultiLine: true,
      controller: _controller.descriptionController,
      focusNode: _controller.descriptionFocusNode,
      onChange: _controller.setDetails);

  /// Build reference field.
  Widget get buildReferenceField => AppInputField(
      label: AppString.reference,
      controller: _controller.referenceController,
      focusNode: _controller.referenceFocusNode,
      onChange: _controller.setReference);

  /// Build skill field.
  Widget get buildSkillField => AppInputField(
      label: AppString.skill,
      isLastField: true,
      controller: _controller.skillController,
      focusNode: _controller.skillsFocusNode,
      onChange: _controller.setSkills);

  /// Build level row
  Widget buildLevelRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: AppValues.height_20,
        ),
        buildRichTextWidget(text: AppString.level, isMandatory: false),
        const SizedBox(
          height: AppValues.margin_10,
        ),
        AppDropdownWidget(
          items: _controller.listLevel,
          onItemChanged: _controller.setLevel,
          selectedItem: _controller.level.value,
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
}
