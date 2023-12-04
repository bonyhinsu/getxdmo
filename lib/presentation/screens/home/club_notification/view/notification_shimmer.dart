import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../values/app_colors.dart';
import '../../../../../values/app_icons.dart';
import '../../../../../values/app_values.dart';
import '../../../../app_widgets/app_shimmer.dart';

class NotificationShimmer extends StatelessWidget {
  const NotificationShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, index) => const NotificationSingleTileWidget(),
          shrinkWrap: true,
          separatorBuilder: (_, ctx) => Container(
                height: AppValues.margin_10,
              ),
          itemCount: 10),
    );
  }
}

class NotificationSingleTileWidget extends StatelessWidget {
  const NotificationSingleTileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 0,
      contentPadding: const EdgeInsets.only(
          left: AppValues.mediumPadding,
          right: AppValues.mediumPadding,
          top: AppValues.mediumPadding,
          bottom: AppValues.mediumPadding),
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.transparent, width: 1),
          borderRadius: BorderRadius.circular(AppValues.roundedButtonRadius)),
      tileColor: AppColors.textColorSecondary.withOpacity(0.1),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Visibility(
            visible: false,
            child: Row(children: [
              SvgPicture.asset(AppIcons.dot),
            ]),
          ),
          Row(children: [
            SvgPicture.asset(AppIcons.logoCircle),
          ]),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 16,
                  width: 90,
                  color: AppColors.textColorDarkGray.withOpacity(0.3),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  height: 12,
                  width: 180,
                  color: AppColors.textColorDarkGray.withOpacity(0.3),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  height: 12,
                  width: 100,
                  color: AppColors.textColorDarkGray.withOpacity(0.3),
                ),
              ],
            ),
          ),
          Container(
            height: 8,
            width: 24,
            color: AppColors.textColorDarkGray.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
}
