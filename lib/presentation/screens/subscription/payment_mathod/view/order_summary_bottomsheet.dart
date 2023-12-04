import 'package:flutter/material.dart';
import 'package:game_on_flutter/infrastructure/model/subscription/subscription_plan_model.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_button_mixin.dart';
import 'package:game_on_flutter/presentation/app_widgets/base_bottomsheet.dart';
import 'package:game_on_flutter/values/app_colors.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:game_on_flutter/values/app_values.dart';
import 'package:get/get.dart';

class OrderSummeryBottomSheetWidget extends StatelessWidget
    with AppButtonMixin {
  SubscriptionPlanModel subscriptionModel;
  Function() onPayClick;

  OrderSummeryBottomSheetWidget(
      {required this.onPayClick, required this.subscriptionModel, Key? key})
      : super(key: key);

  late TextTheme textTheme;
  late BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    textTheme = Theme.of(context).textTheme;
    final totalSubscriptionAmount =
        num.parse((subscriptionModel.planAmount ?? "0").replaceAll("\$", ''));
    const totalTax = 10.5;
    num totalAmount = totalSubscriptionAmount + totalTax;
    return BaseBottomsheet(
        skipHorizontalPadding: true,
        title: AppString.orderSummery,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildPlanTypeText(),
            buildDivider,
            buildRow(
                title: AppString.strAmount,
                amount: '\$$totalSubscriptionAmount'),
            buildDivider,
            buildRow(title: AppString.strTax, amount: '\$$totalTax'),
            buildDivider,
            buildTotalRow(title: AppString.strTotal, amount: '\$$totalAmount'),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: AppValues.margin_8,
                  horizontal: AppValues.screenMargin),
              child: appWhiteButton(
                  title: AppString.payNow,
                  onClick: () {
                    Get.back();
                    onPayClick();
                  }),
            ),
            const SizedBox(
              height: AppValues.margin_8,
            )
          ],
        ));
  }

  Widget buildPlanTypeText() => Padding(
        padding: const EdgeInsets.symmetric(
            vertical: AppValues.margin_18, horizontal: AppValues.screenMargin),
        child: Text(
          "${subscriptionModel.planTitle} Plan",
          style: textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w500, color: AppColors.textColorDarkGray),
        ),
      );

  Widget get buildDivider => const Divider(
        height: 1,
        color: AppColors.appWhiteButtonColorDisable,
      );

  /// Build row widget.
  Widget buildRow({required String title, required String amount}) => Padding(
        padding: const EdgeInsets.symmetric(
            vertical: AppValues.margin_18, horizontal: AppValues.screenMargin),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColorDarkGray),
            ),
            Text(
              amount,
              style: textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColorDarkGray),
            )
          ],
        ),
      );

  Widget buildTotalRow({required String title, required String amount}) =>
      Padding(
        padding: const EdgeInsets.symmetric(
            vertical: AppValues.margin_18, horizontal: AppValues.screenMargin),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.appRedButtonColor),
            ),
            Text(
              amount,
              style: textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.appRedButtonColor),
            )
          ],
        ),
      );
}
