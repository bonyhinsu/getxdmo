import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_on_flutter/infrastructure/navigation/routes.dart';
import 'package:game_on_flutter/presentation/app_widgets/club_profile_widget.dart';
import 'package:game_on_flutter/presentation/screens/player/club_detail/view/club_detail_tab_widget.dart';
import 'package:get/get.dart';

import '../../../../values/app_colors.dart';
import '../../../../values/app_icons.dart';
import '../../../../values/app_string.dart';
import '../../../../values/app_values.dart';
import '../../../../values/common_utils.dart';
import '../../../app_widgets/app_button_mixin.dart';
import '../../../app_widgets/app_like_widget.dart';
import '../../../app_widgets/base_view.dart';
import '../../home/club_player_detail/club_detail_shimmer_widget.dart';
import 'controllers/club_detail.controller.dart';

class ClubDetailScreen extends StatelessWidget
    with AppBarMixin, AppButtonMixin, ClubDetailShimmerWidget {
  final ClubDetailController _controller = Get.find(tag: Routes.CLUB_DETAIL);

  late TextTheme textTheme;
  late BuildContext buildContext;

  ClubDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    buildContext = context;
    return Obx(() => Scaffold(
          appBar: buildAppBarWithActions(
              title: AppString.clubProfile,
              centerTitle: true,
              backEnable: true,
              actions: [favoriteWidget()]),
          body: SafeArea(child: buildBody(context)),
        ));
  }

  /// Widget build body.
  Widget buildBody(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppValues.screenMargin),
        child: SingleChildScrollView(
          controller: _controller.scrollController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: AppValues.height_10,
              ),

              /// Logo and other club details.
              buildHeaderUserDetail(),
              const SizedBox(
                height: AppValues.height_20,
              ),

              /// Follow/Unfollow, Message and following buttons.
              buildClubUserActionButtonRow(),
              const SizedBox(
                height: AppValues.height_20,
              ),

              /// Bio
              if ((_controller.userDetails.value.bio ?? "").isNotEmpty)
                buildClubSection(
                    AppString.bio, _controller.userDetails.value.bio ?? ""),
              if ((_controller.userDetails.value.bio ?? "").isNotEmpty)
                const SizedBox(
                  height: AppValues.height_12,
                ),

              if ((_controller.userDetails.value.introduction ?? "").isNotEmpty)

                /// Intro
                buildClubSection(AppString.intro,
                    _controller.userDetails.value.introduction ?? ""),
              if ((_controller.userDetails.value.introduction ?? "").isNotEmpty)
                const SizedBox(
                  height: AppValues.height_12,
                ),

              /// Other information
              if ((_controller.userDetails.value.introduction ?? "").isNotEmpty)
                buildClubSection(AppString.otherInformation,
                    _controller.userDetails.value.introduction ?? ""),
              if ((_controller.userDetails.value.introduction ?? "").isNotEmpty)
                const SizedBox(
                  height: AppValues.height_12,
                ),

              /// More information
              buildMoreInformation(),
              const SizedBox(
                height: AppValues.height_20,
              ),

              /// Tab Detail Widget
              ClubDetailTabWidget(
                clubListModel: _controller.userDetails.value,
                tabController: _controller.tabController,
                onCallClick: _controller.onCallClick,
                onImageViewAll: _controller.onViewALL,
                onVideoClick: _controller.onVideoClick,
                onImageClick: _controller.onImageClick,
                onTabClick: _controller.navigateToBottom,
                onMessageClick: _controller.onMessageClick,
                coachingStaffList: _controller.coachingStaffList,
                directorList: _controller.directorList,
                otherBoardMemberList: _controller.otherBoardMemberList,
                presidentList: _controller.presidentList,
                selectedIndex: _controller.currentSelectedIndex.value,
              )
            ],
          ),
        ),
      );

  /// Build more information button.
  Widget buildMoreInformation() => Column(
        children: [
          Align(alignment: Alignment.topLeft, child: buildInfoLabel()),
          const SizedBox(
            height: AppValues.height_10,
          ),
          buildInformation(
              AppString.level,
              _controller.userDetails.value.commaSeparatedLevels ?? "",
              AppIcons.lavelBase),
          const SizedBox(
            height: AppValues.height_10,
          ),
          buildInformation(
              AppString.sports,
              _controller.userDetails.value.commaSeparatedSports ?? "",
              AppIcons.sportsIcon,
              imageAsset: true),
          const SizedBox(
            height: AppValues.height_10,
          ),
          buildInformation(
              AppString.preferredPositions,
              _controller.userDetails.value.commaSeparatedPreferredPositions ??
                  "",
              AppIcons.preffered_positionbase),
        ],
      );

  /// Build club section
  Widget buildClubSection(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: textTheme.bodyLarge?.copyWith(
              color: AppColors.textColorSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 16),
        ),
        const SizedBox(
          height: AppValues.height_10,
        ),
        AnimatedSwitcher(
          duration: const Duration(
              milliseconds: AppValues.shimmerWidgetChangeDurationInMillis),
          child: Text(
            value,
            textAlign: TextAlign.start,
            style: textTheme.displaySmall
                ?.copyWith(color: AppColors.textColorDarkGray, fontSize: 13),
          ),
        ),
      ],
    );
  }

  /// build club action button row.
  Widget buildClubUserActionButtonRow() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: buildFollowingWidget()),
          const SizedBox(
            width: AppValues.height_10,
          ),
          Expanded(child: buildFollowerWidget()),
          const SizedBox(
            width: AppValues.height_10,
          ),
          Expanded(child: buildMessageWidget())
        ],
      );

  Widget buildHeaderUserDetail() => Column(
        children: [
          ClubProfileWidget(
            isAssetUrl: false,
            profileURL: _controller.userDetails.value.profileImage ?? "",
            width: 74,
            height: 74,
          ),
          const SizedBox(
            height: AppValues.height_10,
          ),
          buildTextName(),
          const SizedBox(
            height: AppValues.height_6,
          ),
          buildIconWithValueWidget(AppIcons.callRedIcon,
              _controller.userDetails.value.phoneNumber ?? ""),
          const SizedBox(
            height: AppValues.height_6,
          ),
          buildIconWithValueWidget(
              AppIcons.iconMessage, _controller.userDetails.value.email ?? ""),
          const SizedBox(
            height: AppValues.height_6,
          ),
          buildIconWithValueWidget(AppIcons.locationIcon,
              _controller.userDetails.value.commaSeparatedLocations ?? ""),
        ],
      );

  /// build information widget
  Widget buildInformation(String label, String result, String icon,
      {bool imageAsset = false}) {
    return Row(
      children: [
        imageAsset
            ? Image.asset(
                icon,
                width: AppValues.size_30,
                height: AppValues.size_30,
              )
            : SvgPicture.asset(
                icon,
                width: AppValues.size_30,
                height: AppValues.size_30,
              ),
        const SizedBox(
          width: AppValues.height_16,
        ),
        Text(
          label,
          textAlign: TextAlign.start,
          overflow: TextOverflow.ellipsis,
          style: textTheme.displaySmall
              ?.copyWith(color: AppColors.textColorWhite, fontSize: 13),
        ),
        Expanded(
          child: Text(
            result,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: textTheme.displaySmall
                ?.copyWith(color: AppColors.textColorDarkGray, fontSize: 13),
          ),
        ),
      ],
    );
  }

  /// build physically info
  /*Widget physicallyInfoBuild() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Text(
              AppString.height,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium
                  ?.copyWith(color: AppColors.textColorDarkGray),
            ),
            const SizedBox(
              height: AppValues.height_16,
            ),
            Text(
              "",
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium
                  ?.copyWith(color: AppColors.textColorWhite),
            )
          ],
        ),
        const SizedBox(
          width: AppValues.height_10,
        ),
        Column(
          children: [
            Text(
              AppString.weight,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium
                  ?.copyWith(color: AppColors.textColorDarkGray),
            ),
            const SizedBox(
              height: AppValues.height_16,
            ),
            Text(
              "",
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium
                  ?.copyWith(color: AppColors.textColorWhite),
            )
          ],
        ),
        const SizedBox(
          width: AppValues.height_10,
        ),
        Column(
          children: [
            Text(
              AppString.age,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium
                  ?.copyWith(color: AppColors.textColorDarkGray),
            ),
            const SizedBox(
              height: AppValues.height_16,
            ),
            Text(
              "",
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium
                  ?.copyWith(color: AppColors.textColorWhite),
            )
          ],
        )
      ],
    );
  }*/

  /// build bio widget
  Widget buildBioLabel() {
    return Text(
      AppString.bio,
      textAlign: TextAlign.center,
      style:
          textTheme.headlineLarge?.copyWith(color: AppColors.textColorTernary),
    );
  }

  /// build more information widget
  Widget buildInfoLabel() {
    return Text(
      AppString.moreInformation,
      textAlign: TextAlign.center,
      style: textTheme.bodyLarge?.copyWith(
          color: AppColors.textColorSecondary, fontWeight: FontWeight.w600),
    );
  }

  /// build bio widget
  Widget buildBio() {
    return AnimatedSwitcher(
      duration: const Duration(
          milliseconds: AppValues.shimmerWidgetChangeDurationInMillis),
      child: _controller.isLoading.isTrue
          ? buiShimmerWidget
          : Text(
              "",
              textAlign: TextAlign.start,
              style: textTheme.bodyMedium
                  ?.copyWith(color: AppColors.textColorDarkGray),
            ),
    );
  }

  /// build following widget
  Widget buildFollowingWidget() {
    return _controller.followedUser.isTrue
        ? appGrayButton(
            title: AppString.following,
            onClick: _controller.showUnfollowUserDialog)
        : appRedSecondaryButton(
            title: AppString.strFollow, onClick: _controller.onFollowClick);
  }

  /// build follower widget
  Widget buildFollowerWidget() {
    return appGrayButton(
        title:
            "${CommonUtils.numberToWordsWithZero(_controller.userDetails.value.followerCount ?? 0)} ${AppString.followers}",
        onClick: () {});
  }

  /// build messages widget
  Widget buildMessageWidget() {
    return appGrayButton(
        title: AppString.messages,
        disabledButton: _controller.followedUser.isFalse,
        onClick: _controller.onChatClick);
  }

  ///build mobile widget
  Widget buildIconWithValueWidget(String icon, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          icon,
          height: 16,
          width: 16,
          color: AppColors.appRedButtonColor,
        ),
        const SizedBox(
          width: AppValues.height_10,
        ),
        Flexible(
            child: Text(
          value,
          textAlign: TextAlign.center,
          maxLines: 3,
          style: textTheme.displaySmall?.copyWith(
              color: AppColors.textColorDarkGray,
              fontWeight: FontWeight.w500,
              fontSize: 13),
        )),
      ],
    );
  }

  /// Build mobile content.
  Widget buildMobileText(String value) => Text(
        value,
        textAlign: TextAlign.center,
        maxLines: 3,
        style:
            textTheme.bodyMedium?.copyWith(color: AppColors.textColorDarkGray),
      );

  /// Build favourite widget icon.
  Widget favoriteWidget() {
    return Container(
      padding: const EdgeInsets.only(
          left: AppValues.screenMargin,
          top: AppValues.appbarTopMargin,
          right: AppValues.appbarTopMargin),
      child: AppLikeWidget(
        isSelected: _controller.isLiked.value,
        onChanged: _controller.likeChange,
      ),
    );
  }

  /// Build text name
  Widget buildTextName() => Text(
        _controller.userDetails.value.name ?? "",
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        style: textTheme.bodyLarge?.copyWith(color: AppColors.textColorWhite),
      );

  ///build image and video widget
}
