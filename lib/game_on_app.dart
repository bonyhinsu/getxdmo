import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:game_on_flutter/infrastructure/network/network_connectivity.dart';
import 'package:game_on_flutter/values/app_colors.dart';
import 'package:game_on_flutter/values/app_font_size.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:lottie/lottie.dart';

import 'infrastructure/navigation/navigation.dart';
import 'infrastructure/navigation/routes.dart';
import 'values/app_text_theme.dart';

class GameOnApplication extends StatefulWidget {
  const GameOnApplication({Key? key}) : super(key: key);

  @override
  State<GameOnApplication> createState() => _GameOnApplicationState();
}

class _GameOnApplicationState extends State<GameOnApplication> {
  final NetworkConnectivity _connectivity = NetworkConnectivity.instance;

  @override
  void initState() {
    super.initState();
    _connectivity.initialise();
  }

  @override
  void dispose() {
    _connectivity.disposeStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const spinkit = SpinKitFadingCircle(
      duration: Duration(milliseconds: 400),
      size: 40,
      color: Colors.white,
    );

    final lottieAnimation = Lottie.asset(
      'assets/lottie_json/loading_ball.json',
      width: 100,
      height: 100,
      delegates: LottieDelegates(
        values: [
          ValueDelegate.color(
            const ['Shape Layer 1', 'Rectangle', 'Fill 1'],
            value: Colors.white,
          ),
        ],
      ),
    );

    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: AppColors.pageBackground));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.black,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Container(
            constraints: (GetPlatform.isWeb || GetPlatform.isDesktop)
                ? const BoxConstraints(minWidth: 500, maxWidth: 550)
                : const BoxConstraints.tightForFinite(),
            child: GlobalLoaderOverlay(
              overlayOpacity: 0.5,
              overlayColor: Colors.black,
              useDefaultLoading: false,
              closeOnBackButton: kDebugMode,
              overlayWholeScreen: true,
              overlayWidget: Center(
                child: lottieAnimation,
              ),
              child: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.dark,
                child: GetMaterialApp(
                  title: AppString.appTitle,
                  debugShowCheckedModeBanner: false,
                  enableLog: true,
                  initialRoute: Routes.initialRoute,
                  getPages: Nav.routes,
                  themeMode: ThemeMode.light,
                  builder: (context, child) {
                    final mediaQueryData = MediaQuery.of(context);
                    final constrainedTextScaleFactor =
                        mediaQueryData.textScaleFactor.clamp(0.0, 1.0);

                    return MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                            textScaleFactor: constrainedTextScaleFactor),
                        child: child!);
                  },
                  theme: ThemeData(
                    scaffoldBackgroundColor: AppColors.pageBackground,
                    primarySwatch: AppColors.colorPrimarySwatch,
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    splashFactory: NoSplash.splashFactory,
                    bottomSheetTheme: const BottomSheetThemeData(
                        backgroundColor: AppColors.pageBackground,
                        clipBehavior: Clip.hardEdge),
                    brightness: Brightness.dark,
                    primaryColor: AppColors.colorPrimary,
                    textTheme: textThemeLight(),
                    fontFamily: FontConstants.poppins,
                  ),
                  home: AnnotatedRegion<SystemUiOverlayStyle>(
                    value: SystemUiOverlayStyle.dark
                        .copyWith(statusBarColor: AppColors.pageBackground),
                    child: SafeArea(
                      child: Container(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
