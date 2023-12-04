import 'package:flutter/material.dart';

import '../../../../../values/app_colors.dart';
import '../../../../../values/app_values.dart';
import '../../../../app_widgets/app_shimmer.dart';
import '../../../../app_widgets/app_square_checkbox_widget.dart';

class FavouriteItemShimmerWidget extends StatelessWidget {
  const FavouriteItemShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, index) => const FavouriteListItemShimmer(),
          shrinkWrap: true,
          separatorBuilder: (_, ctx) => Container(
                height: AppValues.margin_10,
              ),
          itemCount: 24),
    );
  }
}

class FavouriteListItemShimmer extends StatelessWidget {
  const FavouriteListItemShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppValues.height_10, vertical: AppValues.height_14),
      decoration: BoxDecoration(
          color: AppColors.textColorSecondary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppValues.smallRadius)),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 90,
                  height: 16,
                  color: Colors.grey.withOpacity(0.3),
                ),
                Container(
                  width: 80,
                  margin: const EdgeInsets.only(left: 12),
                  height: 16,
                  color: Colors.grey.withOpacity(0.3),
                ),
              ],
            ),
          ),
          AppSquareCheckboxWidget(
            isSelected: false,
            onSelected: (bool isSelected) {},
          ),
        ],
      ),
    );
  }
}
