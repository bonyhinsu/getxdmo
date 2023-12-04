import 'package:flutter/material.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_button_mixin.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../infrastructure/model/club/home/recent_model.dart';
import '../../../../infrastructure/navigation/routes.dart';
import '../../../../values/app_colors.dart';
import '../../../../values/app_string.dart';
import '../../../../values/app_values.dart';
import '../../../app_widgets/app_shimmer.dart';
import '../../../app_widgets/base_view.dart';
import '../../../app_widgets/common_bottombar_widget.dart';
import '../../../app_widgets/search_view_with_filter.dart';
import '../../../custom_widgets/recent_home_tile_widget.dart';
import '../club_main/controllers/club_main.controller.dart';
import '../club_profile/manage_post/view/post_shimmer_widget.dart';
import '../club_user_search/view/user_search_shimmer_widget.dart';
import 'controllers/search_result.controller.dart';

class SearchResultScreen extends GetView<SearchResultController>
    with AppBarMixin, AppButtonMixin {
  late TextTheme textTheme;
  late BuildContext buildContext;

  SearchResultScreen({Key? key}) : super(key: key);

  final SearchResultController _controller =
      Get.find(tag: Routes.SEARCH_RESULT);

  final ClubMainController _clubMainController = Get.find(tag: Routes.CLUB_MAIN);
  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    buildContext = context;

    return Scaffold(
      appBar: buildAppBar(
        title: AppString.strResult,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(
          () => buildBody(),
        ),
      ),
      bottomNavigationBar:  bottomNavigation(),
    );
  }

  /// build body widget.
  Widget buildBody() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppValues.screenMargin),
        child: Column(
          children: [
            Container(
              height: AppValues.screenMargin,
              color: AppColors.pageBackground,
            ),
            buildHeader(),
            Container(
              height: AppValues.margin_15,
              color: AppColors.pageBackground,
            ),
            Expanded(
                child: _controller.isLoading.isTrue
                    ? const UserSearchShimmerWidget()
                    : buildRecentListWidget()),
          ],
        ),
      );

  /// Build header widget.
  Widget buildHeader() {
    return SearchViewWithFilter(
      onFilterClick: () => _controller.openFilterMenu(),
      textEditingController: null,
      focusNode: null,
      isFilterApplied: _controller.isFilterApplied.isTrue,
      onSearchClick: _controller.onSearchClick,
    );
  }

  /// Build no activity view widget
  Widget buildNoActivityView() => SizedBox(
        height: 300,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppString.noPlayerFound,
              style: textTheme.headlineMedium,
            ),
            if (_controller.isFilterApplied.value)
              const SizedBox(
                height: AppValues.margin_20,
              ),
            if (_controller.isFilterApplied.value)
              Text(
                AppString.changeFilterCriteriaMessage,
                style: textTheme.bodySmall,
              ),
            if (_controller.isFilterApplied.value)
              const SizedBox(
                height: AppValues.margin_20,
              ),
            if (_controller.isFilterApplied.value)
              SizedBox(
                  width: 200,
                  child: appGrayButton(
                      buttonRadius: AppValues.radius_12,
                      title: AppString.changeFilter,
                      onClick: _controller.openFilterMenu))
          ],
        )),
      );

  // /// Build list widget.
  // Widget buildRecentListWidget() => ListView.separated(
  //       itemBuilder: (_, index) {
  //         return RecentHomeTileWidget(
  //           postModel: _controller.filterUserList[index],
  //           onLikeChange: _controller.onLikeChange,
  //           index: index,
  //           onTap: _controller.playerDetailScreen,
  //         );
  //       },
  //       shrinkWrap: true,
  //       separatorBuilder: (_, index) {
  //         return Container(
  //           height: AppValues.margin_10,
  //         );
  //       },
  //       itemCount: _controller.filterUserList.length,
  //     );

  /// Build list widget.
  Widget buildRecentListWidget() => PagedListView<int, RecentModel>.separated(
        separatorBuilder: (_, ctx) => Container(
          height: AppValues.margin_10,
        ),
        pagingController: _controller.pagingController,
        shrinkWrap: true,
        builderDelegate: PagedChildBuilderDelegate<RecentModel>(
            animateTransitions: true,
            noItemsFoundIndicatorBuilder: (_) => buildNoActivityView(),
            firstPageProgressIndicatorBuilder: (_) =>
                const UserSearchShimmerWidget(),
            newPageProgressIndicatorBuilder: (_) =>
                AppShimmer(child: const SinglePostShimmerWidget()),
            itemBuilder: (context, item, index) {
              return RecentHomeTileWidget(
                postModel: item,
                onLikeChange: _controller.onLikeChange,
                index: index,
                onTap: _controller.playerDetailScreen,
              );
            }),
      );

  /// Build bottom navigation bar common widget.
  Widget bottomNavigation() =>  Container(
    color: AppColors.bottomBarBackground,
    child: CommonBottomBarWidget(
      onTap: _controller.onChangeTab,
      currentSelectedIndex: _clubMainController.tabIndex.value,
      items: _clubMainController.bottomBarItems,
    ),
  );
}
