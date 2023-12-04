import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../infrastructure/model/club/home/club_list_model.dart';
import '../../../../infrastructure/navigation/routes.dart';
import '../../../../values/app_colors.dart';
import '../../../../values/app_values.dart';
import '../../../app_widgets/app_shimmer.dart';
import '../../../app_widgets/search_view_with_filter.dart';
import '../../../custom_widgets/app_filter_button_with_close.dart';
import '../../../custom_widgets/favourite_club_tile_widget.dart';
import '../../club/club_profile/manage_post/view/no_post_widget.dart';
import '../../club/club_profile/manage_post/view/post_shimmer_widget.dart';
import '../../home/club_home/view/club_activity_shimmer_widget.dart';
import 'controllers/player_club_favourite.controller.dart';

class PlayerClubFavouriteScreen extends GetView<PlayerClubFavouriteController> {
  PlayerClubFavouriteScreen({Key? key}) : super(key: key);

  final PlayerClubFavouriteController _controller =
      Get.find(tag: Routes.PLAYER_FAVOURITE_CLUB);

  late TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppValues.screenMargin),
        child: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: AppValues.margin_8,
                color: AppColors.pageBackground,
              ),
              buildHeader(),
              Container(
                height: _controller.isPlayerLoggedIn.isTrue
                    ? AppValues.margin_8
                    : AppValues.margin_15,
                color: AppColors.pageBackground,
              ),
              selectedFilterList,
              Expanded(
                  child: RefreshIndicator(
                      triggerMode: RefreshIndicatorTriggerMode.anywhere,
                      onRefresh: _controller.refreshData,
                      child: buildFavouriteClubList()))
            ],
          ),
        ),
      ),
    );
  }

  /// Build selected filter list widget.
  Widget get selectedFilterList => AnimatedContainer(
        duration: const Duration(
            milliseconds: AppValues.shimmerWidgetChangeDurationInMillis),
        height: _controller.appliedFilter.isEmpty ? AppValues.smallRadius : 60,
        child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: AppValues.smallMargin),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: buildListView(),
            )),
      );

  Widget buildListView() => ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) => AppFilterButtonWithCheck(
          model: _controller.appliedFilter[index],
          onDelete: _controller.onDeleteFilter,
          index: index,
        ),
        itemCount: _controller.appliedFilter.length,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            width: AppValues.height_8,
          );
        },
      );

  /// Build list widget.
  Widget buildRecentListWidget() => ListView.separated(
        itemBuilder: (_, index) {
          return FavouriteClubTileWidget(
            postModel: _controller.favouriteUsers[index],
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
        itemCount: _controller.favouriteUsers.length,
      );

  /// Build header widget.
  Widget buildHeader() {
    return SearchViewWithFilter(
      enableSearch: false,
      onFilterClick: () => _controller.onFilter(),
      textEditingController: null,
      focusNode: null,
      isFilterApplied: _controller.isFilterApplied.value,
      onSearchClick: _controller.onSearchClick,
    );
  }

  /// Build list widget.
  Widget buildFavouriteClubList() =>
      PagedListView<int, ClubListModel>.separated(
        shrinkWrap: true,
        separatorBuilder: (_, ctx) => Container(
          height: AppValues.margin_10,
        ),
        pagingController: _controller.pagingController,
        builderDelegate: PagedChildBuilderDelegate<ClubListModel>(
            animateTransitions: true,
            firstPageErrorIndicatorBuilder: (_) => const NoPostWidget(),
            noItemsFoundIndicatorBuilder: (_) => const NoPostWidget(),
            firstPageProgressIndicatorBuilder: (_) =>
                const ClubActivityShimmerWidget(),
            newPageProgressIndicatorBuilder: (_) =>
                AppShimmer(child: const SinglePostShimmerWidget()),
            itemBuilder: (context, item, index) {
              return FavouriteClubTileWidget(
                postModel: item,
                onLikeChange: _controller.onLikeChange,
                index: index,
                onTap: _controller.playerDetailScreen,
              );
            }),
      );
}
