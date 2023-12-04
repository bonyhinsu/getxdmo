import 'package:flutter/material.dart';

abstract class AppColors {
  ///----------------- Theme Colors ----------------------
  static const MaterialColor colorPrimarySwatch = Colors.grey;
  static const Color splashProgressColor = Color(0xFFFCFCFC);
  static const Color pageBackground = Color(0xFF0C0B0B);
  static const Color appBarIconColor = Color(0xFFFFFFFF);
  static const Color placeholderBackground = Color(0xFFE9E9E9);

  ///----------------- App Main Colors ----------------------
  static const Color colorPrimary = Color(0x00525252);
  static const Color errorColor = Color(0xFFE74646);

  ///----------------- App Button colors ----------------------
  static const Color appRedButtonColor = Color(0xFFE74646);
  static const Color appRedButtonColorDisable = Color(0x99E74646);
  static const Color appRedButtonColorDisable2 = Color(0x996E1A1A);
  static const Color appRedButtonTextColor = Color(0xFFFCFCFC);
  static const Color appWhiteButtonColor = Color(0xFFFCFCFC);
  static const Color appWhiteButtonColorDisable = Color(0xFF5F5F5F);
  static const Color appWhiteButtonTextColor = Color(0xFF191919);
  static const Color appCancelButtonColor = Color(0xFF908F8F);

  ///---------------------- Label colors ----------------------
  static const Color textColorPrimary = Color(0xFFFFFFFF);
  static const Color textColorSecondary = Color(0xFFFCFCFC);
  static const Color textColorTernary = Color(0xFFC5C5C5);
  static const Color switchColorTernary = Color(0x70C5C5C5);
  static const Color textColorDarkGray = Color(0xFF908F8F);
  static const Color textColorWhite = Color(0xFFFFFFFF);

  static const Color textColorWhiteDescription = Color(0xFFFFFFFF);

  ///---------------------- Choice colors ----------------------
  static const Color choiceUnselectedColor = Color(0xFF414143);
  static const Color choiceSelectedColor = Color(0xFF3F2E30);

  ///---------------------- TextField colors ----------------------
  static const Color textFieldBackgroundColor = Color(0x1AFCFCFC);
  static const Color textPlaceholderColor = Color(0x1AFCFCFC);
  static const Color inputFieldBorderColor = Color(0xFF939699);
  static const Color textColorLightTheme = Color(0x80FCFCFC);
  static const Color textSearch = Color(0x50FCFCFC);

  ///---------------------- BottomSheet background color ----------------------
  static const Color bottomSheetBackground = AppColors.pageBackground;
  static const Color bottomBarBackground = Color(0xFF2C2C2E);
  static const Color bottomSheetBackgroundOld = Color(0xFF2C2C2E);
  static const Color fabButtonBackgroundChange = Color(0xFF2C2C2E);
  static const Color appTileBackground = Color(0xFF242323);
  static const Color bottomSheetInputBackground = Color(0xFF4F4E4E);
  static const Color bottomSheetTextColor = textColorPrimary;
  static  Color bottomSheetBgBlurColor = AppColors.pageBackground.withOpacity(0.6);
}
