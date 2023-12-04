import 'package:flutter/material.dart';
import 'package:game_on_flutter/values/app_images.dart';

import '../../infrastructure/model/subscription/payment_method_model.dart';
import '../../values/app_colors.dart';
import '../../values/app_values.dart';
import '../app_widgets/app_checkbox_widget.dart';

class PaymentMethodSelectionTileWidget extends StatelessWidget {
  PaymentMethodModel model;
  bool isSelected;
  int index;
  Function(PaymentMethodModel model, int index) onSelectTile;

  PaymentMethodSelectionTileWidget(
      {required this.model,
      required this.isSelected,
      required this.index,
      required this.onSelectTile,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    const paymentCardHeight = 40.0;
    const paymentCardWidth = 63.0;
    return ListTile(
      minVerticalPadding: 0,
      contentPadding: const EdgeInsets.symmetric(
          vertical: AppValues.padding_4, horizontal: AppValues.mediumPadding),
      shape: RoundedRectangleBorder(
          side: BorderSide(
              color: model.isSelected
                  ? AppColors.appWhiteButtonColor
                  : Colors.transparent,
              width: 1),
          borderRadius: BorderRadius.circular(AppValues.roundedButtonRadius)),
      tileColor: model.isSelected
          ? AppColors.appWhiteButtonColor.withOpacity(0.2)
          : AppColors.appWhiteButtonColor.withOpacity(0.1),
      onTap: () => onSelectTile(model, index),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            model.cardCategory ?? "",
            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: AppValues.margin_4,
          ),
          Text(
            formatNumber(model.cardNumber),
            style: textTheme.bodySmall
                ?.copyWith(color: AppColors.textColorDarkGray),
          ),
        ],
      ),
      leading: Image.asset(
        AppImages.paymentCardImage,
        height: paymentCardHeight,
        width: paymentCardWidth,
      ),
      trailing: AppCheckboxWidget(
        isSelected: model.isSelected,
        onSelected: (bool isSelected) {
          onSelectTile(model, index);
        },
      ),
    );
  }

  /// Return formatted string.
  String formatNumber(String value) {
    try {
      final split = value.substring(value.length - 4, value.length);
      if (value.isNotEmpty) {
        return "***** ***** **** $split";
      }
      return '';
    } catch (ex) {
      return '';
    }
  }
}
