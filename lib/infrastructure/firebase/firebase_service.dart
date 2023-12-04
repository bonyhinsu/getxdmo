import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../presentation/screens/chats/private_chat/controllers/private_chat.controller.dart';
import '../../values/app_constant.dart';
import '../model/chat/fcm_response.dart';
import '../navigation/routes.dart';
import '../notification_service.dart';
import '../storage/preference_manager.dart';
import 'firestore_manager.dart';

class FirebaseService {
  final logger = Logger();

  // FirebaseMessaging? _messaging;
  NotificationSettings? settings;

  //Singleton pattern
  static final FirebaseService _firebaseService = FirebaseService._internal();

  factory FirebaseService() {
    return _firebaseService;
  }

  FirebaseService._internal();

  void registerNotification(Function saveTokenToServer) async {
    try {
      // On iOS, this helps to take the user permissions
      settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        provisional: false,
        sound: true,
      );
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: false,
        badge: false,
        sound: false,
      );

      /// Get token from firebase and save to session.
      await FirebaseMessaging.instance.getToken().then((token) async {
        logger.i("Device Token = $token");
        if (token != null) {
          if (token.isNotEmpty) {
            GetIt.I<PreferenceManager>().setFirebaseToken(token);

            GetIt.I<FireStoreManager>().updateUserData(
                fcmToken: token, userId: GetIt.I<PreferenceManager>().userUUID);

            saveTokenToServer();
          }
        }
      });

      registerFirebaseForBackground();
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        logger.i("onMessage Received ${message.data}");

        /// If notification permission granted then listen for upcoming notification from firebase.
        if (settings?.authorizationStatus == AuthorizationStatus.authorized) {
          String payload = "";

          if (!GetIt.I<PreferenceManager>().isLogin) {
            return;
          }
          try {
            FCMResponse response = FCMResponse.fromJson(message.data);

            if (response.payloadData?.messageType == null) {
              response.payloadData?.messageType == AppConstants.textMessage;
            }

            if (response.senderId == GetIt.I<PreferenceManager>().userUUID) {
              return;
            }

            payload = json.encode(response.toJson());

            bool isControllerRegister = Get.isRegistered<PrivateChatController>(
                tag: "${Routes.PRIVATE_CHAT}/${response.senderId}");

            if (isControllerRegister) {
              PrivateChatController _controller =
                  Get.find(tag: "${Routes.PRIVATE_CHAT}/${response.senderId}");

              print('addMessageToList');
              _controller.addMessageToList(response.payloadData!);
            } else {
              _showNotification(
                  title: message.notification?.title ?? "",
                  body: message.notification?.body ?? "",
                  payload: payload);
            }

            _refreshThreads();
          } catch (ex) {
            logger.e("FirebaseMessaging.onMessage", ex);
          }
        }
      });
    } catch (ex) {
      logger.e("registerNotification", ex);
    }
  }

  /// show notification
  void _showNotification(
      {String title = "", String body = "", String payload = ""}) {
    NotificationService()
        .showFirebaseNotifications(title: title, payload: payload, body: body);
  }

  /// Method for handling background notification
  Future firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    if (settings?.authorizationStatus == AuthorizationStatus.authorized) {
      logger.i("Notification Received ${message.data}");

      String payload = "";
      try {
        FCMResponse response = FCMResponse.fromJson(message.data);
        payload = json.encode(response.toJson());
      } catch (ex) {
        print(ex);
      }

      if (GetPlatform.isAndroid) {
        // Parse the message received
        NotificationService().showFirebaseNotifications(
            title: message.notification?.title ?? "",
            payload: payload,
            body: message.notification?.body ?? "");
      }

      if (GetPlatform.isIOS) {
        FCMResponse response = FCMResponse.fromJson(message.data);
        NotificationService().handleNotificationClickWithPayload(response);
      }
    }
  }

  /// Listen for upcoming message when app is in background but not terminated.
  void registerFirebaseForBackground() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      logger.i("Notification Received ");
      if (settings?.authorizationStatus == AuthorizationStatus.authorized) {
        String payload = "";
        try {
          FCMResponse response = FCMResponse.fromJson(message.data);
          payload = json.encode(response.toJson());
        } catch (ex) {
          if (kDebugMode) {
            print(ex);
          }
        }

        if (GetPlatform.isAndroid) {
          FCMResponse response = FCMResponse.fromJson(message.data);
          NotificationService().handleNotificationClickWithPayload(response);
        }

        if (GetPlatform.isIOS) {
          FCMResponse response = FCMResponse.fromJson(message.data);
          NotificationService().handleNotificationClickWithPayload(response);
        }
      }
    });
  }

  // For handling notification when the app is in terminated state
  checkForInitialMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      logger.i("Notification Received ${initialMessage.data}");

      try {
        FCMResponse response = FCMResponse.fromJson(initialMessage.data);
        NotificationService()
            .handleNotificationClickWithPayload(response, isAppOpened: true);
      } catch (ex) {
        print(ex);
      }
    }
  }

  /// Remove firebase instance.
  void removeFirebaseInstance() {
    FirebaseMessaging.instance.deleteToken();
  }

  /// Refresh threads.
  void _refreshThreads() {
    // Provider.of<ThreadChangeNotifier>(Get.context!, listen: false)
    //     .updateThreads();
  }
}
