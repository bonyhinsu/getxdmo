import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_on_flutter/presentation/app_widgets/base_view.dart';
import 'package:game_on_flutter/presentation/screens/player/player_club_search/view/club_search_result_tile_widget.dart';
import 'package:get/get.dart';

import '../../../../infrastructure/navigation/routes.dart';
import '../../../../values/app_colors.dart';
import '../../../../values/app_icons.dart';
import '../../../../values/app_string.dart';
import '../../../../values/app_values.dart';
import '../../../app_widgets/app_textfield.dart';
import '../../club/club_user_search/view/user_search_shimmer_widget.dart';
import 'controllers/player_club_search.controller.dart';

class PlayerClubSearchScreen extends GetView<PlayerClubSearchController>
    with AppBarMixin {
  late TextTheme textTheme;
  late BuildContext buildContext;

  final PlayerClubSearchController _controller =
      Get.find(tag: Routes.PLAYER_CLUB_SEARCH);

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    buildContext = context;

    return Scaffold(
      appBar: buildHeaderAppbar(),
      body: SafeArea(
        child: Obx(() => buildBody()),
      ),
    );
  }

  /// Build header app bar widget
  AppBar buildHeaderAppbar() => AppBar(
        elevation: 0,
        backgroundColor: AppColors.pageBackground,
        leadingWidth: AppValues.appbarBackButtonSize + AppValues.screenMargin,
        centerTitle: true,
        leading: FittedBox(
          fit: BoxFit.contain,
          child: buildIconButton(
              icon: AppIcons.backArrowIcon, onClick: _controller.onBackPressed),
        ),
        title: buildSearchTextField(),
      );

  /// Return back button widget.
  Widget buildIconButton({Function? onClick, required String icon}) =>
      GestureDetector(
        onTap: onClick == null ? () => Get.back() : () => onClick(),
        child: Container(
          margin: const EdgeInsets.only(
              left: AppValues.screenMargin,
              top: AppValues.appbarTopMargin,
              bottom: AppValues.appbarTopMargin),
          decoration: BoxDecoration(
              border: Border.all(
                  color: AppColors.textColorSecondary.withOpacity(0.1),
                  width: 1),
              color: AppColors.textFieldBackgroundColor,
              borderRadius: BorderRadius.circular(AppValues.smallRadius)),
          height: AppValues.appbarBackButtonSize,
          width: AppValues.appbarBackButtonSize,
          padding: const EdgeInsets.all(AppValues.smallPadding),
          child: SvgPicture.asset(icon),
        ),
      );

  /// Widget build body.
  Widget buildBody() {
    Get.log("_controller.filterUserList; ${_controller.userFilterList.length}");
    return Container(
      margin: const EdgeInsets.all(AppValues.screenMargin),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppValues.smallRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // buildSearchTextField(),
          if (_controller.getSearchValue.isNotEmpty) buildFlexibleSearchList()
        ],
      ),
    );
  }

  /// Flexible search list for show search result.
  Widget buildFlexibleSearchList() => Flexible(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: _controller.isLoading.isTrue
                  ? const UserSearchShimmerWidget()
                  : _controller.userFilterList.isNotEmpty
                      ? buildResultFilter()
                      : buildNoUserFoundWidget(),
            ),
            const SizedBox(
              height: AppValues.margin_8,
            ),
            if (_controller.userFilterList.isNotEmpty) buildSeeMoreText(),
            const SizedBox(
              height: AppValues.margin_15,
            )
          ],
        ),
      );

  /// Build search text field
  Widget buildSearchTextField() {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppValues.smallRadius),
        ),
        child: AppTextField.underLineTextField(
          context: buildContext,
          backgroundColor: AppColors.appTileBackground,
          hintColor: AppColors.bottomSheetInputBackground,
          enableFocusBorder: false,
          isFocused: _controller.searchFocusNode.hasFocus,
          contentPadding:
              const EdgeInsets.symmetric(vertical: AppValues.margin_12),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppString.fieldDoesNotEmptyMessage;
            }
            return null;
          },
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: AppValues.margin_15),
            child: SvgPicture.asset(
              AppIcons.searchIcon,
              height: AppValues.iconSize_18,
              width: AppValues.iconSize_18,
            ),
          ),
          maxLength: AppValues.textFieldMaxLength,
          controller: _controller.searchController,
          onTextChange: _controller.onChangeHandler,
          focusNode: _controller.searchFocusNode,
        ),
      ),
    );
  }

  /// Build result filter list.
  Widget buildResultFilter() {
    return ListView.separated(
      itemBuilder: (_, index) {
        return ClubSearchResultTileWidget(
          model: _controller.userFilterList[index],
          onUserClick: _controller.navigateToUserDetailScreen,
        );
      },
      separatorBuilder: (_, index) {
        return const Divider(
          height: 1,
          color: Colors.transparent,
        );
      },
      shrinkWrap: true,
      itemCount: _controller.userFilterList.length,
    );
  }

  /// Build see all search result text.
  Widget buildSeeMoreText() => GestureDetector(
        onTap: () => _controller.navigateToViewAllScreen(),
        child: Text(
          AppString.seeAllSearch,
          style: textTheme.headlineSmall,
        ),
      );

  /// Build no directors widget.
  Widget buildNoUserFoundWidget() {
    return SizedBox(
      height: 100,
      child: Center(
        child: Text(
          AppString.noClubFound,
          style: textTheme.displaySmall
              ?.copyWith(color: AppColors.inputFieldBorderColor),
        ),
      ),
    );
  }
}
