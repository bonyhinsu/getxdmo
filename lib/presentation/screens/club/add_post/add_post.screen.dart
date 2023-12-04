import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_on_flutter/infrastructure/model/common/app_fields.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_button_mixin.dart';
import 'package:game_on_flutter/presentation/app_widgets/club_profile_widget.dart';
import 'package:get/get.dart';

import '../../../../infrastructure/navigation/routes.dart';
import '../../../../values/app_colors.dart';
import '../../../../values/app_font_size.dart';
import '../../../../values/app_icons.dart';
import '../../../../values/app_string.dart';
import '../../../../values/app_values.dart';
import '../../../app_widgets/app_textfield.dart';
import '../../../app_widgets/base_view.dart';
import '../../../app_widgets/slider_indicator_widget.dart';
import 'controllers/add_post.controller.dart';

class AddPostScreen extends GetView<AddPostController>
    with AppBarMixin, AppButtonMixin {
  final AddPostController _controller = Get.find(tag: Routes.ADD_POST);

  late TextTheme textTheme;
  late BuildContext buildContext;
  RxInt dotIndex = 0.obs;

  AddPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    buildContext = context;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: WillPopScope(
        onWillPop: _controller.willPopCallback,
        child: Obx(
          () => Scaffold(
            appBar: buildScreenAppbar(),
            body: SafeArea(child: buildBody()),
          ),
        ),
      ),
    );
  }

  /// Return screen add post widget
  AppBar buildScreenAppbar() => AppBar(
        elevation: 0,
        backgroundColor: AppColors.pageBackground,
        leadingWidth: AppValues.appbarBackButtonSize + AppValues.screenMargin,
        centerTitle: true,
        leading: FittedBox(
          fit: BoxFit.contain,
          child: buildIconButton(
              icon: AppIcons.postCloseIcon, onClick: _controller.onBackPressed),
        ),
        title: buildTitleText(
            title: _controller.postModel.value?.postDescription != null
                ? AppString.strUpdatePost
                : AppString.strAddPost,
            isMainTitle: true),
        actions: [buildPostButton()],
      );

  /// Return back button widget.
  Widget buildIconButton({Function? onClick, required String icon}) =>
      GestureDetector(
        onTap: onClick == null ? () => Get.back() : () => onClick(),
        child: Container(
          margin: const EdgeInsets.only(
              left: AppValues.screenMargin, top: AppValues.appbarTopMargin),
          decoration: BoxDecoration(
              border:
                  Border.all(color: AppColors.inputFieldBorderColor, width: 1),
              color: AppColors.textColorSecondary.withOpacity(0.20),
              borderRadius: BorderRadius.circular(AppValues.smallRadius)),
          height: AppValues.appbarBackButtonSize,
          width: AppValues.appbarBackButtonSize,
          padding: const EdgeInsets.all(AppValues.smallPadding),
          child: SvgPicture.asset(icon),
        ),
      );

  /// Build post button
  Widget buildPostButton() => Obx(
        () => Container(
          height: AppValues.height_40,
          margin: const EdgeInsets.only(
              right: AppValues.screenMargin, top: AppValues.appbarTopMargin),
          padding: const EdgeInsets.symmetric(vertical: AppValues.height_6),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppValues.radius_4),
            child: ElevatedButton(
              onPressed: _controller.submit,
              style: ElevatedButton.styleFrom(
                  backgroundColor: !_controller.isValidField.value
                      ? AppColors.textColorSecondary.withOpacity(0.10)
                      : AppColors.textColorSecondary.withOpacity(0.20),
                  splashFactory: NoSplash.splashFactory,
                  visualDensity: VisualDensity.comfortable,
                  padding: const EdgeInsets.symmetric(
                      vertical: AppValues.size_10,
                      horizontal: AppValues.size_15)),
              child: Center(
                child: Text(
                  _controller.postModel.value?.postDescription != null
                      ? AppString.strUpdate
                      : AppString.post,
                  style: TextStyle(
                      color: !_controller.isValidField.value
                          ? AppColors.textColorSecondary.withOpacity(0.1)
                          : AppColors.textColorSecondary,
                      fontFamily: FontConstants.poppins,
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ),
      );

  /// Build body widget.
  Widget buildBody() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppValues.screenMargin),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: AppValues.size_30,
              ),
              buildClubHeaderRow(),
              const SizedBox(
                height: AppValues.height_20,
              ),
              if (_controller.postImageUrl.isNotEmpty)
                Stack(
                  children: [
                    buildExistingImageContainer(),
                    if (_controller.postImageUrl.length > 1)
                      Positioned(
                        bottom: 5,
                        right: 0,
                        left: 0,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: AppValues.height_8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _buildPageIndicator(),
                          ),
                        ),
                      ),
                  ],
                ),
              buildPostTextField(),
              const SizedBox(
                height: AppValues.size_30,
              ),
            ],
          ),
        ),
      );

  /// Build post input textfield
  Widget buildPostTextField() {
    return AppTextField.multilineTextField(
      context: buildContext,
      backgroundColor: Colors.transparent,
      enableFocusBorder: false,
      isTextInputActionEnter: true,
      contentPadding: const EdgeInsets.symmetric(vertical: AppValues.height_4),
      isFocused: _controller.postFocusNode.hasFocus,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppString.fieldDoesNotEmptyMessage;
        }
        return null;
      },
      hintColor: AppColors.switchColorTernary,
      hintText: AppString.addPostHintText,
      keyboardType: TextInputType.multiline,
      maxLines: AppValues.addPostMaxLine,
      maxLength: AppValues.addPostMaxCharacterLength,
      controller: _controller.postController,
      onTextChange: _controller.setText,
      focusNode: _controller.postFocusNode,
    );
  }

  /// Build header row widget.
  Widget buildClubHeaderRow() => Row(
        children: [
          buildClubProfilePicture(),
          const SizedBox(
            width: AppValues.size_10,
          ),
          Expanded(child: buildClubNameText()),
          const SizedBox(
            width: AppValues.size_30,
          ),
          if (_controller.enableAddIcon.isTrue)
            buildIconButton(
                icon: AppIcons.postCaptureIcon,
                onClick: () => _controller.captureImageFromInternal()),
        ],
      );

  /// Build club profile picture.
  Widget buildClubProfilePicture() {
    const editIconSize = 42.0;
    return ClubProfileWidget(
      profileURL: _controller.clubProfile ?? "",
      width: editIconSize,
      height: editIconSize,
    );
  }

  /// Build club name widget
  Widget buildClubNameText() => Text(
        _controller.clubName,
        style: textTheme.bodyLarge,
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
              AppString.clickToAddPostImage,
              style: textTheme.displaySmall
                  ?.copyWith(color: AppColors.inputFieldBorderColor),
            ),
          ),
        ),
      ),
    );
  }

  /// Build image picker
  Widget buildExistingImageContainer() {
    return Container(
      height: 300,
      padding: const EdgeInsets.only(top: AppValues.margin_20),
      child: PageView.builder(
        onPageChanged: (value) {
          dotIndex.value = value;
        },
        itemCount: _controller.postImageUrl.length,
        controller: _controller.pagerController,
        itemBuilder: (BuildContext context, int itemIndex) {
          final imageObj = _controller.postImageUrl[itemIndex];
          return Stack(
            fit: StackFit.expand,
            children: [
              Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppValues.size_10),
                ),
                child: imageObj.isUrl
                    ? CachedNetworkImage(
                        imageUrl:
                            "${AppFields.instance.imagePrefix}${(imageObj.image ?? "")}",
                        fit: BoxFit.fitWidth,
                        fadeOutDuration: const Duration(seconds: 1),
                        fadeInDuration: const Duration(seconds: 1),
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
                      )
                    : Image.file(
                        File(imageObj.image ?? ""),
                        fit: BoxFit.cover,
                      ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: IconButton(
                  onPressed: () => _controller.removeProfile(itemIndex),
                  icon: SvgPicture.asset(AppIcons.iconDeleteRound),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// build page indicator for paged view.
  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < (_controller.postImageUrl ?? []).length; i++) {
      list.add(i == dotIndex.value
          ? SliderIndicatorWidget(
              isActive: true,
            )
          : SliderIndicatorWidget(isActive: false));
    }
    return list;
  }
}
