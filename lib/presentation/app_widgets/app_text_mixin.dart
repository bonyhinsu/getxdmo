import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';

import '../../values/app_colors.dart';

mixin AppTextMixin {
  /// Build club board member text.
  EasyRichText screenTitle(
          {required TextTheme textTheme,
          required String value,
          bool isPrimaryText = false,
          bool isMandatory = false}) =>

      /// Widget build Text widget
      EasyRichText(
        "$value${isMandatory ? '*' : ''}",
        patternList: [
          EasyRichTextPattern(
            targetString: '(\\*)',
            matchLeftWordBoundary: false,
            style: textTheme.displayLarge?.copyWith(
              color: AppColors.errorColor,
            ),
          ),
        ],
        defaultStyle: textTheme.displayLarge?.copyWith(
          color: isPrimaryText?AppColors.textColorPrimary:AppColors.textColorSecondary.withOpacity(0.8),
        ),
      );
}
