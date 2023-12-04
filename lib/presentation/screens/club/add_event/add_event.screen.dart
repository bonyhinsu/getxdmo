import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_on_flutter/infrastructure/model/common/app_fields.dart';
import 'package:game_on_flutter/presentation/app_widgets/user_feature_mixin.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:game_on_flutter/values/app_values.dart';
import 'package:get/get.dart';

import '../../../../infrastructure/navigation/routes.dart';
import '../../../../values/app_colors.dart';
import '../../../../values/app_icons.dart';
import '../../../app_widgets/app_button_mixin.dart';
import '../../../app_widgets/app_dropdown_widget.dart';
import '../../../app_widgets/app_input_field.dart';
import '../../../app_widgets/app_textfield.dart';
import '../../../app_widgets/base_view.dart';
import 'controllers/add_event.controller.dart';

class AddEventScreen extends GetView<AddEventController>
    with AppBarMixin, AppButtonMixin, UserFeatureMixin {
  final AddEventController _controller = Get.find(tag: Routes.ADD_EVENT);

  AddEventScreen({Key? key}) : super(key: key);

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
        child: Scaffold(
          appBar: buildAppBar(
              title: _controller.postModel != null
                  ? AppString.updateEvent
                  : AppString.addEvent,
              onBackClick: _controller.onBackPressed),
          body: SafeArea(
            child: Obx(() => buildBody()),
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
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildTitleWidget,
                      Row(
                        children: [
                          Expanded(child: buildTimeField),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(child: buildDateField),
                        ],
                      ),
                      buildLocationWidget,
                      buildEventField,
                      // buildParticipantsRow(),
                      buildOtherInformation,
                      buildEventImage(),
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

  /// Build club title field.
  Widget get buildTitleWidget => AppInputField(
      label: AppString.strTitle,
      controller: _controller.titleController,
      focusNode: _controller.titleFocusNode,
      errorText: _controller.titleError.value,
      isCapWords: true,
      isPlainText: true,
      isMandatory: true,
      onChange: _controller.setTitle);

  /// Build event field.
  Widget get buildTimeField => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: AppValues.height_20,
          ),
          buildRichTextWidget(text: AppString.selectTime),
          const SizedBox(
            height: AppValues.margin_10,
          ),
          buildTimeTextField()
        ],
      );

  /// Build event field.
  Widget get buildDateField => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: AppValues.height_20,
          ),
          buildRichTextWidget(text: AppString.selectDate),
          const SizedBox(
            height: AppValues.margin_10,
          ),
          buildDateTextField()
        ],
      );

  /// Build club address field.
  Widget get buildClubAddress => AppInputField(
      label: AppString.strClubAddress,
      controller: _controller.clubAddressController,
      focusNode: _controller.clubAddressFocusNode,
      onTap: () => _controller.enableGooglePlaces(),
      onChange: _controller.setClubAddress);

  /// Build location field.
  Widget get buildLocationWidget => AppInputField(
      label: AppString.location,
      controller: _controller.locationController,
      focusNode: _controller.locationFocusNode,
      errorText: _controller.locationError.value,
      isCapWords: true,
      isMandatory: true,
      onChange: _controller.setLocation);

  /// Build event field.
  Widget get buildEventField => AppInputField(
      label: AppString.typeOfEvent,
      controller: _controller.eventTypeController,
      focusNode: _controller.eventTypeFocusNode,
      isCapWords: true,
      isMandatory: false,
      onChange: _controller.setTypeOfEvent);

  /// Build other information field.
  Widget get buildOtherInformation => AppInputField(
      label: AppString.otherDetails,
      isMultiLine: true,
      isLastField: true,
      controller: _controller.otherDetailsController,
      focusNode: _controller.otherDetailsFocusNode,
      onChange: _controller.setOtherDetails);

  /// Build participants row
  Widget buildParticipantsRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: AppValues.height_20,
        ),
        buildRichTextWidget(text: AppString.participants, isMandatory: false),
        const SizedBox(
          height: AppValues.margin_10,
        ),
        Row(
          children: [
            Expanded(
              child: AppDropdownWidget(
                items: _controller.teamAParticipants,
                onItemChanged: _controller.setParticipantsA,
                selectedItem: _controller.participantsA.value,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppValues.height_6),
              child: Text(
                AppString.strVS,
                style: textTheme.displaySmall?.copyWith(
                    color: AppColors.textColorSecondary.withOpacity(0.5)),
              ),
            ),
            Expanded(
              child: AppDropdownWidget(
                items: _controller.teamBParticipants,
                onItemChanged: _controller.setParticipantsB,
                selectedItem: _controller.participantsB.value,
              ),
            ),
          ],
        )
      ],
    );
  }

  /// Build time textfield.
  Widget buildTimeTextField() => AppTextField.underLineTextField(
        context: buildContext,
        hintColor: AppColors.inputFieldBorderColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
        isFocused: _controller.titleFocusNode.hasFocus,
        errorText: _controller.timeError.value,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppString.fieldDoesNotEmptyMessage;
          }
        },
        enabledWithTapOnly: true,
        hasError: _controller.timeError.value.isNotEmpty,
        controller: _controller.timeController,
        suffixIcon: buildTimeIcon(),
        onTap: () => _controller.openTimePicker(),
        onTextChange: _controller.setTime,
        focusNode: _controller.timeFocusNode,
      );

  /// Build date textfield.
  Widget buildDateTextField() => AppTextField.underLineTextField(
        context: buildContext,
        hintColor: AppColors.inputFieldBorderColor,
        onTap: () => _controller.openDatePicker(),
        enabledWithTapOnly: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
        isFocused: _controller.dateFocusNode.hasFocus,
        errorText: _controller.dateError.value,
        hasError: _controller.dateError.value.isNotEmpty,
        controller: _controller.dateController,
        suffixIcon: buildDateIcon(),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppString.fieldDoesNotEmptyMessage;
          }
        },
        onTextChange: _controller.setDate,
        focusNode: _controller.dateFocusNode,
      );

  /// Build time icon
  Widget buildTimeIcon() => Container(
      padding: const EdgeInsets.only(
          right: AppValues.padding_16,
          top: AppValues.mediumPadding,
          bottom: AppValues.mediumPadding,
          left: AppValues.padding_16),
      child: SvgPicture.asset(AppIcons.timeIcon));

  /// Build time icon
  Widget buildDateIcon() => Container(
      padding: const EdgeInsets.only(
          right: AppValues.padding_16,
          top: AppValues.mediumPadding,
          bottom: AppValues.mediumPadding,
          left: AppValues.padding_16),
      child: SvgPicture.asset(AppIcons.dateIcon));

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

  /// Build event image
  Widget buildEventImage() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: AppValues.height_20,
          ),
          buildRichTextWidget(text: AppString.image, isMandatory: false),
          const SizedBox(
            height: AppValues.margin_10,
          ),
          (_controller.eventBannerImage.value.image ?? "").isNotEmpty
              ? ((_controller.eventBannerImage.value.isUrl)
                  ? buildEditImageContainer()
                  : buildPickedFileContainer())
              : buildImagePlaceholder()
        ],
      );

  /// Build image placeholder widget.
  Widget buildImagePlaceholder() {
    return GestureDetector(
      onTap: () => _controller.captureImageFromInternal(),
      child: SizedBox(
        height: 150,
        width: double.infinity,
        child: DottedBorder(
          dashPattern: const [6, 6, 6, 6],
          strokeWidth: 1,
          color: AppColors.textPlaceholderColor,
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              AppString.clickTOAddEventImage,
              style: textTheme.displaySmall
                  ?.copyWith(color: AppColors.inputFieldBorderColor),
            ),
          ),
        ),
      ),
    );
  }

  /// Build file picker
  Widget buildPickedFileContainer() {
    return Stack(
      children: [
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppValues.size_10),
          ),
          clipBehavior: Clip.hardEdge,
          child: Image.file(
            File((_controller.eventBannerImage.value.image ?? "")),
            fit: BoxFit.fitWidth,
          ),
        ),
        Positioned(
            right: 0,
            child: IconButton(
                onPressed: _controller.removePicture,
                icon: SvgPicture.asset(AppIcons.iconDeleteRound))),
      ],
    );
  }

  /// Build load image from network
  Widget buildEditImageContainer() {
    return Stack(
      children: [
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppValues.size_10),
          ),
          clipBehavior: Clip.hardEdge,
          child: CachedNetworkImage(
            imageUrl: '${AppFields.instance.imagePrefix}${_controller.eventBannerImage.value.image ?? ""}',
            fit: BoxFit.fitWidth,
            fadeOutDuration: const Duration(seconds: 1),
            fadeInDuration: const Duration(seconds: 1),
            errorWidget: (_, __, ___) {
              if ((_controller.postModel?.eventImage ?? "")
                  .contains("assets/")) {
                return Image.asset(
                  _controller.postModel?.eventImage ?? "",
                  fit: BoxFit.fitWidth,
                );
              }
              return Container();
            },
            placeholder: (context, url) {
              return const SizedBox(
                height: 150,
                width: 150,
                child: Center(
                    child: SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 2,
                        ))),
              );
            },
          ),
        ),
        Positioned(
            right: 0,
            child: IconButton(
                onPressed: _controller.removePicture,
                icon: SvgPicture.asset(AppIcons.iconDeleteRound))),
      ],
    );
  }
}
