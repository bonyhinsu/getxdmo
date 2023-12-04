import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_button_mixin.dart';
import 'package:get/get.dart';

import '../../../../../values/app_banner.dart';
import '../../../../../values/app_colors.dart';
import '../../../../../values/app_string.dart';
import '../../../../../values/app_values.dart';
import '../../../../app_widgets/base_bottomsheet.dart';

class PaymentConfirmationBottomSheet extends StatelessWidget
    with AppButtonMixin {
  Function() onDone;
  PaymentConfirmationBottomSheet({required this.onDone,Key? key}) : super(key: key);

  late TextTheme textTheme;
  late BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    textTheme = Theme.of(context).textTheme;
    return BaseBottomsheet(
        skipHorizontalPadding: true,
        title: AppString.orderSummery,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppValues.size_30,),
            buildPaymentMethodBanner(),
            const SizedBox(height: AppValues.size_30,),
            buildPaymentThankYouText(),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: AppValues.margin_8,
                  horizontal: AppValues.screenMargin),
              child: appWhiteButton(
                  title: AppString.strDone,
                  onClick: () {
                    Get.back();
                    onDone();
                  }),
            ),
            const SizedBox(
              height: AppValues.margin_8,
            )
          ],
        ));
  }

  /// Build payment method banner.
  Widget buildPaymentMethodBanner() {
    return SizedBox(
        width: double.infinity,
        height: AppValues.paymentMethodBannerHeight,
        child: SvgPicture.asset(AppBanner.doneBanner));
  }

  /// Build payment thank you text.
  Widget buildPaymentThankYouText() => Padding(
        padding: const EdgeInsets.symmetric(
            vertical: AppValues.margin_18, horizontal: AppValues.screenMargin),
        child: Text(
          AppString.paymentThankYouMessage,
          textAlign: TextAlign.center,
          style: textTheme.labelMedium
              ?.copyWith(color: AppColors.textColorSecondary),
        ),
      );
}
