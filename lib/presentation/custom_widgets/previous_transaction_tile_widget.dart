import 'package:flutter/material.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:game_on_flutter/values/app_values.dart';
import 'package:game_on_flutter/values/common_utils.dart';

import '../../infrastructure/model/subscription/user_previous_subscription_model.dart';
import '../../values/app_colors.dart';

class PreviousTransactionTileWidget extends StatelessWidget {

  UserPreviousSubscriptionModel model;
  PreviousTransactionTileWidget({required this.model,Key? key}) : super(key: key);

  late TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    final subscriptionDate = model.transactionDate;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppString.transaction,
                    textAlign: TextAlign.start,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w500,fontSize: 13
                        ),
                  ),
                  const SizedBox(height: AppValues.height_2,),
                  Text(
                    CommonUtils.ddmmmyyyyDateWithTimezone(subscriptionDate),
                    textAlign: TextAlign.start,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.displaySmall?.copyWith(
                      fontSize: 10,
                        color: AppColors.textColorDarkGray),
                  )
                ],
              ),
            ),
            Text(
              "\$${model.transactionAmount}",
              textAlign: TextAlign.start,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.w600, color: AppColors.textColorDarkGray,fontSize: 13),
            )
          ],
        ),
        const SizedBox(height: AppValues.height_8,),
        divider
      ],
    );
  }
  /// section divider
  Widget get divider => const Divider(
    height: 1,
    color: AppColors.textColorSecondary,
  );

}
