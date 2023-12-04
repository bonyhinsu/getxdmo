import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:game_on_flutter/presentation/screens/player/player_home/controllers/player_home.controller.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:logger/logger.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;

import '../infrastructure/model/club/post/post_list_model.dart';
import '../infrastructure/model/club/post/post_model.dart';
import '../infrastructure/navigation/routes.dart';
import '../infrastructure/storage/preference_manager.dart';

class CommonUtils {
  static final logger = Logger();
  static bool isLogoutInProcess = false;

  /// Method for hide and show App loader.
  static void hideShowLoadingIndicator(
      {required BuildContext context, required bool isShow}) {
    isShow ? context.loaderOverlay.show() : context.loaderOverlay.hide();
  }

  /// Method for show error message when something wrong.
  static void showErrorSnackBar(
      {String title = "", required String message, int seconds = 5}) {
    BuildContext? context = Get.context;
    Flushbar(
      title: title.isNotEmpty ? title : null,
      message: message,
      isDismissible: true,
      backgroundColor: Colors.red,
      messageColor: Colors.white,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      flushbarPosition: FlushbarPosition.TOP,
      duration: Duration(seconds: seconds),
    ).show(context!);
  }

  /// Method for show message when there is no internet.
  void showNetworkError() {
    BuildContext? context = Get.context;
    Flushbar(
      title: AppString.noInternet,
      message: AppString.noInternetMessage,
      isDismissible: true,
      backgroundColor: Colors.blue,
      messageColor: Colors.white,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      flushbarPosition: FlushbarPosition.TOP,
      duration: const Duration(seconds: 5),
    ).show(context!);
  }

  /// Method for show information message to user.
  static void showInfoSnackBar(
      {String title = "",
      required String message,
      Duration duration = const Duration(seconds: 5)}) {
    BuildContext? context = Get.context;
    Flushbar(
      title: title.isNotEmpty ? title : null,
      message: message,
      isDismissible: true,
      backgroundColor: Colors.orangeAccent,
      messageColor: Colors.white,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      flushbarPosition: FlushbarPosition.TOP,
      duration: duration,
    ).show(context!);
  }

  /// Method for show information message to user.
  static void showProgressSnackBar(
      {String title = "",
      required String message,
      required AnimationController progressIndicatorController}) {
    BuildContext? context = Get.context;
    Flushbar(
      title: title.isNotEmpty ? title : null,
      message: message,
      isDismissible: true,
      backgroundColor: Colors.black,
      messageColor: Colors.white,
      progressIndicatorBackgroundColor: Colors.white,
      showProgressIndicator: true,
      progressIndicatorController: progressIndicatorController,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      flushbarPosition: FlushbarPosition.TOP,
      duration: const Duration(seconds: 5),
    ).show(context!);
  }

  /// Method for show success message to user.
  static void showSuccessSnackBar(
      {String title = "", required String message, int duration = 5}) {
    BuildContext? context = Get.context;
    Flushbar(
      title: title.isNotEmpty ? title : null,
      message: message,
      isDismissible: true,
      backgroundColor: Colors.green,
      messageColor: Colors.white,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      flushbarPosition: FlushbarPosition.TOP,
      duration: Duration(seconds: duration),
    ).show(context!);
  }

  /// Return flushbar for no internet message.
  static Flushbar getNoInternetFlushbar(
      {required String title, required String message, int delaySeconds = 5}) {
    return Flushbar(
      message: message,
      icon: const Icon(
        Icons.wifi_off,
        color: Colors.white,
      ),
      isDismissible: false,
      backgroundColor: Colors.black,
      messageColor: Colors.white,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      flushbarPosition: FlushbarPosition.TOP,
      shouldIconPulse: true,
      blockBackgroundInteraction: false,
    );
  }

  ///Shows message when there is any connection issue.
  void showConnectionError() {
    CommonUtils.showErrorSnackBar(title: "", message: AppString.serverError);
  }

  ///Shows message when server is unreachable (response returns between 500 to 509).
  void showServerDownError() {
    CommonUtils.showErrorSnackBar(
        title: "", message: AppString.connectionError);
  }

  ///Shows message when api not found (response returns 404).
  static void showApiNotFoundError() {
    CommonUtils.showErrorSnackBar(title: "", message: AppString.pageNotFound);
  }

  /// Shows message when api has any data related error.
  void showSomethingIssueError() {
    CommonUtils.showErrorSnackBar(
        title: "", message: AppString.somethingWrongTryAgainAfterSometime);
  }

  ///Method for logout user with clearing all stored data.
  static void logout() {
    GetIt.I<PreferenceManager>().clearAll();
    Future.delayed(const Duration(seconds: 1), () {
      isLogoutInProcess = false;

      Get.offAllNamed(Routes.WELCOME);
    });
  }

