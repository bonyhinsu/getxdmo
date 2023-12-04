import 'package:game_on_flutter/values/app_values.dart';
import 'package:get/get.dart';

mixin FormValidationMixin {
  /// Checks and return true if provided text is phone number email.
  ///
  /// required [inputValue]
  bool validNumberField(String inputValue) {
    return GetUtils.isNumericOnly(inputValue) &&
        GetUtils.isLengthBetween(inputValue, AppValues.phoneMinLength, AppValues.phoneMaxLength);
  }

  /// Checks and return true if provided text is not empty.
  ///
  /// required [inputValue]
  bool validTextField(String inputValue) {
    return inputValue.isNotEmpty;
  }

  /// Checks and return true if provided text is valid email.
  ///
  /// the email must be match with regex in order to return true.
  ///
  /// required [inputValue]
  bool validEmail(String inputValue) {
    const String emailPattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(emailPattern);
    return regExp.hasMatch(inputValue);
  }

  /// Check and return true if password is valid
  ///
  /// the password must be match with regex in order to return true.
  bool validPassword(String inputValue) {
    const String passwordPattern =
        '^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!.@#\$&*%~;:+?=/`_^()-]).{8,}\$';

    RegExp regExp = RegExp(passwordPattern);
    return regExp.hasMatch(inputValue);
  }
}
