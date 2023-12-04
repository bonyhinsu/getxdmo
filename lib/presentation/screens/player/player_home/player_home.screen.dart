import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../infrastructure/model/club/post/post_model.dart';
import '../../../../infrastructure/navigation/routes.dart';
import '../../../../values/app_colors.dart';
import '../../../../values/app_values.dart';
import '../../../app_widgets/app_shimmer.dart';
import '../../../app_widgets/search_view_with_filter.dart';
import '../../../custom_widgets/club_home_advertise_layout.dart';
import '../../../custom_widgets/open_position_tile_widget.dart';
import '../../../custom_widgets/post_tile_widget.dart';
import '../../club/club_profile/manage_post/view/no_post_widget.dart';
import '../../club/club_profile/manage_post/view/post_shimmer_widget.dart';
import '../player_main/controllers/player_main.controller.dart';
import 'controllers/player_home.controller.dart';

class PlayerHomeScreen extends StatefulWidget {
  PlayerHomeScreen({Key? key}) : super(key: key);

  @override
  State<PlayerHomeScreen> createState() => _PlayerHomeScreenState();
}

class _PlayerHomeScreenState extends State<PlayerHomeScreen>
    with TickerProviderStateMixin {
  late BuildContext _context;

  late ThemeData themeData;

  late TextTheme textTheme;

  late Animation<double> animation;
  late AnimationController animationController;

  final PlayerHomeController _controller = Get.find(tag: Routes.PLAYER_HOME);

  late BuildContext buildContext;

  PlayerMainController playerMainController = Get.find(tag: Routes.PLAYER_MAIN);

  late GlobalKey _appBarKey;
  double _appBarHight = 0;

  @override
  void initState() {
    _appBarKey = GlobalKey();
    SchedulerBinding.instance
        .addPostFrameCallback((_) => _calculateAppBarHeight());

    animationController = AnimationController(
      duration: const Duration(milliseconds: AppValues.scrollAnimatedDuration),
      vsync: this,
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.fastLinearToSlowEaseIn,
    );

    _controller.scrollcontroller.addListener(() {
      if (_controller.scrollcontroller.position.userScrollDirection ==
          ScrollDirection.reverse) {
        animationController.animateBack(0,
            duration:
                const Duration(milliseconds: AppValues.scrollAnimatedDuration));
        playerMainController.hideBottomBar();
      }
      if (_controller.scrollcontroller.position.userScrollDirection ==
          ScrollDirection.forward) {
        animationController.forward();
        playerMainController.showBottomBar();
      }
    });
    super.initState();
    animationController.forward();
  }

  _calculateAppBarHeight() {
    final RenderBox renderBoxRed =
        _appBarKey.currentContext?.findRenderObject() as RenderBox;
    setState(() {
      _appBarHight = renderBoxRed.size.height;
    });
    print("AppbarHieght = $_appBarHight");
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    _context = context;
    textTheme = themeData.textTheme;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppValues.screenMargin),
        child: RefreshIndicator(
          onRefresh: _controller.onRefresh,
          child: CustomScrollView(
            shrinkWrap: true,
            slivers: <Widget>[
              SliverAppBar(
                floating: true,
                backgroundColor: AppColors.pageBackground,
                expandedHeight: _appBarHight,
                snap: true,
                pinned: false,
                bottom: PreferredSize(
                  preferredSize: const Size(0, kToolbarHeight + 20),
                  key: _appBarKey,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 22.0),
                    child: buildAnimatedColumn(),
                  ),
                ),
              ),
              _buildList(),
            ],
          ),
        ),
      ),
    );
  }

  /// Build header text widget.
  Text get buildHeaderTitle => Text(AppString.recentActivity,
      style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600));

  /// Build body widget.
  Widget buildBody() => AnimatedSwitcher(
        switchOutCurve: Curves.easeOutExpo,
        switchInCurve: Curves.fastLinearToSlowEaseIn,
        duration: const Duration(
            milliseconds: AppValues.shimmerWidgetChangeDurationInMillis),
        child: _controller.isLoading.value && _controller.recentPosts.isEmpty
            ? const PostShimmerWidget()
            : !_controller.showNoData
                ? (_controller.isSearchApplied.isTrue)
                    ? buildFilterList()
                    : buildClubActivityList()
                : const NoPostWidget(),
      );

  Widget buildAnimatedColumn() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SearchViewWithFilter(
            onChange: _controller.searchForClub,
            onSearchClick: _controller.onSearchClick,
            onFilterClick: () => _controller.navigateToFilterScreen(),
            textEditingController: _controller.searchController,
            focusNode: _controller.searchFocusNode,
            isSearchApplied: _controller.isSearchApplied.value,
            enableSearch: false,
            onClearSearch: _controller.clearSearch,
            isFilterApplied: false,
          ),
          Container(
            height: AppValues.margin,
            color: AppColors.pageBackground,
          ),
          Container(
            width: double.infinity,
            color: AppColors.pageBackground,
            child: buildHeaderTitle,
          ),
        ],
      );

  /// Build list widget.
  Widget _buildList() => PagedSliverList<int, PostModel>.separated(
        shrinkWrapFirstPageIndicators: true,
        separatorBuilder: (_, ctx) => Container(
          height: AppValues.margin_10,
        ),
        pagingController: _controller.pagingController,
        builderDelegate: PagedChildBuilderDelegate<PostModel>(
            animateTransitions: true,
            firstPageErrorIndicatorBuilder: (_)=>const NoPostWidget(),
            noItemsFoundIndicatorBuilder: (_) => const NoPostWidget(),
            firstPageProgressIndicatorBuilder: (_) => const PostShimmerWidget(),
            newPageProgressIndicatorBuilder: (_) =>
                AppShimmer(child: const SinglePostShimmerWidget()),
            itemBuilder: (context, item, index) {
              switch (item.viewType) {
                case PostViewType.adv:
                  return ClubHomeAdvertiseLayout(
                    advertisementBanner: item.advertisementBanner ?? "",
                    advertisementLink: item.advertisementLink ?? "",
                    onClick: _controller.openLinkInPlatformBrowser,
                  );
                case PostViewType.openPosition:
                  return OpenPositionTileWidget(
                    index: index,
                    postModel: item,
                    onEdit: _controller.onEditPost,
                    onDelete: _controller.onDeletePost,
                    onShare: _controller.onPostShare,
                    onPostClick: _controller.onPostClick,
                    onClubClick: _controller.onClubClick,
                    postShareEnable: true,
                  );
                default:
                  return PostTileWidget(
                    index: index,
                    postModel: item,
                    onEdit: _controller.onEditPost,
                    onDelete: _controller.onDeletePost,
                    postShareEnable: true,
                    onShare: _controller.onPostShare,
                    onPostClick: _controller.onPostClick,
                    onClubClick: _controller.onClubClick,
                  );
              }
            }),
      );

  /// Build filter list widget.
  Widget buildFilterList() =>
      !_controller.showNoData && _controller.filterPost.isNotEmpty
          ? ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                if (index == 0) {
                  return const SizedBox(
                    height: AppValues.homeEmptyContainerHeight,
                  );
                }
                final postModelObj = _controller.filterPost[index - 1];
                switch (postModelObj.viewType) {
                  case PostViewType.openPosition:
                    return OpenPositionTileWidget(
                      postModel: postModelObj,
                      index: index,
                      onEdit: _controller.onEditPost,
                      onDelete: _controller.onDeletePost,
                      onShare: _controller.onPostShare,
                      onPostClick: _controller.onPostClick,
                      onClubClick: _controller.onClubClick,
                      postShareEnable: true,
                    );
                  default:
                    return PostTileWidget(
                      index: index,
                      postModel: postModelObj,
                      onEdit: _controller.onEditPost,
                      onDelete: _controller.onDeletePost,
                      onShare: _controller.onPostShare,
                      onPostClick: _controller.onPostClick,
                      onClubClick: _controller.onClubClick,
                      postShareEnable: true,
                    );
                }
              },
              shrinkWrap: true,
              separatorBuilder: (_, ctx) => Container(
                height: AppValues.margin_10,
              ),
              itemCount: _controller.filterPost.length + 1,
            )
          : const NoPostWidget();

  /// Build filter list widget.
  Widget buildClubActivityList() => ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) {
          final postModelObj = _controller.recentPosts[index];
          switch (postModelObj.viewType) {
            case PostViewType.loading:
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            case PostViewType.openPosition:
              return OpenPositionTileWidget(
                postModel: postModelObj,
                index: index,
                onEdit: _controller.onEditPost,
                onDelete: _controller.onDeletePost,
                onShare: _controller.onPostShare,
                onPostClick: _controller.onPostClick,
                onClubClick: _controller.onClubClick,
                postShareEnable: true,
              );
            default:
              return PostTileWidget(
                index: index,
                postModel: postModelObj,
                onEdit: _controller.onEditPost,
                onDelete: _controller.onDeletePost,
                onShare: _controller.onPostShare,
                onPostClick: _controller.onPostClick,
                onClubClick: _controller.onClubClick,
                postShareEnable: true,
              );
          }
        },
        shrinkWrap: true,
        separatorBuilder: (_, ctx) => Container(
          height: AppValues.margin_10,
        ),
        itemCount: _controller.recentPosts.length,
      );
}
