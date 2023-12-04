import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:game_on_flutter/infrastructure/model/common/app_fields.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_shimmer.dart';
import 'package:game_on_flutter/presentation/screens/subscription/subscription_detail/view/subscription_transaction_shimmer_widget.dart';
import 'package:game_on_flutter/values/app_colors.dart';
import 'package:game_on_flutter/values/app_images.dart';
import 'package:game_on_flutter/values/app_values.dart';
import 'package:game_on_flutter/values/common_utils.dart';
import 'package:get/get.dart';

import '../../../../infrastructure/navigation/routes.dart';
import '../../../../values/app_string.dart';
import '../../../app_widgets/app_button_mixin.dart';
import '../../../app_widgets/app_text_mixin.dart';
import '../../../app_widgets/base_view.dart';
import '../../../custom_widgets/previous_transaction_tile_widget.dart';
import 'controllers/subscription_detail.controller.dart';

class SubscriptionDetailScreen extends GetView<SubscriptionDetailController>
    with AppBarMixin, AppButtonMixin, AppTextMixin {
  final SubscriptionDetailController _controller =
      Get.find(tag: Routes.SUBSCRIPTION_DETAIL);

  SubscriptionDetailScreen({Key? key}) : super(key: key);

  late TextTheme textTheme;
  late BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: buildAppBar(
        title: AppString.subscription,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppValues.screenMargin),
          child: Obx(
            () => Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: _controller.isLoading.isTrue
                        ? const NeverScrollableScrollPhysics()
                        : const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildHeadingSportWidget(),
                        buildSectionTitle(title: AppString.details),
                        buildDetailRow(
                            title: _controller.currentPlanDetail.value.isYearly
                                ? AppString.averageYearly
                                : AppString.averageMonthly,
                            value:
                                '\$${_controller.currentPlanDetail.value.amount}'),
                        divider,
                        buildDetailRow(
                            title: AppString.nextPayment,
                            value: CommonUtils.ddmmmyyyyDateWithTimezone(
                                _controller
                                    .currentPlanDetail.value.nextRenewalDate)),
                        divider,
                        buildDetailRow(
                            title: AppString.firstPayment,
                            value: CommonUtils.ddmmmyyyyDateWithTimezone(
                                _controller.currentPlanDetail.value
                                    .subscriptionStartDate)),
                        divider,
                        buildSectionTitle(title: AppString.previousPayment),
                        const SizedBox(height: AppValues.height_16),
                        AnimatedSwitcher(
                            duration: const Duration(
                                milliseconds: AppValues
                                    .shimmerWidgetChangeDurationInMillis),
                            child: _controller.isLoading.isTrue
                                ? const SubscriptionTransactionShimmerWidget()
                                : _controller.transactionList.isNotEmpty
                                    ? buildPreviousTransactionList()
                                    : buildNoPresident()),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppValues.screenMargin),
                buildBottomRowWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build heading widget.
  Widget buildHeadingSportWidget() {
    return SizedBox(
      width: double.infinity,
      height: 142,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 70,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppColors.appRedButtonColor.withOpacity(0.20),
                  borderRadius: BorderRadius.circular(AppValues.smallRadius)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [buildSportName(), buildSubscriptionAmountWidget()],
                ),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              height: 96,
              child: SvgPicture.asset(AppImages.subscriptionHeaderShape),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.only(bottom: 6, left: 6),
              child: AnimatedSwitcher(
                duration: const Duration(
                    milliseconds:
                        AppValues.shimmerWidgetChangeDurationInMillis),
                child: _controller.isLoading.isTrue
                    ? AppShimmer(
                        child: Container(
                          height: 77,
                          width: 77,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(100)),
                        ),
                      )
                    : _controller.currentPlanDetail.value.isPng
                        ? Image.network(
                            '${AppFields.instance.imagePrefix}${_controller.currentPlanDetail.value.logoImage}',
                            height: 77,
                            width: 77,
                          )
                        : SvgPicture.asset(
                            '${AppFields.instance.imagePrefix}${_controller.currentPlanDetail.value.logoImage}',
                            height: 77,
                            width: 77,
                          ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build renew and cancel button row.
  Widget buildBottomRowWidget() => Row(
        children: [
          Expanded(
            child: _controller.isLoading.isTrue?AppShimmer(
              child: appRedButton(
                  title: AppString.cancel,
                  isValidate: _controller.enableCancel.value,
                  onClick: () => {}),
            ):appRedButton(
                title: AppString.cancel,
                isValidate: _controller.enableCancel.value,
                onClick: () => _controller.onCancelSubscription()),
          ),
          const SizedBox(
            width: AppValues.height_20,
          ),
          Expanded(
            child: _controller.isLoading.isTrue?AppShimmer(
              child: SizedBox(
                height: 54,
                child: appGrayButton(
                    title: AppString.strRenew,
                    onClick: () => {}),
              ),
            ):appWhiteButton(
                title: AppString.strRenew,
                isValidate: _controller.enableRenew.value,
                onClick: () => _controller.onRenewSubscription()),
          ),
        ],
      );

  /// Build sport name
  Widget buildSportName() => _controller.isLoading.isTrue
      ? AppShimmer(
          child: Container(
          width: 80,
          height: 20,
          color: AppColors.textColorSecondary.withOpacity(0.5),
        ))
      : Text(
          _controller.currentPlanDetail.value.sportName,
          style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500, color: AppColors.textColorPrimary),
        );

  /// Build subscription amount widget.
  Widget buildSubscriptionAmountWidget() {
    return _controller.isLoading.isTrue
        ? AppShimmer(
            child: Container(
            width: 90,
            height: 20,
            color: AppColors.textColorSecondary.withOpacity(0.5),
          ))
        : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '\$${_controller.currentPlanDetail.value.amount}',
                textAlign: TextAlign.start,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColorPrimary),
              ),
              Text(
                "/${_controller.currentPlanDetail.value.isYearly ? AppString.strYearly : AppString.strMonthly}",
                textAlign: TextAlign.end,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: textTheme.displaySmall?.copyWith(
                    color: AppColors.textColorDarkGray, fontSize: 12),
              ),
            ],
          );
  }

  /// Build section title
  Widget buildSectionTitle({required String title}) {
    return Padding(
      padding: const EdgeInsets.only(top: AppValues.height_20),
      child: _controller.isLoading.isTrue
          ? AppShimmer(
            child: Text(
                title,
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColorPrimary),
              ),
          )
          : Text(
              title,
              textAlign: TextAlign.start,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColorPrimary),
            ),
    );
  }

  /// Build detail row widget.
  Widget buildDetailRow({
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
          bottom: AppValues.height_8, top: AppValues.height_10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _controller.isLoading.isTrue
              ? AppShimmer(
                  child: Container(
                  width: 90,
                  height: 12,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  color: AppColors.textColorSecondary.withOpacity(0.5),
                ))
              : Text(title,
                  textAlign: TextAlign.start,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.displaySmall?.copyWith(fontSize: 13)),
          _controller.isLoading.isTrue
              ? AppShimmer(
                  child: Container(
                  width: 100,
                  height: 12,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  color: AppColors.textColorSecondary.withOpacity(0.5),
                ))
              : Text(
                  value,
                  textAlign: TextAlign.start,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.displaySmall?.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColorDarkGray),
                ),
        ],
      ),
    );
  }

  /// section divider
  Widget get divider => AppShimmer(
        enabled: _controller.isLoading.isTrue,
        child: const Divider(
          height: 1,
          color: AppColors.textColorSecondary,
        ),
      );

  /// User previous transaction list.
  Widget buildPreviousTransactionList() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, index) {
        return const SizedBox(
          height: AppValues.height_6,
        );
      },
      itemBuilder: (_, index) {
        return PreviousTransactionTileWidget(
            model: _controller.transactionList[index]);
      },
      shrinkWrap: true,
      itemCount: _controller.transactionList.length,
    );
  }

  /// Build no directors widget.
  Widget buildNoPresident() {
    return SizedBox(
      height: AppValues.margin_50,
      child: DottedBorder(
        dashPattern: const [6, 6, 6, 6],
        strokeWidth: 1,
        color: AppColors.textPlaceholderColor,
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            AppString.noPreviousTransaction,
            style: textTheme.displaySmall
                ?.copyWith(color: AppColors.inputFieldBorderColor),
          ),
        ),
      ),
    );
  }
}
