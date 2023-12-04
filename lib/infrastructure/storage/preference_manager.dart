import 'dart:async';
import 'dart:convert';

import 'package:game_on_flutter/infrastructure/storage/preference_constants.dart';
import 'package:get_storage/get_storage.dart';

import '../../values/app_constant.dart';
import '../model/user_info_model.dart';

class PreferenceManager {
  //Singleton instance

  static PreferenceManager instance = PreferenceManager();
  GetStorage? _objStorage;

  Future<void> initPreference() async {
    _objStorage = GetStorage();
    await GetStorage.init();
  }

  ///CLEAR ALL
  void clearAll() {
    _objStorage!.erase();
  }

  bool get isLogin {
    return _objStorage!.read(PreferenceConstants.isLogin) ?? false;
  }

  void setLogin(bool value) =>
      _objStorage!.write(PreferenceConstants.isLogin, value);

  /// Set user type
  ///
  /// There are two types of user type available
  /// 1. club
  /// 2. player
  void setUserType(int value) =>
      _objStorage!.write(PreferenceConstants.userType, value);

  int get getUserType {
    return _objStorage!.read(PreferenceConstants.userType) ??
        AppConstants.userTypeClub;
  }

  /// Return true if user is logged in as club user type.
  bool get isClub => getUserType == AppConstants.userTypeClub;

  // ----- Firebase UUID [String] -----
  void setFirebaseUUID(String uuid) {
    _objStorage!.write(PreferenceConstants.uuid, uuid);
  }

  ///Return UUID
  String get userUUID => _objStorage!.read(PreferenceConstants.uuid) ?? "";

  // ----- Firebase Chat User Id [String] -----
  void setFirebaseChatUserId(String uuid) {
    _objStorage!.write(PreferenceConstants.firebaseChatUserId, uuid);
  }

  ///Return Firebase chat UUID
  String get getFirebaseChatUserId => _objStorage!.read(PreferenceConstants.firebaseChatUserId) ?? "";

  // ----- User Email [String] -----
  void setUserEmail(String userEmail) =>
      _objStorage!.write(PreferenceConstants.userEmail, userEmail);

  String get userEmail =>
      _objStorage!.read(PreferenceConstants.userEmail) ?? "";

  // ----- User Email [String] -----
  void setUserName(String userName) =>
      _objStorage!.write(PreferenceConstants.userName, userName);

  // ----- User Email [String] -----
  void setPrivacyType(String privacyType) =>
      _objStorage!.write(PreferenceConstants.PrivacyType, privacyType);

  String get userName => _objStorage!.read(PreferenceConstants.userName) ?? "";

  String get privacyType =>
      _objStorage!.read(PreferenceConstants.PrivacyType) ?? "";

  // ----- User Email [String] -----
  void setUserProfile(String? userName) => _objStorage!
      .write(PreferenceConstants.userProfilePicture, userName ?? "");

  String get userProfilePicture =>
      _objStorage!.read(PreferenceConstants.userProfilePicture) ?? "";

  // ----- Firebase Token [String] -----
  void setFirebaseToken(String userName) =>
      _objStorage!.write(PreferenceConstants.firebaseToken, userName);

  String get firebaseToken =>
      _objStorage!.read(PreferenceConstants.firebaseToken) ?? "";

  // ----- User Details [UserDetails] -----
  void setUserDetails(UserDetails userDetails) {
    final strUserDetails = json.encode(userDetails);
    _objStorage!.write(PreferenceConstants.userDetails, strUserDetails);
  }

  UserDetails? getUserDetails() {
    String strUserDetails =
        _objStorage!.read(PreferenceConstants.userDetails) ?? "";
    if (strUserDetails.isNotEmpty) {
      return UserDetails.fromJson(json.decode(strUserDetails));
    } else {
      return null;
    }
  }

  // ----- User Id [int] -----
  void setUserId(int userId) =>
      _objStorage!.write(PreferenceConstants.userId, userId);

  int get userId => _objStorage!.read(PreferenceConstants.userId) ?? -1;

  // ----- User Token [int] -----
  void setUserToken(String token) =>
      _objStorage!.write(PreferenceConstants.token, token);

  String get getUserToken => _objStorage!.read(PreferenceConstants.token) ?? '';

  // ----- First time Login [bool] -----
  void setFirstLoggedIn(bool value) =>
      _objStorage!.write(PreferenceConstants.firstTimeLogin, value);

  bool get firstTimeLogin => _objStorage!.read(PreferenceConstants.firstTimeLogin) ?? true;
}
