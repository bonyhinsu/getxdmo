import 'package:flutter/material.dart';
import 'package:game_on_flutter/values/app_values.dart';

import '../../values/app_colors.dart';
import '../../values/app_font_size.dart';

mixin AppButtonMixin on Widget {
  /// Build Red Button
  /// required [title] button title.
  /// required [onClick] perform click action.
  Widget appRedButton(
      {required String title,
      bool isValidate = true,
      required Function() onClick}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppValues.roundedButtonRadius),
      child: ElevatedButton(
        onPressed: isValidate
            ? () {
                onClick();
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.appRedButtonColor,
          disabledBackgroundColor: AppColors.appRedButtonColorDisable2,
        ),
        child: SizedBox(
          height: AppValues.appButtonHeight,
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                  color: !isValidate
                      ? AppColors.appRedButtonTextColor.withOpacity(0.7)
                      : AppColors.appRedButtonTextColor,
                  fontSize: 16,
                  fontFamily: FontConstants.poppinsSEMIBOLD,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }

  /// Build Red Button
  /// required [title] button title.
  /// required [onClick] perform click action.
  Widget appWhiteButton(
      {required String title,
      bool isValidate = true,
      bool applyBackgroundToButton = false,
      required Function() onClick}) {
    return Container(
      color: applyBackgroundToButton
          ? AppColors.pageBackground
          : Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppValues.roundedButtonRadius),
        child: ElevatedButton(
          onPressed: isValidate
              ? () {
                  onClick();
                }
              : null,
          style: ElevatedButton.styleFrom(
            disabledBackgroundColor: AppColors.appWhiteButtonColorDisable,
            backgroundColor: isValidate
                ? AppColors.appWhiteButtonColor
                : AppColors.appWhiteButtonColorDisable,
            splashFactory: NoSplash.splashFactory,
          ),
          child: SizedBox(
            height: AppValues.appButtonHeight,
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                    color: AppColors.appWhiteButtonTextColor,
                    fontFamily: FontConstants.poppinsSEMIBOLD,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build Red Button
  /// required [title] button title.
  /// required [onClick] perform click action.
  Widget appGrayButton(
      {required String title,
      required Function() onClick,
      bool disabledButton = false,
      double buttonRadius = AppValues.roundedButtonRadius}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(buttonRadius),
      child: ElevatedButton(
        onPressed: () {
          onClick();
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.textColorSecondary
                .withOpacity(disabledButton ? 0.10 : 0.20),
            splashFactory: NoSplash.splashFactory,
            visualDensity: VisualDensity.comfortable,
            padding: const EdgeInsets.symmetric(
                vertical: AppValues.size_14, horizontal: AppValues.size_15)),
        child: Center(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
                color: disabledButton?AppColors.textColorSecondary.withOpacity(0.5):AppColors.textColorSecondary,
                fontFamily: FontConstants.poppins,
                fontSize: 12,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  /// Build Red Button
  /// required [title] button title.
  /// required [onClick] perform click action.
  Widget appRedSecondaryButton(
      {required String title,
      required Function() onClick,
      double buttonRadius = AppValues.roundedButtonRadius}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(buttonRadius),
      child: ElevatedButton(
        onPressed: () {
          onClick();
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.appRedButtonColor.withOpacity(0.20),
            splashFactory: NoSplash.splashFactory,
            visualDensity: VisualDensity.comfortable,
            padding: const EdgeInsets.symmetric(
                vertical: AppValues.size_14, horizontal: AppValues.size_15)),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
                color: AppColors.appRedButtonColor,
                fontFamily: FontConstants.poppins,
                fontSize: 12,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
