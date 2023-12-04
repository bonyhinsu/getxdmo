import 'dart:convert';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:game_on_flutter/infrastructure/model/common/app_fields.dart';
import 'package:game_on_flutter/infrastructure/navigation/route_config.dart';
import 'package:game_on_flutter/infrastructure/storage/preference_manager.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../presentation/screens/chats/private_chat/controllers/private_chat.controller.dart';
import '../values/app_constant.dart';
import '../values/firebase_params.dart';
import 'firebase/firestore_manager.dart';
import 'model/chat/fcm_response.dart';
import 'navigation/routes.dart';

class NotificationService {
  static const CHANNEL_ID = "1092";
  static const CHANNEL_NAME = "App Notifications";
  static const CHANNEL_DESCRIPTION = "Shows app update notification";
  static const NOTIFICATION_ID = 2381;

  final logger = Logger();

  //Singleton pattern
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  int _lastNotificationTimeStamp = 0;
  bool _isNotificationShowing = false;
  int _notificationId = 0;

  NotificationService._internal();

  //instance of FlutterLocalNotificationsPlugin
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  NotificationDetails? platformChannelSpecifics;

  Future<void> init() async {
    if (flutterLocalNotificationsPlugin == null) {
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      //Initialization Settings for Android
      final AndroidInitializationSettings initializationSettingsAndroid =
          const AndroidInitializationSettings('@drawable/app_icon');

      //Initialization Settings for iOS
      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
      );

      //InitializationSettings for initializing settings for both platforms (Android & iOS)
      final InitializationSettings initializationSettings =
          InitializationSettings(
              android: initializationSettingsAndroid,
              iOS: initializationSettingsIOS);

      await flutterLocalNotificationsPlugin?.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (val) => onTapNotification(val),
      );

      initialiseNotificationService();
    }
  }

  void initialiseNotificationService() {
    late AndroidNotificationDetails _androidNotificationDetails =
        const AndroidNotificationDetails(
      CHANNEL_ID,
      CHANNEL_NAME,
      channelDescription: CHANNEL_DESCRIPTION,
      playSound: true,
      icon: '@drawable/app_icon',
      priority: Priority.high,
      importance: Importance.high,
    );
    late DarwinNotificationDetails _iosNotificationDetails =
        const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: null,
            presentSound: true,
            badgeNumber: null);
    platformChannelSpecifics = NotificationDetails(
        android: _androidNotificationDetails, iOS: _iosNotificationDetails);
  }

  /// On tap of notification
  void onTapNotification(NotificationResponse details) {
    //Click on notification will execute this
    _selectNotification(details.payload);
  }

  // void clear all notifications.
  void clearNotifications() {
    flutterLocalNotificationsPlugin?.cancel(0);
  }

  /// Parse notification payload and handle click
  Future _selectNotification(String? payload) async {
    try {
      Get.log("SelectNotification clicked");
      if ((payload ?? "").isNotEmpty) {
        Get.log("SelectNotification : payload parse");
        FCMResponse response = FCMResponse.fromJson(json.decode(payload ?? ""));
        handleNotificationClickWithPayload(response);
      } else {
        Get.log("SelectNotification payload empty");
        _startApplication();
      }
    } catch (ex) {
      Get.log("SelectNotification $ex");
      _startApplication();
    }
  }

  /// Start application for empty payload.
  _startApplication({bool isAppOpened = false}) {
    if (isAppOpened) {
      return;
    }
    // if (PreferenceManager.instance.getIsLogin()) {
    //   Get.offNamed(BaseRouter.TAB_BAR);
    // } else {
    //   Get.offNamed(BaseRouter.SPLASH_SCREEN);
    // }
  }

  /// Start notification click with payload.
  void handleNotificationClickWithPayload(FCMResponse response,
      {bool isAppOpened = false}) async {
    final firebaseUserId = response.senderId ?? "";
    final userId = response.friendId ?? "";

    Get.lazyPut(() => PrivateChatController(),
        tag: "${Routes.PRIVATE_CHAT}/$firebaseUserId", fenix: true);

    final _threadId = await FireStoreManager.instance.getUserChatWith(
        myId: PreferenceManager.instance.userUUID, friendId: firebaseUserId);

    Get.toNamed(Routes.PRIVATE_CHAT, arguments: {
      RouteArguments.firebaseUserId: firebaseUserId,
      RouteArguments.userId: userId,
      RouteArguments.threadId: _threadId,
    });
  }

  Future<bool> sendFCMPushNotifications(List<String> userToken,
      {required String notificationPayload,
      String senderName = "",
      String userId = "",
      String body = "",
      int notificationType = AppConstants.textMessage,
      required senderUserId,
      required receiverUserId}) async {
    const sendNotificationFirebaseURL = 'https://fcm.googleapis.com/fcm/send';

    final data = {
      "registration_ids": userToken,
      "collapse_key": "${DateTime.now().millisecondsSinceEpoch}",
      "priority": "high",
      "notification": {
        "title": "$senderName : ",
        "body": body,
      },
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "status": "done",
        "sound": 'default',
        FirebaseParams.notificationPayload: notificationPayload,
        FirebaseParams.senderId: senderUserId,
        FirebaseParams.receiverId: receiverUserId,
        FirebaseParams.notificationType: notificationType,
        FirebaseParams.friendId: userId,
      },
      "apns": {
        "payload": {
          "aps": {"mutable-content": 1}
        }
      }
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization': "key=${AppConstants.firebaseServerKey}"
    };

    final gConnection = GetConnect(timeout: const Duration(seconds: 3000));
    final response = await gConnection
        .post(sendNotificationFirebaseURL, json.encode(data), headers: headers);

    gConnection.httpClient.close();
    if (response.statusCode == 200) {
      logger.i(
          "Notification has been sent :::payload $data \n\n ${response.bodyString}");
      return true;
    } else {
      logger.i("Notification not sent :Response> ${response.bodyString}");
      return false;
    }
  }

  /// Show Firebase notification.
  Future<void> showFirebaseNotifications(
      {String title = "", String body = "", String payload = ""}) async {
    Random _random = Random();
    int _randomNumber = _random.nextInt(AppConstants.randomMaxLength);

    logger.i(
        "Notification Received title: $title  body:: $body payload::$payload");

    /// Disable notification if user has not allow chat feature.
    if (!AppFields.instance.enableChat) {
      return;
    }

    if (_isNotificationShowing || _notificationId == _randomNumber) {
      return;
    } else {
      _isNotificationShowing = true;
      _notificationId = _randomNumber;
    }

    if (_lastNotificationTimeStamp != 0) {
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(_lastNotificationTimeStamp);
      if (DateTime.now().isAtSameMomentAs(dateTime)) {
        _isNotificationShowing = false;
        return;
      }
    }

    _lastNotificationTimeStamp = DateTime.now().millisecondsSinceEpoch;

    if (platformChannelSpecifics == null) {
      initialiseNotificationService();
    }
    try {
      if (payload.isNotEmpty) {
        Get.log(
            "notification_payload ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: " +
                payload);
        FCMResponse response = FCMResponse.fromJson(json.decode(payload));
        _notificationId = response.receiverId.hashCode;
      }
    } catch (ex) {
      logger.e("showFirebaseNotifications", ex.toString());
    }

    await flutterLocalNotificationsPlugin?.show(
      _notificationId,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
    _isNotificationShowing = false;
  }

  /// delete notification matched with notification id.
  void clearNotification(String chatId) {
    final _notificationId = chatId.hashCode;
    flutterLocalNotificationsPlugin?.cancel(_notificationId);
  }
}
