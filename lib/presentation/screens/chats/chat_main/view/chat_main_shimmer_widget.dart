import 'package:flutter/material.dart';

import '../../../../../values/app_colors.dart';
import '../../../../../values/app_values.dart';
import '../../../../app_widgets/app_shimmer.dart';

class ChatMainShimmerWidget extends StatelessWidget {
  const ChatMainShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, index) => const ChatMainShimmerTileWidget(),
          shrinkWrap: true,
          separatorBuilder: (_, ctx) => Container(
                height: AppValues.margin_10,
              ),
          itemCount: 24),
    );
  }
}

class ChatMainShimmerTileWidget extends StatelessWidget {
  const ChatMainShimmerTileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.textColorSecondary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppValues.smallRadius)),
      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                color: AppColors.textColorSecondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(AppValues.fullRadius)),
          ),
          const SizedBox(
            width: 18,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: AppValues.height_16,
                  width: 150,
                  color: AppColors.textColorSecondary.withOpacity(0.3),
                ),
                const SizedBox(
                  height: AppValues.height_16,
                ),
                Container(
                  height: AppValues.height_12,
                  width: 100,
                  color: AppColors.textColorSecondary.withOpacity(0.3),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: AppValues.height_12,
          ),
          Container(
            height: AppValues.height_12,
            width: 50,
            decoration: BoxDecoration(
                color: AppColors.textColorSecondary.withOpacity(0.3)),
          ),
        ],
      ),
    );
  }
}
