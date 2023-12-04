import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:game_on_flutter/presentation/screens/club/club_user_search/view/user_search_shimmer_widget.dart';
import 'package:game_on_flutter/values/app_colors.dart';
import 'package:game_on_flutter/values/app_icons.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:get/get.dart';

import '../../../../infrastructure/navigation/routes.dart';
import '../../../../values/app_values.dart';
import '../../../app_widgets/app_textfield.dart';
import '../../../app_widgets/base_view.dart';
import '../../../custom_widgets/user_search_result_tile_widget.dart';
import 'controllers/club_user_search.controller.dart';

class ClubUserSearchScreen extends StatelessWidget with AppBarMixin {
  late TextTheme textTheme;
  late BuildContext buildContext;

  final ClubUserSearchController _controller =
      Get.find(tag: Routes.CLUB_USER_SEARCH);

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    buildContext = context;

    return Scaffold(
        appBar: buildHeaderAppbar(),
        body: SafeArea(
          child: Obx(() => buildBody()),
        ));
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
        title: ClipRRect(
            borderRadius: BorderRadius.circular(AppValues.smallRadius),
            child: buildSearchTextField()),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
    return AppTextField.underLineTextField(
      context: buildContext,
      backgroundColor: AppColors.colorPrimary.withOpacity(0.4),
      hintColor: AppColors.inputFieldBorderColor,
      enableFocusBorder: false,
      contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
      isFocused: _controller.searchFocusNode.hasFocus,
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
          height: 18,
          width: 18,
        ),
      ),
      maxLength: AppValues.textFieldMaxLength,
      controller: _controller.searchController,
      onTextChange: _controller.onChangeHandler,
      focusNode: _controller.searchFocusNode,
    );
  }

  /// Build result filter list.
  Widget buildResultFilter() {
    return ListView.separated(
      itemBuilder: (_, index) {
        return UserSearchResultTileWidget(
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
          style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700, color: AppColors.textColorDarkGray),
        ),
      );

  /// Build no directors widget.
  Widget buildNoUserFoundWidget() {
    return SizedBox(
      height: 100,
      child: Center(
        child: Text(
          AppString.noUserFound,
          style: textTheme.displaySmall
              ?.copyWith(color: AppColors.inputFieldBorderColor),
        ),
      ),
    );
  }
}
