import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:game_on_flutter/infrastructure/model/common/app_fields.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_button_mixin.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:game_on_flutter/values/common_utils.dart';

import '../../infrastructure/model/subscription/subscription_sport_model.dart';
import '../../values/app_colors.dart';
import '../../values/app_values.dart';

class ManageSubscriptionTileWidget extends StatelessWidget with AppButtonMixin {
  SubscriptionSportModel model;
  int index;
  Function(SubscriptionSportModel model, int index) onUpgrade;
  Function(SubscriptionSportModel model, int index) onRenew;
  Function(SubscriptionSportModel model, int index) onTap;

  ManageSubscriptionTileWidget(
      {required this.model,
      required this.onUpgrade,
      required this.onRenew,
      required this.onTap,
      required this.index,
      Key? key})
      : super(key: key);

  late TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
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
      onTap: () => onTap(model, index),
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
          if (model.isUpgradable || (model.isCancelled && model.canRenew))
            buildButton()
        ],
      ),
    );
  }

  /// Build square icon size
  Widget buildSportSquareIcon() => Container(
      height: AppValues.size_70,
      width: AppValues.size_70,
      padding: const EdgeInsets.all(AppValues.iconSize_14),
      decoration: BoxDecoration(
          color: AppColors.appRedButtonColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(AppValues.smallRadius)),
      child: (model.logoImage ?? "").isNotEmpty
          ? (model.logoImage ?? "").contains('.svg')
              ? SvgPicture.network(
                  '${AppFields.instance.imagePrefix}${model.logoImage ?? ""}')
              : Image.network(
                  '${AppFields.instance.imagePrefix}${model.logoImage ?? ""}')
          : null);

  Widget buildColumnWidget() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSportName,
          const SizedBox(
            height: AppValues.height_5,
          ),
          buildSubscriptionAmountWidget(),
          const SizedBox(
            height: AppValues.height_4,
          ),
          buildSubscriptionDueDate()
        ],
      );

  /// Build sports name widget.
  Text get buildSportName => Text(
        model.sportName,
        textAlign: TextAlign.start,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500),
      );

  /// Build subscription amount widget.
  Widget buildSubscriptionAmountWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "${model.isFreePlan ? "0.00" : model.amount}",
          textAlign: TextAlign.start,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        if (!model.isFreePlan)
          Text(
            "/${model.isYearly ? AppString.strYearly : AppString.strMonthly}",
            textAlign: TextAlign.start,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: textTheme.displaySmall
                ?.copyWith(color: AppColors.textColorDarkGray, fontSize: 10),
          ),
      ],
    );
  }

  /// Build subscription due date button.
  Text buildSubscriptionDueDate() {
    final remainingDays =
        CommonUtils.getRemainingDaysInWord(model.nextRenewalDate);
    return Text(
      model.isFreePlan
          ? AppString.strFree
          : model.isCancelled
              ? cancelledString()
              : "${AppString.strNextPaymentIn}$remainingDays",
      textAlign: TextAlign.start,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w500, color: AppColors.textColorDarkGray),
    );
  }

  String cancelledString() {
    int remainingDaysCount =
        CommonUtils.getRemainingDays1(model.nextRenewalDate);

    final remainingDays =
        CommonUtils.getRemainingDaysInWord(model.nextRenewalDate);
    return remainingDaysCount <= 0
        ? "Expired"
        : remainingDaysCount == 0
            ? 'Expires Today'
            : 'Expires $remainingDays';
  }

  /// Build subscription action button.
  Widget buildButton() {
    return appGrayButton(
        title: model.isUpgradable ? AppString.strUpgrade : AppString.strRenew,
        onClick: () => model.isUpgradable
            ? onUpgrade(model, index)
            : onRenew(model, index));
  }
}
