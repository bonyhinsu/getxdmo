import 'package:flutter/cupertino.dart';

mixin UserFeatureMixin {
  void removeFocus(BuildContext context) =>
      FocusScope.of(context).requestFocus(FocusNode());

  bool isKeyboardHidden(BuildContext context) =>
      MediaQuery.of(context).viewInsets.bottom == 0.0;
}
