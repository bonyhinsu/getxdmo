import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../values/app_colors.dart';
import '../../../../../values/app_icons.dart';
import '../../../../../values/app_values.dart';
import '../../../../app_widgets/app_shimmer.dart';

class SubscriptionPlanLoadingShimmer extends StatelessWidget {
  const SubscriptionPlanLoadingShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, index) => const SubscriptionPlanTileShimmer(),
          shrinkWrap: true,
          separatorBuilder: (_, ctx) => Container(
                height: AppValues.margin_10,
              ),
          itemCount: 15),
    );
  }
}

class SubscriptionPlanTileShimmer extends StatelessWidget {
  const SubscriptionPlanTileShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      width: double.infinity,
      padding: const EdgeInsets.all(AppValues.padding_16),
      decoration: BoxDecoration(
        color:AppColors.textColorDarkGray.withOpacity(0.2),
          borderRadius: BorderRadius.circular(AppValues.roundedButtonRadius)),
      child: Row(
        children: [
          Container(
            height: AppValues.headingTextHeight,
            width: 100,
            color:AppColors.textColorDarkGray.withOpacity(0.2),
          ),
          const Spacer(),
          Container(
            height: AppValues.headingTextHeight,
            width: 80,
            color:AppColors.textColorDarkGray.withOpacity(0.2),
          ),
          const SizedBox(width: AppValues.margin_10,),
          SvgPicture.asset(AppIcons.downArrow)
        ],
      ),
    );
  }
}
