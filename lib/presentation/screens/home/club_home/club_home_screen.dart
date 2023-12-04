import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_button_mixin.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_textfield.dart';
import 'package:game_on_flutter/presentation/screens/home/club_home/view/club_activity_shimmer_widget.dart';
import 'package:game_on_flutter/values/app_values.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../infrastructure/model/club/home/recent_model.dart';
import '../../../../infrastructure/navigation/routes.dart';
import '../../../../values/app_colors.dart';
import '../../../../values/app_icons.dart';
import '../../../../values/app_string.dart';
import '../../../app_widgets/app_shimmer.dart';
import '../../../app_widgets/search_view_with_filter.dart';
import '../../../custom_widgets/club_home_advertise_layout.dart';
import '../../../custom_widgets/recent_home_tile_widget.dart';
import '../../club/club_main/controllers/club_main.controller.dart';
import '../../club/club_profile/manage_post/view/no_post_widget.dart';
import '../../club/club_profile/manage_post/view/post_shimmer_widget.dart';
import 'controllers/club_home_controller.dart';

class ClubHomeScreen extends StatefulWidget with AppTextField, AppButtonMixin {
  ClubHomeScreen({Key? key}) : super(key: key);

  @override
  State<ClubHomeScreen> createState() => _ClubHomeScreenState();
}

class _ClubHomeScreenState extends State<ClubHomeScreen>
    with TickerProviderStateMixin {
  final ClubHomeController _controller = Get.find(tag: Routes.CLUB_HOME);

  late ThemeData themeData;

  late TextTheme textTheme;

  late Animation<double> animation;
  late AnimationController animationController;

  ClubMainController clubMainController = Get.find(tag: Routes.CLUB_MAIN);
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
        clubMainController.hideBottomBar();
      }
      if (_controller.scrollcontroller.position.userScrollDirection ==
          ScrollDirection.forward) {
        animationController.forward();
        clubMainController.showBottomBar();
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
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    textTheme = themeData.textTheme;

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppValues.screenMargin),
          child: RefreshIndicator(
            onRefresh: _controller.onRefresh,
            child: CustomScrollView(
                shrinkWrap: true,
                controller: clubMainController.scrollController,
                slivers: <Widget>[
                  SliverAppBar(
                    floating: true,
                    backgroundColor: AppColors.pageBackground,
                    expandedHeight: _appBarHight,
                    snap: true,
                    pinned: false,
                    elevation: 0,
                    bottom: PreferredSize(
                      preferredSize: const Size(0, kToolbarHeight + 40),
                      key: _appBarKey,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 22.0),
                        child: buildColumn(),
                      ),
                    ),
                  ),
                  buildRecentListWidget()
                ]),
          ),
        ),
    );
  }

  /// Build column widget
  Widget buildColumn() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          buildHeader(),
          Container(
            color: AppColors.pageBackground,
            height: AppValues.margin_15,
          ),
          buildRecentRowWidget(),
        ],
      );

  /// Build list widget.
  Widget buildRecentListWidget() => PagedSliverList<int, RecentModel>.separated(
    shrinkWrapFirstPageIndicators: true,
        separatorBuilder: (_, ctx) => Container(
          height: AppValues.margin_10,
        ),
        pagingController: _controller.pagingController,
        builderDelegate: PagedChildBuilderDelegate<RecentModel>(
            animateTransitions: true,
            firstPageErrorIndicatorBuilder: (_) => const NoPostWidget(),
            noItemsFoundIndicatorBuilder: (_) => const NoPostWidget(),
            firstPageProgressIndicatorBuilder: (_) =>
                const ClubActivityShimmerWidget(),
            newPageProgressIndicatorBuilder: (_) =>
                AppShimmer(child: const SinglePostShimmerWidget()),
            itemBuilder: (context, item, index) {
              if (item.isAdvertisement) {
                return ClubHomeAdvertiseLayout(
                  advertisementBanner: item.advertisementBanner??"",
                  advertisementLink: item.advertisementLink??"",
                  onClick: _controller.openLinkInPlatformBrowser,
                );
              }
              return RecentHomeTileWidget(
                index: index,
                onLikeChange: _controller.onLikeChange,
                onTap: _controller.playerDetailScreen,
                postModel: item,
              );
            }),
      );

  /// build recentRow Widget
  Widget buildRecentRowWidget() {
    return Container(
      color: AppColors.pageBackground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppString.recentActivity,
            textAlign: TextAlign.center,
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textColorSecondary,
            ),
          ),
          GestureDetector(
            onTap: () => _controller.onAddPostClick(),
            child: Container(
              padding: const EdgeInsets.only(
                  top: AppValues.margin_10,
                  bottom: AppValues.margin_10,
                  right: AppValues.margin_15,
                  left: AppValues.margin_12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                ), //Border.all
                borderRadius: BorderRadius.circular(AppValues.smallRadius),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    color: AppColors.appWhiteButtonColor,
                    AppIcons.iconAdd,
                    height: AppValues.iconSize_24,
                    width: AppValues.iconSize_24,
                  ),
                  const SizedBox(
                    width: AppValues.margin_5,
                  ),
                  Text(
                    AppString.post,
                    textAlign: TextAlign.center,
                    style: textTheme.displaySmall
                        ?.copyWith(color: AppColors.appWhiteButtonColor),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Build header widget.
  Widget buildHeader() {
    return SearchViewWithFilter(
      onFilterClick: () => _controller.navigateToFilterScreen(),
      textEditingController: null,
      focusNode: null,
      isFilterApplied: false,
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
                  child: widget.appGrayButton(
                      buttonRadius: AppValues.radius_12,
                      title: AppString.changeFilter,
                      onClick: _controller.navigateToFilterScreen))
          ],
        )),
      );
}
