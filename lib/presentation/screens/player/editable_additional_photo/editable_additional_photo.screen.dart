import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../infrastructure/navigation/routes.dart';
import '../../../../values/app_colors.dart';
import '../../../../values/app_icons.dart';
import '../../../../values/app_images.dart';
import '../../../../values/app_string.dart';
import '../../../../values/app_values.dart';
import '../../../app_widgets/app_button_mixin.dart';
import '../../../app_widgets/app_shimmer.dart';
import '../../../app_widgets/base_view.dart';
import '../../../app_widgets/user_feature_mixin.dart';
import '../../club/signup/register_club_details/controllers/register_club_details.controller.dart';
import 'controllers/editable_additional_photo.controller.dart';

class EditableAdditionalPhotoScreen
    extends GetView<EditableAdditionalPhotoController>
    with AppBarMixin, AppButtonMixin, UserFeatureMixin {
  final EditableAdditionalPhotoController _controller =
      Get.find(tag: Routes.EDITABLE_ADDITIONAL_PHOTOS);

  EditableAdditionalPhotoScreen({Key? key}) : super(key: key);

  late TextTheme textTheme;
  late BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    buildContext = context;
    return Obx(() => Scaffold(
          appBar: buildAppBar(
              title: AppString.additionalPhotos,
              onBackClick: _controller.onBackPressed),
          floatingActionButton:
              _controller.enableAddIcon.isTrue ? buildAddFab() : null,
          body: buildBody(),
        ));
  }

  /// add floating action button.
  Widget buildAddFab() => Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppValues.height_20,
        ),
        child: FloatingActionButton(
          onPressed: () => _controller.captureClubImage(),
          backgroundColor: AppColors.fabButtonBackgroundChange,
          child: SvgPicture.asset(
            AppIcons.iconAdd,
            width: AppValues.iconSize_28,
            height: AppValues.iconSize_28,
            color: AppColors.textColorDarkGray,
          ),
        ),
      );

  /// Build body widget.
  Widget buildBody() => Padding(
        padding: const EdgeInsets.all(AppValues.screenMargin),
        child: buildGridContainer(),
      );

  Widget buildGridContainer() {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1.0,
            crossAxisSpacing: AppValues.height_16,
            mainAxisSpacing: AppValues.height_16),
        itemCount: _controller.images.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext ctx, index) {
          return GestureDetector(
            onTap: () => _controller.onImageClick(
                _controller.images[index], "imagePreview_$index", index),
            child: FittedBox(
              fit: BoxFit.cover,
              clipBehavior: Clip.hardEdge,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppValues.radius_12),
                child: buildImageView(_controller.images[index], index),
              ),
            ),
          );
        });
  }

  /// build image view.
  Widget buildImageView(ClubProfileImage model, int index) => Hero(
        tag: 'imagePreview_$index',
        child: Container(
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
                            fit: BoxFit.fill,
                            placeholder: (context, url) => AppShimmer(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(AppValues.radius_6),
                                ),
                                height: 100,
                                width: 100,
                              ),
                            ),
                            errorWidget: (context, url, error) => blankClubIcon,
                          )
                        : Image.file(
                            File(model.path ?? ""),
                            fit: BoxFit.fill,
                            height: 100,
                            width: 100,
                          )),
                Positioned(
                  right: 4,
                  top: 4,
                  child: SizedBox(
                    height: AppValues.height_18,
                    width: AppValues.height_18,
                    child: GestureDetector(
                        onTap: () => _controller.removeImageFromPosition(index),
                        child: SvgPicture.asset(AppIcons.iconDeleteRound)),
                  ),
                ),
              ],
            )),
      );

  /// player blank icon.
  SvgPicture get blankClubIcon => SvgPicture.asset(
        AppImages.planBackground,
      );
}
