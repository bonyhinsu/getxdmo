import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_button_mixin.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_input_field.dart';
import 'package:game_on_flutter/presentation/app_widgets/base_view.dart';
import 'package:game_on_flutter/presentation/app_widgets/club_profile_widget.dart';
import 'package:game_on_flutter/values/app_colors.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:game_on_flutter/values/app_values.dart';
import 'package:get/get.dart';

import '../../../../../infrastructure/model/common/app_fields.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../values/app_constant.dart';
import '../../../../../values/app_icons.dart';
import '../../../../app_widgets/app_shimmer.dart';
import '../../../../app_widgets/user_feature_mixin.dart';
import 'controllers/register_club_details.controller.dart';

class RegisterClubDetailsScreen extends GetView<RegisterClubDetailsController>
    with AppBarMixin, AppButtonMixin, UserFeatureMixin {
  final RegisterClubDetailsController _controller =
      Get.find(tag: Routes.REGISTER_CLUB_DETAILS);

  RegisterClubDetailsScreen({Key? key}) : super(key: key);

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
          title: _controller.clubDetailViewTypeEnum ==
                  ClubDetailViewTypeEnum.register
              ? AppString.strSignUp
              : _controller.clubDetailViewTypeEnum ==
                      ClubDetailViewTypeEnum.editClubDetail
                  ? AppString.updateClubInformation
                  : AppString.editProfile,
        ),
        body: SafeArea(
          child: Obx(() => buildBody(context)),
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
                    buildClubNameField,
                    buildClubPhoneNumber,
                    buildClubAddress,
                    buildClubEmail,
                    if (_controller.clubDetailViewTypeEnum ==
                        ClubDetailViewTypeEnum.register)
                      buildPasswordField,
                    buildClubVideo,
                    buildClubIntro,
                    buildClubBio,
                    buildClubPhoto(),
                    buildClubOtherInformation,
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              )),
              appWhiteButton(
                  title: _controller.clubDetailViewTypeEnum ==
                          ClubDetailViewTypeEnum.register
                      ? AppString.strSubmit
                      : AppString.strUpdate,
                  isValidate: _controller.isValidField.value,
                  onClick: () => _controller.onSubmit()),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      );

  /// Build scrollable fields.
  Widget buildScrollableFields() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildClubProfileView(),
          buildClubNameField,
          buildClubPhoneNumber,
          buildClubAddress,
          buildClubEmail,
          if (_controller.clubDetailViewTypeEnum ==
              ClubDetailViewTypeEnum.register)
            buildPasswordField,
          buildClubVideo,
          buildClubIntro,
          buildClubBio,
          buildClubPhoto(),
          buildClubOtherInformation,
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }

  /// Build club name field.
  Widget get buildClubNameField => AppInputField(
      label: AppString.strClubName,
      controller: _controller.clubNameController,
      focusNode: _controller.clubNameFocusNode,
      errorText: _controller.clubNameError.value,
      isMandatory: true,
      isPlainText: true,
      isCapWords: true,
      onChange: _controller.setClubName);

  /// Build club phone number field.
  Widget get buildClubPhoneNumber => AppInputField(
      label: AppString.strClubPhoneNumber,
      controller: _controller.clubPhoneNumberController,
      focusNode: _controller.clubPhoneNumberFocusNode,
      errorText: _controller.phoneNumberError.value,
      isMandatory: true,
      isPhoneNumber: true,
      onChange: _controller.setClubPhoneNumber);

  /// Build club address field.
  Widget get buildClubAddress => AppInputField(
      label: AppString.strClubAddress,
      controller: _controller.clubAddressController,
      focusNode: _controller.clubAddressFocusNode,
      onTap: () => _controller.enableGooglePlaces(),
      onChange: _controller.setClubAddress);

  /// Build club email field.
  Widget get buildClubEmail => AppInputField(
      label: AppString.strClubEmail,
      isEmail: true,
      enableEmail:
          _controller.clubDetailViewTypeEnum != ClubDetailViewTypeEnum.register
              ? false
              : true,
      controller: _controller.clubEmailController,
      focusNode: _controller.clubEmailFocusNode,
      errorText: _controller.emailError.value,
      isMandatory: true,
      denySpaces: true,
      onChange: _controller.setClubEmail);

  /// Build password field.
  Widget get buildPasswordField => AppInputField(
      label: AppString.strPassword,
      isPassword: true,
      enablePasswordToggle: true,
      controller: _controller.passwordController,
      focusNode: _controller.passwordFocusNode,
      errorText: _controller.passwordError.value,
      isMandatory: true,
      onChange: _controller.setClubPassword);

  /// Build club video field.
  Widget get buildClubVideo => AppInputField(
      label: AppString.clubVideo,
      controller: _controller.clubVideoController,
      focusNode: _controller.clubVideoFocusNode,
      errorText: _controller.videoError.value,
      denySpaces: true,
      onChange: _controller.setClubVideo);

  /// Build club intro field.
  Widget get buildClubIntro => AppInputField(
      label: AppString.clubIntro,
      isMultiLine: true,
      controller: _controller.clubIntroController,
      focusNode: _controller.clubIntroFocusNode,
      onChange: _controller.setClubIntro);

  /// Build club intro field.
  Widget get buildClubBio => AppInputField(
      label: AppString.clubBio,
      isMultiLine: true,
      controller: _controller.clubBioController,
      focusNode: _controller.clubBioFocusNode,
      onChange: _controller.setClubBio);

  /// Build club intro field.
  Widget get buildClubOtherInformation => AppInputField(
      label: AppString.clubOtherInformation,
      isLastField: true,
      isMultiLine: true,
      controller: _controller.clubOtherInformationController,
      focusNode: _controller.clubOtherInformationFocusNode,
      onChange: _controller.setClubOtherInformation);

  /// Build club photo row,
  Widget buildClubPhoto() {
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
                onTap: () => _controller.captureClubImage(),
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
        buildClubPhotoContainer(),
      ],
    );
  }

  /// Build club photo container.
  Container buildClubPhotoContainer() {
    List<ClubProfileImage> imageList = _controller.clubImages;
    if (_controller.enableViewAll.isTrue) {
      imageList = _controller.clubImages
          .sublist(0, (AppConstants.MAX_IMAGE_TO_SHOW - 1));
    } else {
      imageList = _controller.clubImages;
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
                if (index == _controller.clubImages.length) {
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
                  : Image.file(
                      File(model.path ?? ""),
                      fit: BoxFit.cover,
                    ),
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

  /// Build plus icon to add new photo.
  Widget buildPlusIcon() {
    return InkWell(
      onTap: () => _controller.captureClubImage(),
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
                child: ((_controller.clubProfileImage.value.image ?? "")
                            .isNotEmpty &&
                        _controller.clubProfileImage.value.isUrl == false)
                    ? buildUserProfileFromFile()
                    : ClubProfileWidget(
                        profileURL:
                            _controller.clubProfileImage.value.image ?? "",
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
                  _controller.clubProfileImage.value.imageAvailable
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

  /// Build user profile from file widget.
  Widget buildUserProfileFromFile() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppValues.fullRadius),
      child: Image.file(
        File(_controller.clubProfileImage.value.image ?? ""),
        fit: BoxFit.cover,
      ),
    );
  }

  /// Build user profile from file widget.
  Widget buildProfilePlaceholder() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppValues.fullRadius),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SvgPicture.asset(
          AppIcons.iconClubProfile,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
