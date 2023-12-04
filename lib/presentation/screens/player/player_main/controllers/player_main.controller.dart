import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../../infrastructure/firebase/firebase_service.dart';
import '../../../../../infrastructure/notification_service.dart';
import '../../../../../infrastructure/storage/preference_manager.dart';
import '../../../../../values/app_constant.dart';
import '../../../../../values/app_icons.dart';
import '../../../../../values/app_string.dart';
import '../../../../../values/app_values.dart';
import '../../../club/club_main/controllers/club_main.controller.dart';
import '../../../club/club_profile/controllers/user_detail_controller.dart';

class PlayerMainController extends GetxController {
  /// Stores and return selected tab index.
  /// Default 0.
  RxInt tabIndex = 0.obs;

  RxBool isHomeEnable = true.obs;

  /// Stores and retrieve title of selected tab.
  RxString homeScreenName = AppString.home.obs;

  late AnimationController animationController;

  late Animation<double> animation;

  ScrollController scrollController = ScrollController();

  @override
  void onInit() async {
    /// Initiate firebase and notification
    if (NotificationService().flutterLocalNotificationsPlugin == null) {
      await NotificationService().init();
    }

    FirebaseService().registerNotification(_saveFirebaseTokenToServer);

    FirebaseService().checkForInitialMessage();
    FirebaseMessaging.onBackgroundMessage(
        FirebaseService().firebaseMessagingBackgroundHandler);
    super.onInit();
  }

  ///Bottom bar item widget.
  final bottomBarItems = [
    /// Home tab icon
    BottomBarItem(
        title: AppString.home,
        icon: AppIcons.homeIcon,
        selectedIcon: AppIcons.homeSelectedIcon,
        itemIndex: 0),

    /// Favourite tab icon
    BottomBarItem(
        title: AppString.favourite,
        icon: AppIcons.heartIcon,
        selectedIcon: AppIcons.heartSelectedIcon,
        itemIndex: 1),

    /// Agent tab icon
    BottomBarItem(
        title: AppString.chat,
        icon: AppIcons.chatIcon,
        itemIndex: 2,
        selectedIcon: AppIcons.chatSelectedIcon),

    /// Profile tab icon
    BottomBarItem(
        title: AppString.profile,
        icon: AppIcons.profileIcon,
        selectedIcon: AppIcons.profileSelectedIcon,
        itemIndex: 3),
  ];

  /// change tabIndex,title and icons based on bottom item selected.
  void changeTabIndex(int index) {
    /// Update current index to reflect screen based on tab selection.
    tabIndex.value = index;

    switch (index) {
      case 0:
        isHomeEnable.value = true;
        homeScreenName.value = AppString.home;
        break;

      case 1:
        isHomeEnable.value = false;
        homeScreenName.value = AppString.favouriteClubs;
        break;

      case 2:
        isHomeEnable.value = false;
        homeScreenName.value = AppString.chat;

        break;
      case 3:
        isHomeEnable.value = false;
        homeScreenName.value = AppString.profile;
        break;
    }
  }

  /// Save firebase token to the server.
  void _saveFirebaseTokenToServer() {
    if(GetIt.I<PreferenceManager>().firstTimeLogin) {
      Future.delayed(const Duration(seconds: 1), () {
        final UserDetailService service =
        Get.find(tag: AppConstants.USER_DETAILS);
        service.saveFirebaseTokenToServer();
        GetIt.I<PreferenceManager>().setFirstLoggedIn(false);
      });
    }
  }

  /// hide bottomBar animation
  void showBottomBar() {
    animationController.forward();
  }

  /// Show bottomBar animation.
  void hideBottomBar() {
    animationController.animateBack(0,
        duration:
            const Duration(milliseconds: AppValues.scrollAnimatedDuration));
  }
}
