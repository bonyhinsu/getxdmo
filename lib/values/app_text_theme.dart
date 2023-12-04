import 'package:flutter/material.dart';
import 'package:game_on_flutter/values/app_colors.dart';
import 'package:game_on_flutter/values/app_font_size.dart';

textThemeLight() {
  return const TextTheme(
    bodyMedium: TextStyle(
        fontFamily: FontConstants.poppins,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textColorPrimary),
    bodySmall: TextStyle(
        fontSize: 10,
        fontFamily: FontConstants.poppins,
        color: AppColors.textColorPrimary),
    bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: FontConstants.poppins,
        color: AppColors.textColorSecondary),
    labelMedium: TextStyle(
        fontSize: 15,
        fontFamily: FontConstants.poppins,
        fontWeight: FontWeight.w400,
        color: AppColors.textColorPrimary),
    displayLarge: TextStyle(
        fontSize: 14,
        fontFamily: FontConstants.poppins,
        color: AppColors.textColorSecondary,
        fontWeight: FontWeight.w500),
    displaySmall: TextStyle(
        fontSize: 12,
        fontFamily: FontConstants.poppins,
        color: AppColors.textColorSecondary,
        fontWeight: FontWeight.w400),
    headlineLarge: TextStyle(
      fontSize: 20,
      fontFamily: FontConstants.poppins,
      color: AppColors.textColorSecondary,
      fontWeight: FontWeight.w700,
    ),
    headlineMedium: TextStyle(
      fontSize: 18,
      fontFamily: FontConstants.poppins,
      color: AppColors.textColorWhite,
      fontWeight: FontWeight.w500,
    ),
    headlineSmall: TextStyle(
      fontSize: 12,
      fontFamily: FontConstants.poppins,
      color: AppColors.textColorTernary,
      fontWeight: FontWeight.w400,
    ),

  );
}