  static void updateLoading(bool isLoading) {
    CommonUtils.hideShowLoadingIndicator(
        context: Get.context!, isShow: isLoading);
  }

  ///Open phone application in user's device with [phone]
  static void openPhoneApplication(String phone) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phone,
    );

    if (await urlLauncher.canLaunchUrl(launchUri)) {
      await urlLauncher.launchUrl(launchUri);
    } else {
      showErrorSnackBar(message: 'Could not open phone');
    }
  }

  ///Open message application in user's device with [phone]
  static void openMessageApplication(String phone) async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: phone,
    );

    if (await urlLauncher.canLaunchUrl(launchUri)) {
      await urlLauncher.launchUrl(launchUri);
    } else {
      showErrorSnackBar(message: 'Could not open message app');
    }
  }

  ///Open email application in user's device with [toEmail]
  static void openEmailApplication(String toEmail) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: toEmail,
    );

    if (await urlLauncher.canLaunchUrl(launchUri)) {
      await urlLauncher.launchUrl(launchUri);
    } else {
      showErrorSnackBar(message: 'Could not email application');
    }
  }

  /// Open website link to specific browser.
  static void openLinkInBrowser(String websiteUrl) async {
    final Uri launchUri = Uri.parse(Uri.encodeFull(websiteUrl));

    if (await urlLauncher.canLaunchUrl(launchUri)) {
      await urlLauncher.launchUrl(launchUri);
    } else {
      showErrorSnackBar(message: 'Unable to launch browser!');
    }
  }

  /// Return string with formatted date from time
  static String getFormattedDate(String date) {
    if (date.isNotEmpty) {
      DateTime now = DateTime.parse(date);
      String dayFormatted = DateFormat('dd').format(now);
      String strDay = 'th';
      if (dayFormatted == "01") {
        strDay = "${dayFormatted}st";
      } else if (dayFormatted == "02") {
        strDay = "${dayFormatted}nd";
      } else if (dayFormatted == "03") {
        strDay = "${dayFormatted}rd";
      } else {
        strDay = "${dayFormatted}th";
      }
      final formattedDate = DateFormat('MMM yyyy').format(now);
      return "${strDay.replaceAll(RegExp(r'^0+(?=.)'), '')}, $formattedDate";
    } else {
      return "";
    }
  }

  /// Return string with formatted date from time
  static String ddmmmyyyyDate(String date) {
    if (date.isNotEmpty) {
      var currentTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date, true);
      return DateFormat('dd/MM/yyyy').format(currentTime);
    } else {
      return "";
    }
  }

  /// Return string with formatted date from time
  static String ddmmmyyyyDateWithTimezone(String date) {
    if (date.isNotEmpty) {
      var currentTime = DateFormat("yyyy-MM-ddTHH:mm:sssZ").parse(date, true);
      return DateFormat('dd MMMM yyyy').format(currentTime);
    } else {
      return "";
    }
  }

  /// Return string with formatted date from time
  static String ddmmmyyyyDateWithTimezone2(String date) {
    if (date.isNotEmpty) {
      var currentTime = DateFormat("yyyy-MM-ddTHH:mm:sssZ").parse(date, true);
      return DateFormat('dd/MM/yyyy').format(currentTime);
    } else {
      return "";
    }
  }

  /// Return string with formatted date from time
  static String yyyyMMddTHHmmsssZDateWithTimezone(String date) {
    if (date.isNotEmpty) {
      var currentTime = DateFormat("dd/MM/yyyy").parse(date, true);
      return DateFormat('yyyy-MM-ddTHH:mm:sssZ').format(currentTime);
    } else {
      return "";
    }
  }

  /// Return string with formatted date from time
  static String hhmmaDate(String date) {
    var currentTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date, true);
    if (date.isNotEmpty) {
      return DateFormat('hh:mm: aa').format(currentTime);
    } else {
      return "";
    }
  }

  /// Return string with formatted date from time
  static String yyyymmddDate(String date,{bool isUTC=true}) {
    var currentTime = DateFormat("dd/MM/yyyy").parse(date, isUTC);
    if (date.isNotEmpty) {
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(currentTime);
    } else {
      return "";
    }
  }

  /// Convert timestamp to HH:mm aa time.
  static String convertToHHMM(String time) {
    var currentTime = DateFormat("HH:mm aa").parse(time, true);
    if (time.isNotEmpty) {
      return DateFormat('HH:mm').format(currentTime);
    } else {
      return "";
    }
  }

  /// Convert timestamp to HH:mm aa time.
  static String convertToHHMM2(String time) {
    var currentTime = DateFormat("HH:mm:SS").parse(time);
    if (time.isNotEmpty) {
      return DateFormat('HH:mm aa').format(currentTime);
    } else {
      return "";
    }
  }

  /// Convert timestamp to HH:mm aa time.
  static String convertPickedTimeToHour(String time) {
    var currentTime = DateFormat("HH:mm:SS").parse(time);
    if (time.isNotEmpty) {
      return DateFormat('hh:mm a').format(currentTime);
    } else {
      return "";
    }
  }

  /// Convert timestamp to HH:mm aa time.
  static String convertToUserReadableTime(String date) {
    var currentTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date, true);
    if (date.isNotEmpty) {
      return DateFormat('HH:mm aa').format(currentTime);
    } else {
      return "";
    }
  }

  /// Convert timestamp to HH:mm aa time.
  static String convertDateAndTimeToTimestamp(String date, String time) {
    var currentTime =
        DateFormat("dd/MM/yyyy-HH:mm aa").parse("$date-$time", true);
    if (date.isNotEmpty) {
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(currentTime);
    } else {
      return "";
    }
  }

  /// Convert timestamp to dd/MM/yyyy date.
  static String convertToUserReadableDate(String date) {
    var currentTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date, true);
    if (date.isNotEmpty) {
      return DateFormat('dd/MM/yyyy').format(currentTime);
    } else {
      return "";
    }
  }

  /// Convert timestamp to dd/MM/yyyy date.
  static String convertToUserReadableDateWithTimeZone(String date, {bool isUTC=true}) {
    var currentTime =
        DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").parse(date, isUTC);
    if (date.isNotEmpty) {
      return DateFormat('dd/MM/yyyy').format(currentTime);
    } else {
      return "";
    }
  }

  /// Return formated string from date and time filter
  static String getDateDifferenceFromNow(String date) {
    var currentTime = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(date, true);
    Duration diff = DateTime.now().difference(currentTime);
    if (diff.inDays > 0) {
      return diff.inDays < 30
          ? "${diff.inDays} days ago"
          : getFormattedDate(date);
    }

    if (diff.inHours > 0) {
      return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
    }
    if (diff.inMinutes > 0) {
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
    }
    return "Just now";
  }

  /// Returns remaining days from today [date].
  static int getRemainingDays(String date) {
    var tillTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date, true);
    final currentTime = DateTime.now();
    return tillTime.difference(currentTime).inDays;
  }

  /// Returns remaining days from today [date].
  static int getRemainingDays1(String date) {
    var tillTime = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").parse(date, true);
    final currentTime = DateTime.now();
    return tillTime.difference(currentTime).inDays;
  }

  /// Returns remaining days from today [date].
  static String getRemainingDaysInWord(String date, {bool isUTC = false}) {
    if (date.isEmpty) {
      return '';
    }
    final remainingDays = Jiffy.parse(date, isUtc: isUTC).fromNow();
    return remainingDays.replaceAll('a ', '1 ');
  }

  ///Convert number to words
  static String numberToWordsWithZero(num, {bool isFromSlider = false}) {
    RegExp regex = RegExp(r'([.])(?!.*\d)');
    if (num > 999 && num < 99999) {
      return "${((num / 1000).toStringAsFixed(1)).replaceAll(regex, '')}K";
    } else if (num > 99999 && num < 999999) {
      return "${((num / 1000).toStringAsFixed(1)).replaceAll(regex, '')}K";
    } else if (num > 999999 && num < 999999999) {
      return "${((num / 1000000).toStringAsFixed(1)).replaceAll(regex, '')}M";
    } else if (num > 999999999) {
      return "${((num / 1000000000).toStringAsFixed(1)).replaceAll(regex, '')}B";
    } else {
      return num.toString().replaceAll(regex, '');
    }
  }

  /// Share post to other applications.
  static void sharePostToOtherApps(PostModel postModel) async {
    String text = '';
    if (postModel.viewType == PostViewType.openPosition) {
      text =
          '*Open Position Required for ${postModel.clubName}*\n\n${postModel.positionName} \n\nAge: ${postModel.age}\nGender: ${postModel.gender}\nClub\'s Location: ${postModel.location}\n'
          'Level: ${postModel.level}\nRequired skills: ${postModel.skill}';
    } else {
      text =
          '${postModel.postDescription}${(postModel.postImage ?? []).isNotEmpty ? '\n\n ${postModel.postImage?.first.image}' : ""}';
    }

    await Share.share(
      text,
      subject: postModel.clubName,
    );
  }

  /// Return user password
  String getUserPassword() => '${GetIt.I<PreferenceManager>().userId}@2023';

  static String getDateFromTimeStamp(int messageTime) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(messageTime);
    final _dayDifference = calculateDifference(dateTime);
    if (_dayDifference == 0) {
      return "Today";
    }
    if (_dayDifference == -1) {
      return "Yesterday";
    }
    // if (_dayDifference < -1) {
    //   return DateFormat('dd/MM/yy').format(dateTime);
    // }
    return getRemainingDaysInWord(dateTime.toString());
  }

  /// Returns the difference (in full days) between the provided date and today.
  static int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  String returnErrorListFromObj(dynamic value) {
    final list = ((value as List).map((item) => item as String?).toList());
    return list.first ?? " ";
  }

  /// Returns [PostModel] for post.
  PostModel getPostModelForPost(PostListResponseData postElement) {
    return PostModel(
        index: postElement.id,
        postDescription: postElement.otherDetails,
        postDate: postElement.createdAt,
        clubName: postElement.username ?? postElement.userDetails?.name ?? "",
        clubLogo: postElement.profileImage ??
            postElement.userDetails?.profileImage ??
            "",
        clubId: postElement.userId ?? postElement.userDetails?.id,
        postImage: postElement.postImages,
        time: postElement.createdAt);
  }

  /// Returns [PostModel] for open Position.
  PostModel getPostModelForOpenPosition(PostListResponseData postElement) {
    return PostModel.forOpenPosition(
      positionName: postElement.title,
      age: postElement.age ?? "",
      index: postElement.id,
      gender: postElement.gender ?? "male",
      location: postElement.location,
      references: postElement.references ?? "",
      postDate: postElement.createdAt,
      skill: postElement.skill ?? "",
      level: postElement.level ?? "",
      time: postElement.createdAt,
      clubName: postElement.username ?? postElement.userDetails?.name ?? "",
      clubLogo: postElement.profileImage ??
          postElement.userDetails?.profileImage ??
          "",
      postDescription: postElement.otherDetails,
      clubId: postElement.userId ?? postElement.userDetails?.id,
    );
  }

  /// Returns [PostModel] for event.
  PostModel getPostModelForEvent(PostListResponseData postElement) {
    return PostModel.forEvent(
        index: postElement.id,
        title: postElement.title,
        location: postElement.location,
        leagueName: postElement.highlights,
        postDescription: postElement.otherDetails,
        time: postElement.createdAt,
        eventTime: postElement.selectTime,
        eventImage: postElement.image,
        eventDate: postElement.selectDate,
        postDate: postElement.createdAt,
        clubName: postElement.username ?? postElement.userDetails?.name ?? "",
        clubLogo: postElement.profileImage ??
            postElement.userDetails?.profileImage ??
            "",
        clubId: postElement.userId ?? postElement.userDetails?.id,
        teamA: postElement.participantsA ?? "",
        teamB: postElement.participantsB ?? "",
        eventType: postElement.typeOfEvent ?? "");
  }

  /// Returns [PostModel] for result.
  PostModel getPostModelForResult(PostListResponseData postElement) {
    return PostModel.forResult(
      index: postElement.id,
      title: postElement.title,
      location: postElement.location,
      leagueName: postElement.highlights,
      postDate: postElement.selectDate,
      time: postElement.createdAt,
      resultImage: postElement.image,
      eventDate: postElement.selectDate,
      clubName: postElement.username ?? postElement.userDetails?.name ?? "",
      clubLogo: postElement.profileImage ??
          postElement.userDetails?.profileImage ??
          "",
      postDescription: postElement.otherDetails,
      clubId: postElement.userId ?? postElement.userDetails?.id,
      teamA: postElement.participantsA ?? "",
      teamB: postElement.participantsB ?? "",
      score: (postElement.score ?? 0).toString(),
      highlight: postElement.highlights ?? "",
      otherDetails: postElement.otherDetails ?? "",
    );
  }

  static int getRandom({int min = 3, int max = 8}) {
    return min + Random().nextInt(max - min);
  }

  static String? convertUrlToId(String url, {bool trimWhitespaces = true}) {
    assert(url.isNotEmpty ?? false, 'Url cannot be empty');
    if (!url.contains("http") && (url.length == 11)) return url;
    if (trimWhitespaces) url = url.trim();

    for (var exp in [
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
    ]) {
      Match? match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) return match.group(1);
    }
    return null;
  }

  static String getYoutubeVideoThumbnail(String url) {
    if (url.isEmpty) {
      return '';
    }

    final youtubeId = convertUrlToId(url);
    if (youtubeId == null) {
      return '';
    }
    return 'https://img.youtube.com/vi/$youtubeId/0.jpg';
  }
}
