import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../infrastructure/model/club/home/club_list_model.dart';
import '../../../../infrastructure/navigation/routes.dart';
import '../../../../values/app_colors.dart';
import '../../../../values/app_string.dart';
import '../../../../values/app_values.dart';
import '../../../app_widgets/app_shimmer.dart';
import '../../../app_widgets/base_view.dart';
import '../../../app_widgets/common_bottombar_widget.dart';
import '../../../app_widgets/search_view_with_filter.dart';
import '../../../custom_widgets/favourite_club_tile_widget.dart';
import '../../club/club_user_search/view/user_search_shimmer_widget.dart';
import '../../home/club_home/view/club_activity_shimmer_widget.dart';
import '../player_main/controllers/player_main.controller.dart';
import 'controllers/player_club_search_result.controller.dart';

class PlayerClubSearchResultScreen
    extends GetView<PlayerClubSearchResultController> with AppBarMixin {
  late TextTheme textTheme;
  late BuildContext buildContext;

  PlayerClubSearchResultScreen({Key? key}) : super(key: key);

  final PlayerClubSearchResultController _controller =
      Get.find(tag: Routes.PLAYER_SEARCH_RESULT);

  PlayerMainController _controllerPlayerMain = Get.find(tag: Routes.PLAYER_MAIN);
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
                child: RefreshIndicator(
                    onRefresh: _controller.onRefresh,
                    child: _buildPlayerClubSearchPagination())),
          ],
        ),
      );

  /// Build header widget.
  Widget buildHeader() {
    return SearchViewWithFilter(
      onFilterClick: () => _controller.onFilter(),
      textEditingController: null,
      focusNode: null,
      isFilterApplied: _controller.isFilterApplied.isTrue,
      onSearchClick: _controller.onSearchClick,
    );
  }

  /// Build list widget.
  Widget buildRecentListWidget() => ListView.separated(
        itemBuilder: (_, index) {
          return FavouriteClubTileWidget(
            postModel: _controller.filterUserList[index],
            onLikeChange: _controller.onLikeChange,
            index: index,
            onTap: _controller.playerDetailScreen,
          );
        },
        shrinkWrap: true,
        separatorBuilder: (_, index) {
          return Container(
            height: AppValues.margin_10,
          );
        },
        itemCount: _controller.filterUserList.length,
      );

  /// Build list widget.
  Widget _buildPlayerClubSearchPagination() =>
      PagedListView<int, ClubListModel>.separated(
        shrinkWrap: true,
        separatorBuilder: (_, ctx) => Container(
          height: AppValues.margin_10,
        ),
        pagingController: _controller.pagingController,
        builderDelegate: PagedChildBuilderDelegate<ClubListModel>(
            animateTransitions: true,
            firstPageErrorIndicatorBuilder: (_) => buildNoUserFoundWidget(),
            noItemsFoundIndicatorBuilder: (_) => buildNoUserFoundWidget(),
            firstPageProgressIndicatorBuilder: (_) =>
                const ClubActivityShimmerWidget(),
            newPageProgressIndicatorBuilder: (_) =>
                AppShimmer(child: const UserSearchShimmerWidget()),
            itemBuilder: (context, item, index) {
              return FavouriteClubTileWidget(
                postModel: item,
                onLikeChange: _controller.onLikeChange,
                index: index,
                onTap: _controller.playerDetailScreen,
              );
            }),
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

  /// Build bottom navigation bar common widget.
  Widget bottomNavigation() => Container(
    color: AppColors.bottomBarBackground,
    child: CommonBottomBarWidget(
      onTap: _controller.onChangeTab,
      currentSelectedIndex: _controllerPlayerMain.tabIndex.value,
      items: _controllerPlayerMain.bottomBarItems,
    ),
  );
}
