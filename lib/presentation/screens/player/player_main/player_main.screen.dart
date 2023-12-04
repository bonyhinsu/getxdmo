import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_on_flutter/presentation/screens.dart';
import 'package:game_on_flutter/presentation/screens/player/player_club_favourite/player_club_favourite.screen.dart';
import 'package:get/get.dart';

import '../../../../infrastructure/navigation/routes.dart';
import '../../../../values/app_colors.dart';
import '../../../../values/app_constant.dart';
import '../../../../values/app_icons.dart';
import '../../../../values/app_values.dart';
import '../../../app_widgets/base_view.dart';
import '../../../app_widgets/common_bottombar_widget.dart';
import '../../club/club_profile/controllers/user_detail_controller.dart';
import 'controllers/player_main.controller.dart';

class PlayerMainScreen extends StatefulWidget with AppBarMixin {
  const PlayerMainScreen({Key? key}) : super(key: key);

  @override
  State<PlayerMainScreen> createState() => _PlayerMainScreenState();
}

class _PlayerMainScreenState extends State<PlayerMainScreen>
    with TickerProviderStateMixin {
  final PlayerMainController _controller = Get.find(tag: Routes.PLAYER_MAIN);
  late TextTheme textTheme;

  late BuildContext buildContext;

  @override
  void initState() {
    _controller.animationController = AnimationController(
      duration: const Duration(milliseconds: AppValues.scrollAnimatedDuration),
      vsync: this,
    );
    _controller.animation = CurvedAnimation(
      parent: _controller.animationController,
      curve: Curves.fastLinearToSlowEaseIn,
    );
    Get.putAsync<UserDetailService>(() async => UserDetailService(),
        permanent: true, tag: AppConstants.USER_DETAILS);

    super.initState();
    _controller.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    textTheme = Theme.of(context).textTheme;
    return Obx(() => buildBody(context));
  }

  /// Build club main screen.
  Widget buildBody(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: _controller.isHomeEnable.isTrue
          ? widget.buildHomeAppBarLogoWithActions(
              title: "", logoEnable: true, actions: [buildNotificationButton()])
          : widget.buildAppBar(
              backEnable: false,
              title: _controller.homeScreenName.value,
            ),
      body: SafeArea(
        child: Builder(builder: (context) {
          return IndexedStack(
            index: _controller.tabIndex.value,
            children: <Widget>[
              PlayerHomeScreen(),
              PlayerClubFavouriteScreen(),
              ChatMainScreen(),
              PlayerProfileScreen(),
            ],
          );
        }),
      ),
      bottomNavigationBar: bottomNavigation(),
    );
  }

  /// Build bottom navigation bar common widget.
  Widget bottomNavigation() => Container(
        color: AppColors.bottomBarBackground,
        child: CommonBottomBarWidget(
          onTap: _controller.changeTabIndex,
          currentSelectedIndex: _controller.tabIndex.value,
          items: _controller.bottomBarItems,
        ),
      );

  /// Build notification button.
  Padding buildNotificationButton() {
    return Padding(
      padding: const EdgeInsets.only(right: AppValues.appbarTopMargin),
      child: InkWell(
        onTap: () => Get.toNamed(Routes.CLUB_NOTIFICATION),
        child: Container(
          margin: const EdgeInsets.only(
              right: AppValues.smallMargin, top: AppValues.appbarTopMargin),
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8)),
          height: AppValues.appbarBackButtonSize,
          width: AppValues.appbarBackButtonSize,
          child: SvgPicture.asset(
            AppIcons.notification,
          ),
        ),
      ),
    );
  }
}
