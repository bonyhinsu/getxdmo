import 'package:get/get.dart';

abstract class AppConstants {
  static const String appName = "Game-On";

  static const String emailPattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  static String deviceType = GetPlatform.isAndroid
      ? "A"
      : GetPlatform.isIOS
          ? "I"
          : GetPlatform.isWeb
              ? "W"
              : "O";

  static const DEVICE_INFO_KEY = "device_info";
  static const APP_SETTINGS = "app_settings";
  static const USER_DETAILS = "user-details";

  static const PRIVACY_ALL_CLUB = "For All Clubs";

  static const userActive = "A";

  /// Privacy Policy URL
  static const privacyPolicyURL = "";

  /// Terms and Condition URL
  static const termsAndConditionURL = "";

  /// Form field validation error.
  static const fieldErrorStatus = 422;

  /// Api timeout duration in secons
  static const apiTimeoutDuration = 10;

  /// Screen side margin
  static const screenSideMargin = 16.0;

  /// List Pagination single page limit
  static const paginationPageSize = 10;

  static const RANDOM_MAX_LENGTH = 10000;

  /// Google places API key.
  static const kGoogleApiKey = "AIzaSyDhIyuq2l5etgWMmutSshuOvtLEO7QgkvI";

  //APP FONT
  static const String poppins = 'Poppins';

  static const String appFont = poppins;
  static const String passwordPattern =
      '^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!.@#\$&*%~;:+?=/`_^()-]).{8,}\$';
  static const String plainTextPattern = '^w+\$';

  ///-----------Firebase Crashlytics------------
  static const String firebaseKey = "AIzaSyAe-V8ZfqJtHlTCuP0yeFCnqYHum1WZxfw";
  static const String appId = "1:1022373973149:ios:0b5595b1b08340bdf35874";
  static const String webAppId = "1:1022373973149:web:c02f588a514d9d33f35874";
  static const String messagingSenderId = "1022373973149";
  static const String projectId = "gameon-9ec4a";
  static const String authenticateDomain = "$projectId.firebaseapp.com";

  static const firebaseServerKey ="AAAA7go8zJ0:APA91bHVrMQT-T5y_5k995vdRRAr7UEztxBoZAzAUeVSFSCvVjAZQFn-UYWWrqRkF5ek82u6alV8IwHorV4ZQUhIy3h-c93Hq5eYw8YtELX-dm5L4ey_MQHeoBk8aM0uJv75e1rfMlsE";

  ///-----------user role type------------
  static const int userTypeClub = 1;
  static const int userTypePlayer = 2;

  static const String userTypePlayerInWord = 'player';
  static const String userTypeClubInWord = 'club';


  ///-----------Club Member type------------
  static const String rolePresident = 'President';
  static const String roleDirector = 'Director';
  static const String roleCoach = 'Coach';

  ///-----------Post Type------------
  static const String postTypePost = 'Post';
  static const String postTypeEvent = 'Event';
  static const String postTypeOpenPosition = 'Open Positions';
  static const String postTypeResult = 'Result';

  static const int postTypeIdPost = 3;
  static const int postTypeIdEvent = 1;
  static const int postTypeIdOpenPosition = 4;
  static const int postTypeIdResult = 2;

  static const image = "image";
  static const gif = "gif";
  static const text = "text";



  ///-----------Message type------------
  static const textMessage = 0;

  static const pageSize = 10;

  static const randomMaxLength = 10000;

  /// Specify total length of images which should be uploaded from edit player
  /// or edit club.
  static const MULTI_IMAGE_MAX_SIZE = 6;
  static const MAX_IMAGE_TO_SHOW = 4;
}
