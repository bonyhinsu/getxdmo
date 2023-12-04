import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../values/app_colors.dart';
import '../../values/app_icons.dart';
import '../../values/app_values.dart';

class BaseBottomsheet extends StatelessWidget {
  String title;
  Widget child;
  bool skipHorizontalPadding;

  BaseBottomsheet(
      {required this.child,
      required this.title,
      this.skipHorizontalPadding = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const circularRadius = Radius.circular(AppValues.bottomSheetRadius);
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: circularRadius, topRight: circularRadius),
              color: AppColors.bottomSheetBackground),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppValues.margin_30),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 18.0, bottom: 15.0),
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: textTheme.headlineMedium,
                      ),
                    ),
                  ),
                ),
                Positioned(
                    right: 6,
                    top: 0,
                    bottom: 0,
                    child: IconButton(
                        onPressed: () => Get.back(),
                        icon: SvgPicture.asset(
                          AppIcons.iconClose,
                          height: 20,
                          width: 20,
                        )))
              ],
            ),
            buildDivider,
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: skipHorizontalPadding ? 0 : AppValues.screenMargin),
              child: child,
            ),
          ]),
        ),
      ),
    );
  }

  /// Build divider widget
  Widget get buildDivider => const Divider(
        height: 1,
        color: AppColors.appWhiteButtonColorDisable,
      );
}
