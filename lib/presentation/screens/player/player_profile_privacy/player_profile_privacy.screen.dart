import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:game_on_flutter/infrastructure/navigation/routes.dart';
import 'package:game_on_flutter/values/app_icons.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../infrastructure/model/club/home/club_list_model.dart';
import '../../../../values/app_colors.dart';
import '../../../../values/app_font_size.dart';
import '../../../../values/app_string.dart';
import '../../../../values/app_values.dart';
import '../../../app_widgets/app_button_mixin.dart';
import '../../../app_widgets/app_shimmer.dart';
import '../../../app_widgets/base_view.dart';
import '../../../app_widgets/user_feature_mixin.dart';
import '../../../custom_widgets/club_selection_tile_widget.dart';
import '../../club/club_profile/manage_post/view/post_shimmer_widget.dart';
import '../../club/club_user_search/view/user_search_shimmer_widget.dart';
import 'controllers/player_profile_privacy.controller.dart';

class PlayerProfilePrivacyScreen extends GetView<PlayerProfilePrivacyController>
    with AppBarMixin, AppButtonMixin, UserFeatureMixin {
  final PlayerProfilePrivacyController controller =
      Get.find(tag: Routes.PLAYER_PROFILE_PRIVACY);

  late TextTheme textTheme;
  late BuildContext buildContext;

  PlayerProfilePrivacyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: buildAppBar(title: AppString.profilePrivacy),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppValues.screenMargin,
          ),
          width: double.infinity,
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [getHidePreferenceProfileText(), buildMore()],
                ),
                controller.privacyMessage.value ==
                        AppString.selectedClubHidden.toString()
                    ? hideProfileDescriptionText()
                    : getHidePreferenceProfileDescriptionText(),
                if (controller.profilePrivacyTypeEnum.value ==
                    ProfilePrivacyEnum.selectedClubs)
                  Expanded(
                    child: !controller.isVisibleList.value
                        ? _buildUserSelectedClubList()
                        : Column(
                            children: [
                              Expanded(child: buildClubList(true)),
                              const SizedBox(height: AppValues.height_8,),
                              appWhiteButton(
                                title: AppString.strNext,
                                isValidate: controller.enableSaveButton.isTrue,
                                onClick: () {
                                  controller.onNextButton();
                                },
                              )
                            ],
                          ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// build profile hide preference text
  Widget getHidePreferenceProfileText() {
    return Text(
      AppString.profileHidePreference,
      style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontFamily: FontConstants.poppins,
          fontSize: 16,
          color: AppColors.textColorSecondary),
    );
  }

  ///build more icon
  Widget buildMore() {
    return InkWell(
        onTap: controller.moreDialog,
        child: Padding(
          padding: const EdgeInsets.only(
              left: AppValues.height_10,
              bottom: AppValues.height_10,
              top: AppValues.height_10),
          child: SvgPicture.asset(AppIcons.moreVertical),
        ));
  }

  /// Hide profile description text.
  Widget hideProfileDescriptionText() {
    return RichText(
      text: TextSpan(
        text: 'Your profile is hidden from the following clubs. Click',
        style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontFamily: FontConstants.poppins,
            fontSize: 13,
            color: AppColors.textColorDarkGray),
        children: <TextSpan>[
          TextSpan(
            text: ' here ',
            style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontFamily: FontConstants.poppins,
                fontSize: 13,
                color: AppColors.appRedButtonColor),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                controller.onClickMore();
              },
          ),
          const TextSpan(text: ' to select additional clubs.'),
        ],
      ),
    );
  }

  /// build profile hide preference description
  Widget getHidePreferenceProfileDescriptionText() {
    return Text(
      controller.privacyMessage.value,
      style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontFamily: FontConstants.poppins,
          fontSize: 13,
          color: AppColors.textColorDarkGray),
    );
  }

  /// build list of checkbox of club
  Widget buildClubList(bool isHidden) =>
      PagedListView<int, ClubListModel>.separated(
        separatorBuilder: (_, ctx) => Container(
          height: AppValues.margin_10,
        ),
        pagingController: controller.pagingController,
        shrinkWrap: true,
        builderDelegate: PagedChildBuilderDelegate<ClubListModel>(
            animateTransitions: true,
            // noItemsFoundIndicatorBuilder: (_) => buildNoActivityView(),
            firstPageProgressIndicatorBuilder: (_) =>
                const UserSearchShimmerWidget(),
            newPageProgressIndicatorBuilder: (_) =>
                AppShimmer(child: const SinglePostShimmerWidget()),
            itemBuilder: (context, item, index) {
              return ClubSelectionTileWidget(
                enableCheckbox: isHidden,
                model: item,
                index: index,
                onChange: controller.addToSelectedClubList,
              );
            }),
      );

  /// build user selected club list
  Widget _buildUserSelectedClubList() =>
      PagedListView<int, ClubListModel>.separated(
        separatorBuilder: (_, ctx) => Container(
          height: AppValues.margin_10,
        ),
        pagingController: controller.selectedClubListPaginationController,
        shrinkWrap: true,
        builderDelegate: PagedChildBuilderDelegate<ClubListModel>(
            animateTransitions: true,
            // noItemsFoundIndicatorBuilder: (_) => buildNoActivityView(),
            firstPageProgressIndicatorBuilder: (_) =>
                const UserSearchShimmerWidget(),
            newPageProgressIndicatorBuilder: (_) =>
                AppShimmer(child: const SinglePostShimmerWidget()),
            itemBuilder: (context, item, index) {
              return ClubSelectionTileWidget(
                enableCheckbox: false,
                model: item,
                index: index,
                onChange: controller.addToSelectedClubList,
              );
            }),
      );
}
