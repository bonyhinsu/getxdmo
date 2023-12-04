import 'package:flutter/material.dart';

import '../../../../../values/app_colors.dart';
import '../../../../../values/app_values.dart';
import '../../../../app_widgets/app_shimmer.dart';

class SubscriptionTransactionShimmerWidget extends StatelessWidget {
  const SubscriptionTransactionShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, index) => const SingleSubcriptionTransactionWidget(),
          shrinkWrap: true,
          separatorBuilder: (_, ctx) => Container(
            height: AppValues.margin_10,
          ),
          itemCount: 15),
    );
  }
}
class SingleSubcriptionTransactionWidget extends StatelessWidget {
  const SingleSubcriptionTransactionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: 90,
                    color:AppColors.textColorDarkGray.withOpacity(0.3),
                  ),
                  const SizedBox(height: AppValues.height_4,),
                  Container(
                    height: 16,
                    width: 150,
                    color: AppColors.textColorDarkGray.withOpacity(0.3),
                  )
                ],
              ),
            ),
            Container(
              height: 20,
              width: 60,
              color: AppColors.textColorDarkGray.withOpacity(0.3),
            ),
          ],
        ),
        const SizedBox(height: AppValues.height_8,),
        divider
      ],
    );
  }
  /// section divider
  Widget get divider => Divider(
    height: 1,
    color: AppColors.textColorSecondary.withOpacity(0.8),
  );

}
