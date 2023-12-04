import 'package:flutter/material.dart';

import '../../../../../../values/app_colors.dart';
import '../../../../../../values/app_values.dart';
import '../../../../../app_widgets/app_checkbox_widget.dart';
import '../../../../../app_widgets/app_shimmer.dart';

class SportTypeShimmerWidget extends StatelessWidget {
  const SportTypeShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.separated(
          padding: const EdgeInsets.only(top: AppValues.height_20),
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, index) => const SportTypeShimmerRow(),
          shrinkWrap: true,
          separatorBuilder: (_, index) => const Divider(
                height: AppValues.height_16,
                color: Colors.transparent,
              ),
          itemCount: 10),
    );
  }
}

class SportTypeShimmerRow extends StatelessWidget {
  const SportTypeShimmerRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 0,
      contentPadding: const EdgeInsets.symmetric(
          vertical: AppValues.padding_4, horizontal: AppValues.mediumPadding),
      shape: RoundedRectangleBorder(
          side: BorderSide(
              color: AppColors.appWhiteButtonColor.withOpacity(0.1), width: 1),
          borderRadius: BorderRadius.circular(AppValues.roundedButtonRadius)),
      tileColor: AppColors.appWhiteButtonColorDisable.withOpacity(0.2),
      title: Container(
        height: AppValues.headingTextHeight,
        width: double.infinity,
        margin: const EdgeInsets.only(right: 50),
        decoration: BoxDecoration(
          color: AppColors.textColorDarkGray.withOpacity(0.15),
        ),
      ),
      leading: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: AppColors.textColorDarkGray.withOpacity(0.15),
          borderRadius: BorderRadius.circular(AppValues.smallRadius),
        ),
      ),
      trailing: AppCheckboxWidget(
        isSelected: false,
        onSelected: (bool isSelected) {},
      ),
    );
  }
}
