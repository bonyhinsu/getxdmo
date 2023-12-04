import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../values/app_colors.dart';
import '../../values/app_string.dart';
import '../../values/app_values.dart';

class AppDialogWithTitleWidget extends StatelessWidget {
  String dialogText;
  String dialogTitle;
  Function onDone;
  String cancelButtonText;
  String doneButtonText;
  late TextTheme textTheme;

  AppDialogWithTitleWidget(
      {required this.dialogText,
      required this.dialogTitle,
      required this.onDone,
      this.cancelButtonText = AppString.strNo,
      this.doneButtonText = AppString.strYes,
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
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 24),
            margin: const EdgeInsets.symmetric(horizontal: 36.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    dialogTitle,
                    style: textTheme.labelMedium
                        ?.copyWith(fontWeight: FontWeight.bold,fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: AppValues.height_20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    dialogText,
                    style: textTheme.displaySmall?.copyWith(fontSize: 13),
                    textAlign: TextAlign.center,

                  ),
                ),
                const SizedBox(
                  height: AppValues.margin_20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [buildCancelButton(),const SizedBox(width: AppValues.margin_30,), buildConfirmButton()],
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
            horizontal: AppValues.largeMargin,
            vertical: AppValues.smallMargin),
        decoration: BoxDecoration(
            color: AppColors.appCancelButtonColor,
            borderRadius: BorderRadius.circular(AppValues.smallRadius)),
        child: Text(
          cancelButtonText,
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
            horizontal: AppValues.largeMargin,
            vertical: AppValues.smallMargin),
        decoration: BoxDecoration(
            color: AppColors.appRedButtonColor.withOpacity(0.50),
            borderRadius: BorderRadius.circular(AppValues.smallRadius)),
        child: Text(
          doneButtonText,
          style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
