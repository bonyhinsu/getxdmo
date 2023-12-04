import 'package:game_on_flutter/values/app_string.dart';

import 'app_settings_response_model.dart';

class AppFields {
  String _appName = "";
  String _welcomeContent = "";
  String _imagePrefix = "";
  bool _enableChat = true;
  bool _subscriptionExpired = false;

  String get appName => _appName;

  String get welcomeContent => _welcomeContent;

  String get imagePrefix => _imagePrefix;

  bool get enableChat => _enableChat;

  bool get subscriptionExpired => _subscriptionExpired;

  AppFields._();

  static final _instance = AppFields._();

  static AppFields get instance => _instance;

  set setAppName(String value) {
    _appName = value;
  }

  set setWelcomeContent(String value) {
    _welcomeContent = value;
  }

  set setImagePrefix(String value) {
    _imagePrefix = value;
  }

  set enableChat(bool value) {
    _enableChat = value;
  }

  set subscriptionExpired(bool value) {
    _subscriptionExpired = value;
  }

  /// set application data
  void setFieldsData(AppSettingsResponseModelData fields) {
    /// set application welcome message
    if (fields.field == AppFieldsParamConstants.description) {
      setWelcomeContent = fields.value ?? AppString.appTitle;
      return;
    }

    /// set application name
    if (fields.field == AppFieldsParamConstants.title) {
      setAppName = fields.value ?? AppString.appTitle;
      return;
    }

    /// set application name
    if (fields.field == AppFieldsParamConstants.url) {
      setImagePrefix = fields.value ?? '';
      return;
    }
  }
}

class AppFieldsParamConstants {
  static const description = "description";
  static const logo = "logo";
  static const title = "title";
  static const url = "url";
}
