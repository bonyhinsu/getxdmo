import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../infrastructure/model/club/home/recent_model.dart';
import '../../../../infrastructure/navigation/routes.dart';
import '../../../../values/app_colors.dart';
import '../../../../values/app_values.dart';
import '../../../app_widgets/app_shimmer.dart';
import '../../../app_widgets/search_view_with_filter.dart';
import '../../../custom_widgets/app_filter_button_with_close.dart';
import '../../../custom_widgets/recent_home_tile_widget.dart';
import '../../home/club_home/view/club_activity_shimmer_widget.dart';
import '../club_profile/manage_post/view/no_post_widget.dart';
import '../club_profile/manage_post/view/post_shimmer_widget.dart';
import 'controllers/club_favorite.controller.dart';

class ClubFavoriteScreen extends StatelessWidget {
  ClubFavoriteScreen({Key? key}) : super(key: key);

  final ClubFavoriteController _controller =
      Get.find(tag: Routes.CLUB_FAVORITE);

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
                onRefresh: _controller.onRefresh,
                child: AnimatedSwitcher(
                    duration: const Duration(
                        milliseconds:
                            AppValues.shimmerWidgetChangeDurationInMillis),
                    child: _controller.isLoading.isTrue
                        ? const ClubActivityShimmerWidget()
                        : buildFavouriteUserListForClub()),
              ))
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
          padding: const EdgeInsets.symmetric(vertical: AppValues.smallMargin),
          child: buildListView(),
        ),
      );

  /// Build club's favourite user list.
  Widget buildFavouriteUserListForClub() =>
      PagedListView<int, RecentModel>.separated(
        separatorBuilder: (_, ctx) => Container(
          height: AppValues.margin_10,
        ),
        pagingController: _controller.pagingController,
        shrinkWrap: true,
        primary: true,
        builderDelegate: PagedChildBuilderDelegate<RecentModel>(
            animateTransitions: true,
            firstPageErrorIndicatorBuilder: (_) => const NoPostWidget(),
            noItemsFoundIndicatorBuilder: (_) => const NoPostWidget(),
            firstPageProgressIndicatorBuilder: (_) =>
                const ClubActivityShimmerWidget(),
            newPageProgressIndicatorBuilder: (_) =>
                AppShimmer(child: const SinglePostShimmerWidget()),
            itemBuilder: (context, item, index) {
              return RecentHomeTileWidget(
                index: index,
                onLikeChange: _controller.onLikeChange,
                onTap: _controller.playerDetailScreen,
                postModel: item,
              );
            }),
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

  /// Build header widget.
  Widget buildHeader() {
    return SearchViewWithFilter(
      onFilterClick: () => _controller.onFilter(),
      textEditingController: null,
      focusNode: null,
      isFilterApplied: _controller.isFilterApplied.value,
      onSearchClick: _controller.onSearchClick,
    );
  }
}
