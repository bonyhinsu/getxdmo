import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_on_flutter/infrastructure/model/common/app_fields.dart';
import 'package:game_on_flutter/presentation/app_widgets/club_profile_widget.dart';
import 'package:get/get.dart';

import '../../../../infrastructure/navigation/routes.dart';
import '../../../../values/app_colors.dart';
import '../../../../values/app_icons.dart';
import '../../../../values/app_values.dart';
import '../../../custom_widgets/profile_menu_tile_widget.dart';
import 'controllers/club_profile.controller.dart';

class ClubProfileScreen extends GetView<ClubProfileController> {
  final ClubProfileController _controller = Get.find(tag: Routes.CLUB_PROFILE);

  ClubProfileScreen({Key? key}) : super(key: key);

  late TextTheme textTheme;
  late BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.screenMargin,
      ),
      width: double.infinity,
      child: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildHeaderLogoWidget(),
            Expanded(child: buildMenuListWidget())
          ],
        ),
      ),
    );
  }

  Widget buildHeaderLogoWidget() {
    return Container(
      color: AppColors.pageBackground,
      width: double.infinity,
      child: Column(
        children: [
          buildClubProfileView(),
          buildClubProfileTitle(),
          const SizedBox(
            height: 4,
          ),
          buildClubProfileEmail(),
          const SizedBox(
            height: AppValues.margin_10,
          ),
        ],
      ),
    );
  }

  /// Build club profile image widget.
  Widget buildClubProfileTitle() {
    return Text(
      _controller.userDetails.value.name ?? "",
      textAlign: TextAlign.center,
      style: textTheme.headlineLarge?.copyWith(fontSize: 25),
    );
  }

  /// Build club profile image widget.
  Widget buildClubProfileEmail() {
    return Text(
      _controller.userDetails.value.email ?? "",
      textAlign: TextAlign.center,
      style: textTheme.headlineSmall?.copyWith(fontSize: 13),
    );
  }

  /// Club Profile View.
  Widget buildClubProfileView() {
    const containerSize = 110.0;
    const editIconSize = 30.0;
    return Obx(
      () => GestureDetector(
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
                child: ((_controller.playerProfileImage.value.image ?? "")
                            .isNotEmpty &&
                        _controller.playerProfileImage.value.isUrl == false)
                    ? buildUserProfileFromFile()
                    : ClubProfileWidget(
                        profileURL:
                            _controller.playerProfileImage.value.image ?? "",
                        height: containerSize,
                        width: containerSize,
                      ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: () => _controller.captureImageFromInternal(),
                  child: Container(
                    width: editIconSize,
                    height: editIconSize,
                    padding: EdgeInsets.all(
                        _controller.playerProfileImage.value.imageAvailable
                            ? 4
                            : 5),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(AppValues.smallRadius),
                      border: Border.all(
                          color: AppColors.appRedButtonColor.withOpacity(0.2),
                          width: 1),
                      color: AppColors.appRedButtonColor,
                    ),
                    child: SvgPicture.asset(
                      _controller.playerProfileImage.value.imageAvailable
                          ? AppIcons.postCloseIcon
                          : AppIcons.iconEditNew,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Build user profile from network widget.
  Widget buildUserProfileFromNetwork() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppValues.fullRadius),
      child: Image.network(
        '${AppFields.instance.imagePrefix}${_controller.clubProfilePicture}',
        fit: BoxFit.cover,
      ),
    );
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
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SvgPicture.asset(
          AppIcons.iconClubProfile,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  /// Build menu list widget.
  Widget buildMenuListWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppValues.margin_10),
      child: ListView.separated(
        itemCount: _controller.menuList.length,
        itemBuilder: (_, index) {
          return ProfileMenuTileWidget(
              model: _controller.menuList[index],
              onClick: _controller.onItemClick);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            height: AppValues.margin_10,
            color: Colors.transparent,
          );
        },
      ),
    );
  }
}
