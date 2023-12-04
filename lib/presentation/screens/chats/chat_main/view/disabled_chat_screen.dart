import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_on_flutter/infrastructure/model/common/app_fields.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_button_mixin.dart';
import 'package:game_on_flutter/values/app_colors.dart';
import 'package:game_on_flutter/values/app_icons.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:game_on_flutter/values/app_values.dart';
import 'package:get/get.dart';

import '../../../../../infrastructure/navigation/routes.dart';

class DisabledChatScreen extends StatelessWidget with AppButtonMixin {
  late TextTheme textTheme;

  DisabledChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return Container(
      color: AppColors.pageBackground,
      child: Padding(
        padding: const EdgeInsets.all(AppValues.screenMargin),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                SvgPicture.asset(
                  AppIcons.chatIcon,
                  height: 70,
                  width: 70,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Message Disabled',
                  style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: AppColors.textColorSecondary),
                ),
              ],
            ),
            Text(
              AppFields.instance.subscriptionExpired
                  ? AppString.messageDisableDueToSubscriptionExpired
                  : (!AppFields.instance.enableChat)
                      ? AppString.messageDisableDueToFreeSubscription
                      : "",
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: AppColors.textColorDarkGray),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: appGrayButton(
                  title: 'Manage Subscription',
                  onClick: () {
                    Get.toNamed(Routes.MANAGE_SUBSCRIPTION);
                  }),
            )
          ],
        ),
      ),
    );
  }
}
