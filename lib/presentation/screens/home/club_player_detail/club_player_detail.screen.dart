import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_button_mixin.dart';
import 'package:game_on_flutter/presentation/app_widgets/base_view.dart';
import 'package:game_on_flutter/presentation/screens/home/club_player_detail/view/player_detail_tab_widget.dart';
import 'package:game_on_flutter/values/common_utils.dart';
import 'package:get/get.dart';

import '../../../../infrastructure/navigation/routes.dart';
import '../../../../values/app_colors.dart';
import '../../../../values/app_icons.dart';
import '../../../../values/app_string.dart';
import '../../../../values/app_values.dart';
import '../../../app_widgets/app_like_widget.dart';
import '../../../app_widgets/app_player_profile_widget.dart';
import '../../../app_widgets/app_shimmer.dart';
import 'club_detail_shimmer_widget.dart';
import 'controllers/club_player_detail.controller.dart';

class ClubPlayerDetailScreen extends GetView<ClubPlayerDetailController>
    with AppBarMixin, AppButtonMixin, ClubDetailShimmerWidget {
  final ClubPlayerDetailController _controller =
      Get.find(tag: Routes.CLUB_PLAYER_DETAIL);

  late TextTheme textTheme;

  ClubPlayerDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return Obx(() => Scaffold(
          appBar: buildAppBarWithActions(
              title: _controller.userDetails.value.name ?? "",
              centerTitle: true,
              backEnable: true,
              actions: [favoriteWidget()]),
          body: SafeArea(child: buildBody(context)),
        ));
  }

  /// Widget build body.
  Widget buildBody(BuildContext context) => Padding(
        padding: const EdgeInsets.all(AppValues.screenMargin),
        child: SingleChildScrollView(
          controller: _controller.scrollController,
          physics: _controller.isLoading.isTrue
              ? const NeverScrollableScrollPhysics()
              : const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: AppValues.height_10,
              ),
              buildHeaderUserDetail(),
              const SizedBox(
                height: AppValues.height_20,
              ),
              buildClubUserActionButtonRow(),
              const SizedBox(
                height: AppValues.height_20,
              ),
              if ((_controller.userDetails.value.bio ?? "").isNotEmpty) getBio,
              if ((_controller.userDetails.value.bio ?? "").isNotEmpty)
              const SizedBox(
                height: AppValues.height_20,
              ),
              physicallyInfoBuild(),
              const SizedBox(
                height: AppValues.height_20,
              ),
              buildMoreInformation(),
              const SizedBox(
                height: AppValues.height_20,
              ),
              PlayerDetailTabWidget(
                clubListModel: _controller.userDetails.value,
                tabController: _controller.tabController,
                selectedIndex: _controller.currentSelectedIndex.value,
                onImageViewAll: _controller.onViewALL,
                onTabClick: _controller.navigateToBottom,
                onImageClick: _controller.onImageClick,
                onVideoClick: _controller.onVideoClick,
              )
            ],
          ),
        ),
      );

  /// Build more information widget.
  Widget buildMoreInformation() {
    final sportDetails =
        (_controller.userDetails.value.userSportsDetails ?? []);
    final positionDetail =
        (_controller.userDetails.value.playerPositionDetails ?? []);

    // Prepare location name arraylist
    List<String> comaSeparatedLocations = sportDetails.isNotEmpty
        ? (sportDetails.first.userLocationDetails ?? [])
            .map((e) => e.locationDetails?.name ?? "")
            .toList()
        : [];
    // Remove empty value from the list.
    comaSeparatedLocations.removeWhere((element) => element.isEmpty);

    // Prepare level name arraylist
    List<String> comaSeparatedLevels = sportDetails.isNotEmpty
        ? (sportDetails.first.userLevelDetails ?? [])
            .map((e) => e.levelDetails?.name ?? "")
            .toList()
        : [];
    // Remove empty value from the list.
    comaSeparatedLevels.removeWhere((element) => element.isEmpty);

    // Prepare sports name arraylist
    List<String> comaSeparatedSports = sportDetails.isNotEmpty
        ? [sportDetails.first.sportTypeDetails?.name ?? ""]
        : [];

    // Prepare sports name arraylist
    List<String> comaSeparatedPosition = positionDetail.isNotEmpty
        ? [positionDetail.first.positionData?.name ?? ""]
        : [];
    return Column(
      children: [
        Align(alignment: Alignment.topLeft, child: buildInfoLabel()),
        const SizedBox(
          height: AppValues.height_20,
        ),
        buildInformation(AppString.location, comaSeparatedLocations.join(', '),
            AppIcons.locationBase),
        const SizedBox(
          height: AppValues.height_14,
        ),
        buildInformation(AppString.level, comaSeparatedLevels.join(', '),
            AppIcons.lavelBase),
        const SizedBox(
          height: AppValues.height_14,
        ),
        buildInformation(AppString.sports, comaSeparatedSports.join(', '),
            AppIcons.sportsIcon,
            isImageIcon: true),
        const SizedBox(
          height: AppValues.height_14,
        ),
        buildInformation(AppString.preferredLocation,
            comaSeparatedPosition.join(', '), AppIcons.preffered_positionbase),
      ],
    );
  }

  Widget get getBio => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildBioLabel(),
          const SizedBox(
            height: AppValues.height_10,
          ),
          buildBio(),
        ],
      );

  /// build action button row widget
  Widget buildClubUserActionButtonRow() => Row(
        children: [
          Expanded(child: buildFollowingWidget()),
          const SizedBox(
            width: 10,
          ),
          Expanded(child: buildFollowerWidget()),
          const SizedBox(
            width: 10,
          ),
          Expanded(child: buildMessageWidget())
        ],
      );

  Widget buildHeaderUserDetail() => Column(
        children: [
          AppPlayerProfileWidget(
            isAssetUrl: false,
            profileURL: _controller.userDetails.value.profileImage ?? "",
            width: 74,
            height: 74,
          ),
          const SizedBox(
            height: 10,
          ),
          buildTextName(),
          const SizedBox(
            height: 10,
          ),
          mobileWidget(),
          const SizedBox(
            height: 10,
          ),
          mailWidget(),
        ],
      );

  /// build information widget
  Widget buildInformation(
    String label,
    String result,
    String icon, {
    bool isImageIcon = false,
  }) {
    return Row(
      children: [
        !isImageIcon
            ? SvgPicture.asset(
                icon,
                width: AppValues.size_30,
                height: AppValues.size_30,
              )
            : Image.asset(
                icon,
                width: AppValues.size_30,
                height: AppValues.size_30,
              ),
        const SizedBox(
          width: 10,
        ),
        Text(
          label,
          textAlign: TextAlign.start,
          style: textTheme.bodyMedium
              ?.copyWith(color: AppColors.textColorWhite, fontSize: 13),
        ),
        const SizedBox(
          width: 4,
        ),
        Expanded(
          flex: 3,
          child: Text(
            result,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium
                ?.copyWith(color: AppColors.textColorDarkGray, fontSize: 13),
          ),
        ),
      ],
    );
  }

  /// build physically info
  Widget physicallyInfoBuild() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: buildPhysicallyDetailItem(AppString.height,
                _controller.userDetails.value.height ?? "", 'cms'),
          ),
          const SizedBox(
            width: AppValues.height_10,
          ),
          Expanded(
            child: buildPhysicallyDetailItem(AppString.weight,
                _controller.userDetails.value.weight ?? "", 'kgs'),
          ),
          const SizedBox(
            width: AppValues.height_10,
          ),
          Expanded(
            child: buildPhysicallyDetailItem(AppString.age,
                _controller.userDetails.value.age ?? "", "years"),
          ),
        ],
      ),
    );
  }

  /// Build physically detail item.
  Widget buildPhysicallyDetailItem(String title, String value, String unit) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textColorSecondary,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 15,
          ),
          AnimatedSwitcher(
            duration: const Duration(
                milliseconds: AppValues.shimmerWidgetChangeDurationInMillis),
            child: _controller.isLoading.isTrue
                ? AppShimmer(
                    child: Container(
                      height: 16,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  )
                : Text(
                    '$value${unit.isNotEmpty ? ' $unit' : ''}',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textColorDarkGray,
                        fontWeight: FontWeight.w500),
                  ),
          )
        ],
      );

  /// build bio widget
  Widget buildBioLabel() {
    return Text(
      AppString.bio,
      textAlign: TextAlign.start,
      style: textTheme.headlineMedium?.copyWith(
          color: AppColors.textColorPrimary, fontWeight: FontWeight.w600),
    );
  }

  /// build more information widget
  Widget buildInfoLabel() {
    return Text(
      AppString.moreInformation,
      textAlign: TextAlign.center,
      style: textTheme.headlineMedium?.copyWith(
          color: AppColors.textColorPrimary, fontWeight: FontWeight.w600),
    );
  }

  /// build bio widget test@yopma.com
  Widget buildBio() {
    return AnimatedSwitcher(
      duration: const Duration(
          milliseconds: AppValues.shimmerWidgetChangeDurationInMillis),
      child: _controller.isLoading.isTrue
          ? AppShimmer(
              child: Column(
                children: [
                  Container(
                    height: 16,
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 8),
                    color: Colors.white.withOpacity(0.5),
                  ),
                  Container(
                    height: 16,
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 8),
                    color: Colors.white.withOpacity(0.5),
                  ),
                  Container(
                    height: 16,
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 8),
                    color: Colors.white.withOpacity(0.5),
                  ),
                ],
              ),
            )
          : Text(
              "${_controller.userDetails.value.bio}",
              textAlign: TextAlign.start,
              style: textTheme.displaySmall
                  ?.copyWith(color: AppColors.textColorDarkGray, fontSize: 13),
            ),
    );
  }

  /// build following widget
  Widget buildFollowingWidget() {
    return AnimatedSwitcher(
      duration: const Duration(
          milliseconds: AppValues.shimmerWidgetChangeDurationInMillis),
      child: _controller.isLoading.isTrue
          ? AppShimmer(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(AppValues.radius_6),
                ),
              ),
            )
          : _controller.followedUser.isTrue
              ? appGrayButton(
                  title: AppString.following,
                  onClick: _controller.showUnfollowUserDialog)
              : appRedSecondaryButton(
                  title: AppString.strFollow,
                  onClick: _controller.onFollowClick),
    );
  }

  /// build follower widget
  Widget buildFollowerWidget() {
    return AnimatedSwitcher(
      duration: const Duration(
          milliseconds: AppValues.shimmerWidgetChangeDurationInMillis),
      child: _controller.isLoading.isTrue
          ? AppShimmer(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(AppValues.radius_6),
                ),
              ),
            )
          : appGrayButton(
              title:
                  "${CommonUtils.numberToWordsWithZero(_controller.userDetails.value.followerCount ?? 0)} ${AppString.followers}",
              onClick: () {}),
    );
  }

  /// build messages widget
  Widget buildMessageWidget() {
    return AnimatedSwitcher(
      duration: const Duration(
          milliseconds: AppValues.shimmerWidgetChangeDurationInMillis),
      child: _controller.isLoading.isTrue
          ? AppShimmer(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(AppValues.radius_6),
                ),
              ),
            )
          : appGrayButton(
              disabledButton: _controller.followedUser.isFalse,
              title: AppString.messages,
              onClick: _controller.onMessageClick),
    );
  }

  ///build mobile widget
  Widget mobileWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          AppIcons.iconCall,
          height: 16,
          width: 16,
        ),
        const SizedBox(
          width: 10,
        ),
        buildMobileText(),
      ],
    );
  }

  ///build mail widget
  Widget mailWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          AppIcons.iconMessage,
          height: 16,
          width: 16,
        ),
        const SizedBox(
          width: 10,
        ),
        buildMailText()
      ],
    );
  }

  /// Build mobile content.
  Widget buildMobileText() => AnimatedSwitcher(
        duration: const Duration(
            milliseconds: AppValues.shimmerWidgetChangeDurationInMillis),
        child: _controller.isLoading.isTrue
            ? AppShimmer(
                child: Container(
                  height: 16,
                  width: 100,
                  color: Colors.white.withOpacity(0.5),
                ),
              )
            : Text(
                _controller.userDetails.value.phoneNumber ?? "",
                textAlign: TextAlign.start,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium
                    ?.copyWith(color: AppColors.textColorDarkGray),
              ),
      );

  /// Build mobile content.
  Widget buildMailText() => AnimatedSwitcher(
        duration: const Duration(
            milliseconds: AppValues.shimmerWidgetChangeDurationInMillis),
        child: _controller.isLoading.isTrue
            ? AppShimmer(
                child: Container(
                  height: 16,
                  width: 160,
                  color: Colors.white.withOpacity(0.5),
                ),
              )
            : Text(
                _controller.userDetails.value.email ?? "",
                textAlign: TextAlign.start,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium
                    ?.copyWith(color: AppColors.textColorDarkGray),
              ),
      );

  ///build favorite widget
  Widget favoriteWidget() {
    return Container(
      padding: const EdgeInsets.only(
          left: AppValues.screenMargin,
          top: AppValues.appbarTopMargin,
          right: AppValues.height_14),
      child: AppLikeWidget(
        isSelected: _controller.isLiked.value,
        onChanged: _controller.likeChange,
      ),
    );
  }

  /// Build text name
  Widget buildTextName() => AnimatedSwitcher(
        duration: const Duration(
            milliseconds: AppValues.shimmerWidgetChangeDurationInMillis),
        child: _controller.isLoading.isTrue
            ? AppShimmer(
                child: Container(
                  height: 16,
                  width: 150,
                  color: Colors.white.withOpacity(0.5),
                ),
              )
            : Text(
                _controller.userDetails.value.name ?? "",
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyLarge
                    ?.copyWith(color: AppColors.textColorWhite),
              ),
      );
}
