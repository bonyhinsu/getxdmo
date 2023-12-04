import 'package:flutter/material.dart';
import 'package:game_on_flutter/values/app_colors.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:get/get.dart';

import '../../values/app_values.dart';

class AppDialogWidget extends StatelessWidget {
  String dialogText;
  Function onDone;
  bool enableCancelWidget;

  late TextTheme textTheme;

  AppDialogWidget(
      {required this.dialogText,
      required this.onDone,
      this.enableCancelWidget = true,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                color: AppColors.bottomSheetBackground,
                borderRadius:
                    BorderRadius.circular(AppValues.roundedButtonRadius)),
            padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 40),
            margin: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    dialogText,
                    style: textTheme.labelMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: AppValues.margin_20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (enableCancelWidget)
                      buildCancelButton(),
                    buildConfirmButton()
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build cancel button.
  Widget buildCancelButton() {
    return InkWell(
      onTap: () => Get.back(),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppValues.extraLargeRadius, vertical: AppValues.smallMargin),
        decoration: BoxDecoration(
            color: AppColors.appCancelButtonColor,
            borderRadius: BorderRadius.circular(AppValues.smallRadius)),
        child: Text(
          AppString.strNo,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  /// Build confirmation button.
  Widget buildConfirmButton() {
    return InkWell(
      onTap: () {
        Get.back();
        onDone();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppValues.extraLargeRadius, vertical: AppValues.smallMargin),
        decoration: BoxDecoration(
            color: AppColors.appRedButtonColorDisable.withOpacity(0.50),
            borderRadius: BorderRadius.circular(AppValues.smallRadius)),
        child: Text(
          AppString.strYes,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
