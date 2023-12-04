import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_shimmer.dart';
import 'package:game_on_flutter/values/app_images.dart';
import 'package:get/get.dart';

import '../../../../infrastructure/navigation/routes.dart';
import '../../../../values/app_colors.dart';
import '../../../../values/app_constant.dart';
import '../../../../values/app_icons.dart';
import '../../../../values/app_string.dart';
import '../../../../values/app_values.dart';
import '../../../app_widgets/app_button_mixin.dart';
import '../../../app_widgets/app_input_field.dart';
import '../../../app_widgets/app_player_profile_widget.dart';
import '../../../app_widgets/app_textfield.dart';
import '../../../app_widgets/base_view.dart';
import '../../../app_widgets/user_feature_mixin.dart';
import '../../club/signup/register_club_details/controllers/register_club_details.controller.dart';
import 'controllers/register_player_detail.controller.dart';

class RegisterPlayerDetailScreen extends GetView<RegisterPlayerDetailController>
    with AppBarMixin, AppButtonMixin, UserFeatureMixin {
  final RegisterPlayerDetailController _controller =
      Get.find(tag: Routes.REGISTER_PLAYER_DETAIL);

  RegisterPlayerDetailScreen({Key? key}) : super(key: key);

  late TextTheme textTheme;
  late BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    buildContext = context;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: buildAppBar(
          title: _controller.playerDetailViewTypeEnum ==
                  PlayerDetailViewTypeEnum.register
              ? AppString.strSignUp
              : _controller.playerDetailViewTypeEnum ==
                      PlayerDetailViewTypeEnum.editPlayerDetail
                  ? AppString.updatePersonalInformation
                  : AppString.editProfile,
        ),
        body: SafeArea(
          child: GestureDetector(
            onTap: () => removeFocus(context),
            child: Obx(() => buildBody(context)),
          ),
        ),
      ),
    );
  }

  /// Widget build body.
  Widget buildBody(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppValues.screenMargin),
        child: Form(
          key: _controller.formKey,
          child: Column(
            children: [
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildClubProfileView(),
                    buildNameField,
                    buildDateOfBirth(),
                    buildGenderRow(),
                    buildDetailRow(),
                    buildPhoneNumber,
                    buildEmail,
                    if (_controller.playerDetailViewTypeEnum ==
                        PlayerDetailViewTypeEnum.register)
                      buildPasswordField,
                    buildClubVideo,
                    buildClubBio,
                    buildPlayerPhoto(),
                    buildReferenceField,
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              )),
              appWhiteButton(
                  title: _controller.playerDetailViewTypeEnum !=
                          PlayerDetailViewTypeEnum.register
                      ? AppString.strUpdate
                      : AppString.strSubmit,
                  isValidate: _controller.isValidField.value,
                  onClick: () => _controller.onSubmit())
            ],
          ),
        ),
      );

  /// Build scrollable fields.
  Widget buildScrollableFields() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: AppValues.screenMargin),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildClubProfileView(),
          buildNameField,
          buildDateOfBirth(),
          buildGenderRow(),
          buildDetailRow(),
          buildPhoneNumber,
          buildEmail,
          if (_controller.playerDetailViewTypeEnum ==
              PlayerDetailViewTypeEnum.register)
            buildPasswordField,
          buildClubVideo,
          buildClubBio,
          buildPlayerPhoto(),
          buildReferenceField,
          if (!isKeyboardHidden(buildContext))
            Padding(
              padding: const EdgeInsets.only(top: AppValues.height_20),
              child: appWhiteButton(
                  title: _controller.playerDetailViewTypeEnum ==
                          PlayerDetailViewTypeEnum.register
                      ? AppString.strSubmit
                      : AppString.strUpdate,
                  isValidate: _controller.isValidField.value,
                  onClick: () => _controller.onSubmit()),
            )
        ],
      ),
    );
  }

  /// Build detail row
  Widget buildDetailRow() => Row(
        children: [
          Expanded(
            child: buildHeightTextField(),
          ),
          const SizedBox(
            width: AppValues.margin_20,
          ),
          Expanded(
            child: buildWeightTextField(),
          )
        ],
      );

  /// Build date of birth text field.
  Widget buildDateOfBirth() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: AppValues.margin_20,
          ),
          buildRichTextWidget(
              text: AppString.strDateOfBirth, isMandatory: true, textUnit: ""),
          const SizedBox(
            height: AppValues.margin_10,
          ),
          buildDateOfBirthInputField(),
        ],
      );

  /// Build name field.
  Widget get buildNameField => AppInputField(
      label: AppString.name,
      controller: _controller.nameController,
      focusNode: _controller.nameFocusNode,
      errorText: _controller.clubNameError.value,
      isMandatory: true,
      isPlainText: true,
      isCapWords: true,
      onSubmit: _controller.onNameSubmit,
      onChange: _controller.setName);

  /// Build player phone number field.
  Widget get buildPhoneNumber => AppInputField(
      label: AppString.phoneNo,
      controller: _controller.phoneNumberController,
      focusNode: _controller.phoneNumberFocusNode,
      errorText: _controller.phoneNumberError.value,
      isMandatory: true,
      isPhoneNumber: true,
      onChange: _controller.setPhoneNumber);

  /// Build club email field.
  Widget get buildEmail => AppInputField(
      label: AppString.strEmail,
      isEmail: true,
      controller: _controller.emailController,
      focusNode: _controller.emailFocusNode,
      errorText: _controller.emailError.value,
      isMandatory: true,
      enableEmail: _controller.playerDetailViewTypeEnum ==
          PlayerDetailViewTypeEnum.register,
      denySpaces: true,
      onChange: _controller.setEmail);

  /// Build password field.
  Widget get buildPasswordField => AppInputField(
      label: AppString.strPassword,
      isPassword: true,
      enablePasswordToggle: true,
      controller: _controller.passwordController,
      focusNode: _controller.passwordFocusNode,
      errorText: _controller.passwordError.value,
      isMandatory: true,
      onChange: _controller.setPassword);

  /// Build video field.
  Widget get buildClubVideo => AppInputField(
      label: AppString.video,
      controller: _controller.videoController,
      focusNode: _controller.videoFocusNode,
      denySpaces: true,
      errorText: _controller.videoError.value,
      onChange: _controller.setVideo);

  /// Build intro field.
  Widget get buildClubIntro => AppInputField(
      label: AppString.intro,
      isMultiLine: true,
      controller: _controller.introController,
      focusNode: _controller.introFocusNode,
      onChange: _controller.setIntro);

  /// Build intro field.
  Widget get buildClubBio => AppInputField(
      label: AppString.bio.toUpperCase(),
      isMultiLine: true,
      controller: _controller.bioController,
      focusNode: _controller.bioFocusNode,
      onChange: _controller.setBio);

  /// Build reference field.
  Widget get buildReferenceField => AppInputField(
      label: AppString.reference,
      isLastField: true,
      isMultiLine: true,
      controller: _controller.referenceController,
      focusNode: _controller.referenceFocusNode,
      onChange: _controller.setClubOtherInformation);

  /// Build player photo row,
  Widget buildPlayerPhoto() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: AppValues.margin_20,
        ),
        Row(
          children: [
            Text(
              AppString.additionalPhotos,
              style: textTheme.displayLarge,
            ),
            const Spacer(),
            if (_controller.enableViewAll.isTrue &&
                _controller.enableAddIcon.isTrue)
              GestureDetector(
                onTap: () => _controller.capturePlayerAdditionalImage(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(AppIcons.iconAdd),
                    Text(
                      AppString.strAddImages,
                      style: textTheme.displaySmall,
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(
          height: AppValues.margin_10,
        ),
        // _controller.isLoading.isTrue
        //     ? buildClubPhotoContainerShimmers()
        buildClubPhotoContainer(),
      ],
    );
  }

  /// Club Profile View.
  Widget buildClubProfileView() {
    const containerSize = 110.0;
    const editIconSize = 30.0;
    return GestureDetector(
      onTap: () => _controller.captureImageFromInternal(),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppValues.margin_30),
        height: containerSize,
        width: containerSize,
        child: Stack(
          children: [
            Container(
              height: containerSize,
              width: containerSize,
              decoration: BoxDecoration(
                  color: AppColors.placeholderBackground,
                  borderRadius: BorderRadius.circular(AppValues.fullRadius)),
              child: AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: ((_controller.playerProfileImage.value.image ?? "")
                            .isNotEmpty &&
                        _controller.playerProfileImage.value.isUrl == false)
                    ? buildUserProfileFromFile()
                    : AppPlayerProfileWidget(
                        profileURL:
                            _controller.playerProfileImage.value.image ?? "",
                        height: containerSize,
                        width: containerSize,
                      ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () => _controller.captureImageFromInternal(),
                child: SvgPicture.asset(
                  _controller.playerProfileImage.value.imageAvailable
                      ? AppIcons.profileCloseIcon
                      : AppIcons.profileEditIcon,
                  width: editIconSize,
                  height: editIconSize,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Container buildClubPhotoContainer() {
    List<ClubProfileImage> imageList = _controller.playerImages;
    if (_controller.enableViewAll.isTrue) {
      imageList = _controller.playerImages
          .sublist(0, (AppConstants.MAX_IMAGE_TO_SHOW - 1));
    } else {
      imageList = _controller.playerImages;
    }
    return Container(
      decoration: BoxDecoration(
          color: AppColors.textFieldBackgroundColor,
          borderRadius: BorderRadius.circular(AppValues.smallRadius)),
      height: 110,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(AppValues.size_15),
        child: ListView.separated(
            separatorBuilder: (_, __) {
              return const SizedBox(
                width: AppValues.size_15,
              );
            },
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) {
              if (_controller.enableAddIcon.isTrue &&
                  _controller.enableViewAll.isFalse) {
                if (index == _controller.playerImages.length) {
                  return buildPlusIcon();
                }
              }
              if (_controller.enableViewAll.isTrue) {
                if (index == (AppConstants.MAX_IMAGE_TO_SHOW - 1)) {
                  return buildViewIcon();
                }
              }
              return buildImagePreview(model: imageList[index], pos: index);
            },
            itemCount: imageList.length +
                ((_controller.enableAddIcon.isTrue ||
                        _controller.enableViewAll.isTrue)
                    ? 1
                    : 0)),
      ),
    );
  }

  /// Build plus icon to add new photo.
  Widget buildViewIcon() {
    return InkWell(
      onTap: () => _controller.navigateToAdditionalImage(),
      child: Container(
        height: AppValues.height_80,
        width: AppValues.height_80,
        decoration: BoxDecoration(
            color: AppColors.textFieldBackgroundColor,
            border: Border.all(
              color: AppColors.textColorSecondary,
            ),
            borderRadius: BorderRadius.circular(AppValues.radius_6)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: AppValues.largeMargin,
              width: AppValues.largeMargin,
              decoration: BoxDecoration(
                  color: AppColors.textColorSecondary.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(AppValues.radius_3)),
              child: RotatedBox(
                  quarterTurns: 3, child: SvgPicture.asset(AppIcons.downArrow)),
            ),
            const SizedBox(
              height: AppValues.margin_4,
            ),
            Text(
              AppString.strViewAll,
              style: textTheme.displaySmall
                  ?.copyWith(fontSize: 8, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
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

  /// Build image preview widget.
  ///
  /// required imagePath.
  /// required pos.
  Widget buildImagePreview(
      {required ClubProfileImage model, required int pos}) {
    return Container(
        height: AppValues.height_80,
        width: AppValues.height_80,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            color: AppColors.appWhiteButtonColorDisable.withOpacity(0.10),
            borderRadius: BorderRadius.circular(AppValues.radius_6)),
        child: Stack(
          children: [
            SizedBox(
              height: AppValues.height_80,
              width: AppValues.height_80,
              child: model.isURL
                  ? CachedNetworkImage(
                      imageUrl: model.path ?? "",
                      fit: BoxFit.cover,
                      fadeOutDuration: const Duration(seconds: 1),
                      fadeInDuration: const Duration(seconds: 1),
                      placeholder: (context, url) {
                        return AppShimmer(
                          child: const SizedBox(
                            height: 70,
                            width: 70,
                            child: Center(
                                child: SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                      strokeWidth: 2,
                                    ))),
                          ),
                        );
                      },
                    )
                  // ? Image.network(
                  //     model.path ?? "",
                  //     fit: BoxFit.fill,
                  //   )
                  : model.path!.isNotEmpty
                      ? Image.file(
                          File(model.path ?? ""),
                          fit: BoxFit.cover,
                        )
                      : Container(),
            ),
            Positioned(
              right: 4,
              top: 4,
              child: SizedBox(
                height: AppValues.height_18,
                width: AppValues.height_18,
                child: GestureDetector(
                    onTap: () => _controller.removeImageFromPosition(pos),
                    child: SvgPicture.asset(AppIcons.iconDeleteRound)),
              ),
            ),
          ],
        ));
  }

  /// Build user profile from file widget.
  Widget buildUserProfileFromFile() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppValues.fullRadius),
      child: Image.file(
        File(_controller.playerProfileImage.value.image ?? ""),
        fit: BoxFit.cover,
      ),
    );
  }

  /// Build user profile from file widget.
  Widget buildProfilePlaceholder() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppValues.fullRadius),
      child: SvgPicture.asset(
        AppImages.noPlayerImage,
        fit: BoxFit.cover,
      ),
    );
  }

  /// Build plus icon to add new photo.
  Widget buildPlusIcon() {
    return InkWell(
      onTap: () => _controller.capturePlayerAdditionalImage(),
      child: Container(
        height: AppValues.height_80,
        width: AppValues.height_80,
        decoration: BoxDecoration(
            color: AppColors.textFieldBackgroundColor,
            border: Border.all(
              color: AppColors.textColorSecondary,
            ),
            borderRadius: BorderRadius.circular(AppValues.radius_6)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: AppValues.largeMargin,
              width: AppValues.largeMargin,
              decoration: BoxDecoration(
                  color: AppColors.textColorSecondary.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(AppValues.radius_3)),
              child: SvgPicture.asset(AppIcons.iconAdd),
            ),
            const SizedBox(
              height: AppValues.margin_4,
            ),
            Text(
              AppString.addImages,
              style: textTheme.displaySmall
                  ?.copyWith(fontSize: 8, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  /// Build height text field
  Widget buildHeightTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: AppValues.height_20,
        ),
        buildRichTextWidget(
            text: AppString.height,
            isMandatory: true,
            textUnit: AppString.heightUnit),
        const SizedBox(
          height: AppValues.margin_10,
        ),
        buildHeightInputField(),
      ],
    );
  }

  /// Build weight text field
  Widget buildWeightTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: AppValues.height_20,
        ),
        buildRichTextWidget(
            text: AppString.weight,
            isMandatory: true,
            textUnit: AppString.weightUnit),
        const SizedBox(
          height: AppValues.margin_10,
        ),
        buildWeightInputField(),
      ],
    );
  }

  /// Build gender row
  Widget buildGenderRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: AppValues.height_20,
        ),
        buildRichTextWidget(
            text: AppString.gender, isMandatory: true, textUnit: ""),
        const SizedBox(
          height: AppValues.margin_10,
        ),
        buildGenderList(),
      ],
    );
  }

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
      enabledWithTapOnly: true,
      enabled: true,
      onTap: () => _controller.openDatePicker(),
      suffixIcon: buildDateIcon(),
      hasError: _controller.dobError.value.isNotEmpty,
      controller: _controller.dobController,
      onTextChange: _controller.setDateOfBirth,
      focusNode: _controller.dobFocusNode,
    );
  }

  /// Build height input field.
  Widget buildHeightInputField() {
    return AppTextField.underLineTextField(
      context: buildContext,
      contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
      isFocused: _controller.heightFocusNode.hasFocus,
      errorText: _controller.heightError.value,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppString.fieldDoesNotEmptyMessage;
        }
        return null;
      },
      inputFormator: [
        FilteringTextInputFormatter(RegExp("[0-9\u0027\u0022]"), allow: true),
      ],
      maxLength: 6,
      keyboardType: TextInputType.number,
      hasError: _controller.heightError.value.isNotEmpty,
      controller: _controller.heightController,
      onTextChange: _controller.setHeight,
      focusNode: _controller.heightFocusNode,
    );
  }

  /// Build weight input field.
  Widget buildWeightInputField() {
    return AppTextField.underLineTextField(
      context: buildContext,
      contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
      isFocused: _controller.weightFocusNode.hasFocus,
      errorText: _controller.weightError.value,
      maxLength: 4,
      keyboardType:
          const TextInputType.numberWithOptions(decimal: true, signed: true),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppString.fieldDoesNotEmptyMessage;
        }
        return null;
      },
      hasError: _controller.weightError.value.isNotEmpty,
      controller: _controller.weightController,
      onTextChange: _controller.setWeight,
      focusNode: _controller.weightFocusNode,
    );
  }

  /// Widget build Text widget
  Widget buildRichTextWidget(
      {required String text,
      required String textUnit,
      bool isMandatory = true}) {
    return EasyRichText(
      "$text ${textUnit}${isMandatory ? '*' : ''}",
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

  /// Build gender row widget.
  Widget buildGenderList() {
    print(' _controller.gender.value${_controller.gender.value.title}');
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _controller.genders.length,
        itemBuilder: (_, index) {
          return GestureDetector(
            onTap: () => _controller.setGender(_controller.genders[index]),
            child: Row(
              children: [
                SizedBox(
                  height: AppValues.iconSize_20,
                  width: AppValues.iconSize_20,
                  child: Radio(
                    key: Key(_controller.genders[index].title ?? ""),
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
                ),
                const SizedBox(
                  width: AppValues.height_4,
                ),
                Text(
                  _controller.genders[index].title ?? "",
                  style: textTheme.displaySmall,
                ),
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            const VerticalDivider(
          width: 8,
          color: Colors.transparent,
        ),
      ),
    );
  }
}
