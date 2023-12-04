import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../infrastructure/model/club/home/club_list_model.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../values/app_colors.dart';
import '../../../../../values/app_icons.dart';
import '../../../../../values/app_string.dart';
import '../../../../../values/app_values.dart';
import '../../../../app_widgets/app_button_mixin.dart';
import '../../../../app_widgets/app_shimmer.dart';
import '../../../../app_widgets/app_textfield.dart';
import '../../../../app_widgets/base_view.dart';
import '../../../../app_widgets/user_feature_mixin.dart';
import '../../../../custom_widgets/club_selection_tile_widget.dart';
import '../../../club/club_profile/manage_post/view/post_shimmer_widget.dart';
import '../../../club/club_user_search/view/user_search_shimmer_widget.dart';
import 'controllers/select_club.controller.dart';

class SelectClubScreen extends GetView<SelectClubController>
    with AppBarMixin, AppButtonMixin, UserFeatureMixin {
  final SelectClubController _controller = Get.find(tag: Routes.SELECT_CLUB);

  late TextTheme textTheme;
  late BuildContext buildContext;

  SelectClubScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: buildAppBar(
        title: AppString.selectClub,
      ),
      body: SafeArea(
        child: Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppValues.screenMargin,
            ),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppValues.height_10),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildSearchTextField(),
                      const SizedBox(height: AppValues.height_16),
                      Expanded(
                        child: buildClubList(),
                      ),
                    ],
                  ),
                ),
                appWhiteButton(
                  isValidate: _controller.validateField.value,
                  title: AppString.strSave,
                  onClick: () => {_controller.onSave()},
                ),
                const SizedBox(height: AppValues.height_10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Flexible search list for show search result.
  Widget buildFlexibleSearchList() {
    return _controller.isLoading.isTrue
            ? const UserSearchShimmerWidget()
            : _controller.clubList.isNotEmpty
                ? buildClubList()
                : buildNoUserFoundWidget();
  }

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

  /// Build see all search result text.
  Widget buildSeeMoreText() => GestureDetector(
        onTap: () => {},
        child: Text(
          AppString.seeAllSearch,
          style: textTheme.headlineSmall,
        ),
      );

  Widget buildSearchTextField() {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppValues.smallRadius),
      ),
      child: AppTextField.underLineTextField(
        context: buildContext,
        backgroundColor: AppColors.appTileBackground,
        hintColor: AppColors.inputFieldBorderColor,
        enableFocusBorder: false,
        isFocused: _controller.searchFocusNode.hasFocus,
        contentPadding:
            const EdgeInsets.symmetric(vertical: AppValues.margin_10),
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
    );
  }

  /// build list of checkbox of club
  Widget buildClubList() => PagedListView<int, ClubListModel>.separated(
        separatorBuilder: (_, ctx) => Container(
          height: AppValues.margin_10,
        ),
        pagingController: _controller.pagingController,
        shrinkWrap: true,

        builderDelegate: PagedChildBuilderDelegate<ClubListModel>(
            animateTransitions: true,
            // noItemsFoundIndicatorBuilder: (_) => buildNoActivityView(),
            firstPageProgressIndicatorBuilder: (_) =>
                const UserSearchShimmerWidget(),
            firstPageErrorIndicatorBuilder: (_) => buildNoUserFoundWidget(),
            newPageProgressIndicatorBuilder: (_) =>
                AppShimmer(child: const SinglePostShimmerWidget()),
            itemBuilder: (context, item, index) {
              return ClubSelectionTileWidget(
                model: item,
                index: index,
                onChange: (i,selected) => _controller.addToTempList(i,selected),
              );
            }),
      );

// Widget buildClubList() {
//   return ListView.builder(
//     shrinkWrap: true,
//     itemCount: _controller.filterUserList.length,
//     itemBuilder: (context, index) {
//       return ClubSelectionTileWidget(
//         model: _controller.filterUserList[index],
//         index: index,
//         onChange: _controller.addToTempList,
//       );
//     },
//   );
// }
}
