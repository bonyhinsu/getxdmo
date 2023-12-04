import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_on_flutter/values/app_values.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../values/app_colors.dart';
import '../../../values/app_images.dart';
import 'controllers/splash.controller.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final SplashController _controller = Get.find();

  SplashController get controller => _controller;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(
        milliseconds: 2000,
      ),
      vsync: this,
      value: 0.4,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    Future.delayed(
        const Duration(
            milliseconds: AppValues.splashBackgroundCounterChangeDelay), () {
      _animationController.forward();
    });
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: FutureBuilder(
          future: _controller.initServices(),
          builder: (_, index) => SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Obx(() => splashBgItem())),
        ),
      ),
    );
  }

  Widget buildSplashBackground() {
    Widget child = Container();
    switch (_controller.imageCounter.value) {
      case 0:
        child = buildImage1();
        break;
      case 1:
        child = buildImage2();
        break;
      case 2:
        child = buildImage3();
        break;
      case 3:
        child = buildImage4();
        break;
    }
    return AnimatedSwitcher(
        duration: const Duration(
          milliseconds: 400,
        ),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        switchInCurve: const Interval(0.0, 1.0, curve: Curves.easeIn),
        child: child);
  }

  /// Build splash logo widget.
  Widget newSplashLogo() => ScaleTransition(
        scale: _animation,
        alignment: Alignment.center,
        child: FadeTransition(
          opacity: _animation,
          child: Hero(
            tag: 'app_logo',
            child: Image.asset(
              height: AppValues.splashLogoWidth,
              width: AppValues.splashLogoWidth,
              AppImages.splashLogo,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );

  /// Build image1.
  Widget buildImage1() => Container(
        child: AnimatedOpacity(
          duration: const Duration(
              milliseconds: AppValues.splashBackgroundAnimationMillis),
          opacity: _controller.imageCounter > 0 ? 1 : 0,
          key: const Key('image1'),
          child: Image.asset(
            AppImages.splashOne,
            fit: BoxFit.cover,
          ),
        ),
      );

  /// Build image2.
  Widget buildImage2() => AnimatedOpacity(
        duration: const Duration(
            milliseconds: AppValues.splashBackgroundAnimationMillis),
        opacity: _controller.imageCounter > 1 ? 1 : 0,
        key: const Key('image2'),
        child: Image.asset(
          AppImages.splashTwo,
          fit: BoxFit.cover,
        ),
      );

  /// Build image3.
  Widget buildImage3() => AnimatedOpacity(
        duration: const Duration(
            milliseconds: AppValues.splashBackgroundAnimationMillis),
        opacity: _controller.imageCounter > 2 ? 1 : 0,
        key: const Key('image3'),
        child: Image.asset(
          AppImages.splashThree,
          fit: BoxFit.cover,
        ),
      );

  /// Build image4.
  Widget buildImage4() => AnimatedOpacity(
        duration: const Duration(
            milliseconds: AppValues.splashBackgroundAnimationMillis),
        opacity: _controller.imageCounter > 3 ? 1 : 0,
        key: const Key('image4'),
        child: Image.asset(
          AppImages.splashFour,
          fit: BoxFit.cover,
        ),
      );

  /// Build animated progress widget.
  Widget buildAnimationProgress() {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: AppValues.splashLogoWidth,
        child: LinearPercentIndicator(
          width: AppValues.splashLogoWidth,
          lineHeight: AppValues.splashProgressHeight,
          animation: true,
          animationDuration: AppValues.splashLoadingAnimationTimeInMilliSec,
          padding: EdgeInsets.zero,
          barRadius: const Radius.circular(AppValues.extraLargeRadius),
          progressColor: AppColors.splashProgressColor,
          percent: 1,
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }

  /// Build center logo widget.
  Widget buildCenterLogoWidget(String splashLogo) {
    return AnimatedSwitcher(
      duration: const Duration(),
      child: Image.asset(
        splashLogo,
        fit: BoxFit.cover,
      ),
    );
  }

  /// Build splash bg item.
  Widget splashBgItem() {
    return Stack(
      fit: StackFit.expand,
      children: [
        buildImage1(),
        buildImage2(),
        buildImage3(),
        buildImage4(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            newSplashLogo(),
          ],
        ),
      ],
    );
  }
}
