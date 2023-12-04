import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_on_flutter/presentation/screens.dart';
import 'package:get/get.dart';

import '../../../../infrastructure/model/common/app_fields.dart';
import '../../../../infrastructure/navigation/routes.dart';
import '../../../../values/app_colors.dart';
import '../../../../values/app_icons.dart';
import '../../../../values/app_values.dart';
import '../../../app_widgets/base_view.dart';
import '../../../app_widgets/common_bottombar_widget.dart';
import '../../chats/chat_main/view/disabled_chat_screen.dart';
import 'controllers/club_main.controller.dart';

class ClubMainScreen extends StatefulWidget with AppBarMixin {
  ClubMainScreen({Key? key}) : super(key: key);

  @override
  State<ClubMainScreen> createState() => _ClubMainScreenState();
}

class _ClubMainScreenState extends State<ClubMainScreen>
    with TickerProviderStateMixin {
  final ClubMainController _controller = Get.find(tag: Routes.CLUB_MAIN);

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
      appBar: _controller.isHomeEnable.isTrue
          ? widget.buildHomeAppBarLogoWithActions(
              title: "", logoEnable: true, actions: [buildNotificationButton()])
          : widget.buildAppBar(
              backEnable: false,
              title: _controller.homeScreenName.value,
            ),
      body: Builder(builder: (context) {
        return PageTransitionSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (widget, anim1, anim2) {
            return FadeScaleTransition(
              animation: anim1,
              child: widget,
            );
          },
          child: IndexedStack(
            index: _controller.tabIndex.value,
            children: <Widget>[
              ClubHomeScreen(),
              ClubFavoriteScreen(),
              ChatMainScreen(),
              ClubProfileScreen(),
            ],
          ),
        );
      }),
      bottomNavigationBar: bottomNavigation(),
    );
  }

  /// Build bottom navigation bar common widget.
  Widget bottomNavigation() =>  Container(
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
