import 'package:flutter/material.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_shimmer.dart';
import 'package:game_on_flutter/presentation/screens/club/club_profile/manage_post/view/no_post_widget.dart';
import 'package:game_on_flutter/presentation/screens/club/club_profile/manage_post/view/post_shimmer_widget.dart';
import 'package:game_on_flutter/values/app_colors.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../infrastructure/model/club/post/post_model.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../values/app_string.dart';
import '../../../../../values/app_values.dart';
import '../../../../app_widgets/app_button_mixin.dart';
import '../../../../app_widgets/base_view.dart';
import '../../../../app_widgets/search_view_with_filter.dart';
import '../../../../custom_widgets/open_position_tile_widget.dart';
import '../../../../custom_widgets/post_tile_widget.dart';
import '../../../player/player_home/controllers/player_home.controller.dart';
import 'controllers/manage_post.controller.dart';

class ManagePostScreen extends GetView<ManagePostController>
    with AppBarMixin, AppButtonMixin {
  ManagePostScreen({Key? key}) : super(key: key);

  final ManagePostController _controller = Get.find(tag: Routes.MANAGE_POST);

  late TextTheme textTheme;
  late BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: buildAppBar(
        title: AppString.managePost,
      ),
      body: SafeArea(
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: AppValues.screenMargin),
          child: Obx(
            () => buildBody(),
          ),
        ),
      ),
    );
  }

  /// Build body widget.
  Widget buildBody() => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: AppValues.screenMargin,
            color: AppColors.pageBackground,
          ),
          SearchViewWithFilter(
            onChange: _controller.searchForClub,
            onFilterClick: () => _controller.onFilter(),
            textEditingController: _controller.searchController,
            focusNode: _controller.searchFocusNode,
            isSearchApplied: _controller.isSearchApplied.value,
            enableSearch: true,
            onClearSearch: _controller.clearSearch,
            isFilterApplied: _controller.isFilterApplied.value,
          ),
          Container(
            height: AppValues.largeMargin,
            color: AppColors.pageBackground,
          ),
          Expanded(
              child: RefreshIndicator(
            onRefresh: _controller.refreshScreen,
            child: AnimatedSwitcher(
              duration: const Duration(
                  milliseconds: AppValues.shimmerWidgetChangeDurationInMillis),
              child:_buildList(),
            ),
          ))
        ],
      );

  /// Build list widget.
  Widget _buildList() => PagedListView<int, PostModel>.separated(
        separatorBuilder: (_, ctx) => Container(
          height: AppValues.margin_10,
        ),
        pagingController: _controller.pagingController,
        shrinkWrap: true,
        builderDelegate: PagedChildBuilderDelegate<PostModel>(
            animateTransitions: true,
            noItemsFoundIndicatorBuilder: (_) => const NoPostWidget(),
            firstPageProgressIndicatorBuilder: (_) => const PostShimmerWidget(),
            newPageProgressIndicatorBuilder: (_) =>
                AppShimmer(child: const SinglePostShimmerWidget()),
            itemBuilder: (context, item, index) {
              switch (item.viewType) {
                case PostViewType.openPosition:
                  return OpenPositionTileWidget(
                    index: index,
                    postModel: item,
                    onEdit: _controller.onEditPost,
                    onDelete: _controller.onDeletePost,
                    onPostClick: _controller.onPostClick,
                    onClubClick: (PostModel postModel, int index) {},
                  );
                default:
                  return PostTileWidget(
                    index: index,
                    postModel: item,
                    onEdit: _controller.onEditPost,
                    onDelete: _controller.onDeletePost,
                    onPostClick: _controller.onPostClick,
                    onClubClick: (PostModel postModel,int index) {},
                  );
              }
            }),
      );

  /*!_controller.showNoData && _controller.recentPosts.isNotEmpty
          ? ListView.separated(
              itemBuilder: (_, index) {
                final postModelObj = _controller.recentPosts[index];
                switch (postModelObj.viewType) {
                  case PostViewType.openPosition:
                    return OpenPositionTileWidget(
                      index: index,
                      postModel: postModelObj,
                      onEdit: _controller.onEditPost,
                      onDelete: _controller.onDeletePost,
                      onPostClick: _controller.onPostClick,
                      onClubClick: (PostModel postModel) {},
                    );
                  default:
                    return PostTileWidget(
                      index: index,
                      postModel: postModelObj,
                      onEdit: _controller.onEditPost,
                      onDelete: _controller.onDeletePost,
                      onPostClick: _controller.onPostClick,
                      onClubClick: (PostModel postModel) {},
                    );
                }
              },
              shrinkWrap: true,
              separatorBuilder: (_, ctx) => Container(
                height: AppValues.margin_10,
              ),
              itemCount: _controller.recentPosts.length,
            )
          : const NoPostWidget();*/

  /// Build filter list widget.
  Widget buildFilterList() =>
      !_controller.showNoData && _controller.filterPost.isNotEmpty
          ? ListView.separated(
              itemBuilder: (_, index) {
                final postModelObj = _controller.filterPost[index];
                switch (postModelObj.viewType) {
                  case PostViewType.openPosition:
                    return OpenPositionTileWidget(
                      postModel: postModelObj,
                      index: index,
                      onEdit: _controller.onEditPost,
                      onDelete: _controller.onDeletePost,
                      onPostClick: _controller.onPostClick,
                      onClubClick: (PostModel postModel, int index) {},
                    );
                  default:
                    return PostTileWidget(
                      postModel: postModelObj,
                      index: index,
                      onEdit: _controller.onEditPost,
                      onDelete: _controller.onDeletePost,
                      onPostClick: _controller.onPostClick,
                      onClubClick: (PostModel postModel,int index) {},
                    );
                }
              },
              shrinkWrap: true,
              separatorBuilder: (_, ctx) => Container(
                height: AppValues.margin_10,
              ),
              itemCount: _controller.filterPost.length,
            )
          : const NoPostWidget();
}
