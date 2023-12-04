import 'package:flutter/material.dart';

import '../../../../../values/app_colors.dart';
import '../../../../../values/app_values.dart';
import '../../../../app_widgets/app_shimmer.dart';

class UserSubscriptionShimmerWidget extends StatelessWidget {
  const UserSubscriptionShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, index) => const UserSubscriptionSingleTileWidget(),
          shrinkWrap: true,
          separatorBuilder: (_, ctx) => Container(
                height: AppValues.margin_10,
              ),
          itemCount: 10),
    );
  }
}

class UserSubscriptionSingleTileWidget extends StatelessWidget {
  const UserSubscriptionSingleTileWidget({Key? key}) : super(key: key);

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
        children: [
          buildSportSquareIcon(),
          const SizedBox(
            width: AppValues.size_15,
          ),
          Expanded(child: buildColumnWidget()),
          const SizedBox(
            width: AppValues.size_15,
          ),
          buildButton()
        ],
      ),
    );
  }

  Widget buildColumnWidget() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(height: 16,width: 100,color: Colors.white.withOpacity(0.5),),
      const SizedBox(
        height: AppValues.height_5,
      ),
      Container(height: 16,width: 100,color: Colors.white.withOpacity(0.5),),
      const SizedBox(
        height: AppValues.height_4,
      ),
      Container(height: 16,width: 100,color: Colors.white.withOpacity(0.5),),
    ],
  );

  /// Build square icon size
  Widget buildSportSquareIcon() => Container(
        height: AppValues.size_70,
        width: AppValues.size_70,
        padding: const EdgeInsets.all(AppValues.iconSize_14),
        decoration: BoxDecoration(
          color: AppColors.appRedButtonColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(AppValues.smallRadius),
        ),
      );

  /// Build subscription action button.
  Widget buildButton() {
    return Container(height: 16,width: 100,color: Colors.white.withOpacity(0.5),);
  }
}
