import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:game_on_flutter/infrastructure/navigation/routes.dart';
import 'package:game_on_flutter/infrastructure/network/network_connectivity.dart';
import 'package:game_on_flutter/infrastructure/storage/preference_manager.dart';
import 'package:game_on_flutter/values/app_values.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../../../infrastructure/network/services/app_settings_service.dart';
import '../../../../values/app_constant.dart';

class SplashController extends GetxController {
  static const int splashTimeoutInSeconds = AppValues.splashDelayTimeInMilliSec;

  final logger = Logger();

  RxDouble progressValue = 0.0.obs;

  RxInt imageCounter = 0.obs;

  @override
  void onInit() {
    _getSettings();
    super.onInit();
    counterPlus();
  }

  /// Get app settings.
  void _getSettings() {
    AppSettingsService controller = Get.find(tag: AppConstants.APP_SETTINGS);
    controller.getAppSettings();
  }

  void counterPlus() {
    if (imageCounter.value == 4) {
      return;
    }
    Future.delayed(
        const Duration(
            milliseconds: AppValues.splashBackgroundCounterChangeDelay), () {
      if (imageCounter < 4) {
        imageCounter++;
      }
      counterPlus();
    });
  }

  /// wait for [splashTimeoutInSeconds] seconds then
  /// navigate to screen.
  void _setupScreens() {
    Future.delayed(const Duration(milliseconds: splashTimeoutInSeconds),
        _navigateToScreen);
  }

  /// navigate to screen,
  void _navigateToScreen() async {
    String route = "";
    if (await NetworkConnectivity.instance.hasNetwork()) {
      if (GetIt.instance<PreferenceManager>().isLogin) {
        if (GetIt.instance<PreferenceManager>().getUserType ==
            AppConstants.userTypeClub) {
          route = Routes.CLUB_MAIN;
        } else {
          route = Routes.PLAYER_MAIN;
        }
      } else {
        route = Routes.WELCOME;
      }
    } else {
      route = Routes.NO_INTERNET;
    }

    /// Navigate to screen.
    Get.offAllNamed(route);
  }

  /// Initialise preference for cache.
  Future<void> initServices() async {
    await runZonedGuarded(() async {
      try {
        ///Firebase app init
        await Firebase.initializeApp(
            options: const FirebaseOptions(
                apiKey: AppConstants.firebaseKey,
                appId: AppConstants.appId,
                messagingSenderId: AppConstants.messagingSenderId,
                authDomain: AppConstants.authenticateDomain,
                projectId: AppConstants.projectId,
                storageBucket: '${AppConstants.projectId}.appspot.com',
                measurementId: 'G-KXCQ4YXJR2'),
            name: AppConstants.appName);
      } catch (error) {
        logger.e('Firebase.initializeApp', [error]);
      }
    }, (error, stackTrace) {
      logger.e(error, [stackTrace]);
    });
    Future.delayed(const Duration(milliseconds: 1600), () {
      _setupScreens();
    });
  }
}
