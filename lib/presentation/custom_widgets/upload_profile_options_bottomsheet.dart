import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:game_on_flutter/values/app_icons.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:game_on_flutter/values/app_values.dart';
import 'package:get/get.dart';

import '../../values/app_colors.dart';

class UploadProfileOptionsBottomSheet extends StatelessWidget {
  Function()? onRemove;
  Function()? onGallery;
  Function()? onCameraTap;
  bool isProfileAvailable;
  bool isProfileSelected;

  UploadProfileOptionsBottomSheet(
      {this.onRemove,
      this.onGallery,
      this.onCameraTap,
      this.isProfileAvailable = false,
      this.isProfileSelected = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    const circularRadius = Radius.circular(30);
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: circularRadius, topRight: circularRadius),
            color: AppColors.bottomSheetBackground),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18.0, bottom: 15.0),
                    child: Text(
                      AppString.selectImageSource,
                      style: textTheme.headlineMedium,
                    ),
                  ),
                ),
                Positioned(
                    right: 10,
                    top: 0,
                    bottom: 0,
                    child: IconButton(
                        onPressed: () => Get.back(),
                        icon: SvgPicture.asset(AppIcons.iconClose)))
              ],
            ),
            Divider(
              height: 1,
              color: Colors.white.withOpacity(0.1),
            ),
            Wrap(
              children: <Widget>[
                ListTile(
                  horizontalTitleGap: 0,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppValues.height_24,
                      vertical: AppValues.height_4),
                  title: Text(
                    AppString.chooseFromGallery,
                    style: themeData.textTheme.labelMedium,
                  ),
                  onTap: () {
                    Get.back(result: 1);
                    if (onGallery != null) onGallery!();
                  },
                ),
                Divider(
                  height: 1,
                  color: Colors.white.withOpacity(0.1),
                ),
                ListTile(
                  horizontalTitleGap: 0,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppValues.height_24,
                      vertical: AppValues.height_4),
                  title: Text(
                    AppString.captureUsingCamera,
                    style: themeData.textTheme.labelMedium,
                  ),
                  onTap: () {
                    Get.back(result: 2);
                    if (onCameraTap != null) onCameraTap!();
                  },
                ),
                Visibility(
                    visible: isProfileAvailable,
                    child: const Divider(
                      height: 1,
                    )),
                Visibility(
                  visible: isProfileAvailable,
                  child: ListTile(
                    horizontalTitleGap: 0,
                    leading: const Icon(
                      Icons.close,
                      color: AppColors.inputFieldBorderColor,
                    ),
                    title: Text(
                      isProfileSelected
                          ? AppString.removeSelectedProfile
                          : AppString.remove,
                      style: themeData.textTheme.headline1!
                          .copyWith(fontWeight: FontWeight.w400),
                    ),
                    onTap: () {
                      Get.back(result: 3);
                      if (onRemove != null) onRemove!();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
