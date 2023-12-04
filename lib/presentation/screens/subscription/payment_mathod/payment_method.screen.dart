import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:game_on_flutter/values/app_banner.dart';
import 'package:game_on_flutter/values/app_colors.dart';
import 'package:get/get.dart';

import '../../../../infrastructure/navigation/routes.dart';
import '../../../../values/app_string.dart';
import '../../../../values/app_values.dart';
import '../../../app_widgets/app_button_mixin.dart';
import '../../../app_widgets/app_text_mixin.dart';
import '../../../app_widgets/base_view.dart';
import '../../../custom_widgets/payment_method_selection_tile_widget.dart';
import 'controllers/payment_mathod.controller.dart';

class PaymentMethodScreen extends GetView<PaymentMethodController>
    with AppBarMixin, AppButtonMixin, AppTextMixin {
  PaymentMethodScreen({Key? key}) : super(key: key);

  final PaymentMethodController _controller =
      Get.find(tag: Routes.PAYMENT_METHOD);

  late TextTheme textTheme;
  late BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: buildAppBar(
        title: AppString.paymentMethod,
      ),
      body: SafeArea(
        child: Obx(() => buildBody(context)),
      ),
    );
  }

  /// Widget build body.
  Widget buildBody(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppValues.screenMargin),
        child: Column(
          children: [
            Container(
              height: AppValues.screenMargin,
              color: AppColors.pageBackground,
            ),
            buildPaymentMethodBanner(),
            Container(
              height: AppValues.margin_30,
              color: AppColors.pageBackground,
            ),
            Expanded(
                child: Column(
              children: [
                Flexible(child: buildPaymentMethodList()),
                Container(
                  height: AppValues.margin_6,
                  color: AppColors.pageBackground,
                ),
                buildAddCardTextButton()
              ],
            )),
            Container(
              color: AppColors.pageBackground,
              height: AppValues.margin_8,
            ),
            appWhiteButton(title: AppString.strContinue, onClick: () => _controller.viewOrderSummaryBottomSheet()),
            Container(
              height: AppValues.screenMargin,
              color: AppColors.pageBackground,
            ),
          ],
        ),
      );

  /// Build single selection widget.
  Widget buildPaymentMethodList() => ListView.separated(
      separatorBuilder: (_, index) => const Divider(
            height: AppValues.height_16,
            color: Colors.transparent,
          ),
      itemBuilder: (_, index) {
        final obj = _controller.paymentMethodList[index];
        return PaymentMethodSelectionTileWidget(
          model: obj,
          onSelectTile: _controller.selectCard,
          isSelected: _controller.selectedCardIndex.value == index,
          index: index,
        );
      },
      shrinkWrap: true,
      itemCount: _controller.paymentMethodList.length);

  /// Build payment method banner.
  Widget buildPaymentMethodBanner() {
    return Container(
        width: double.infinity,
        height: AppValues.paymentMethodBannerHeight,
        color: AppColors.pageBackground,
        child: SvgPicture.asset(AppBanner.paymentCardBanner));
  }

  /// Build add card text button.
  Widget buildAddCardTextButton() {
    return Container(
      width: double.infinity,
      color: AppColors.pageBackground,
      child: TextButton(
          onPressed: () => _controller.addNewPaymentMethod(),
          child: Text(
            AppString.addNewCardWithPlus,
            style: textTheme.bodyLarge?.copyWith(
                color: AppColors.appRedButtonColor,
                fontWeight: FontWeight.w500),
          )),
    );
  }
}
