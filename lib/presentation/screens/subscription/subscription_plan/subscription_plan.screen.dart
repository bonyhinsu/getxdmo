import 'package:animated_switch/animated_switch.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

import '../../../../infrastructure/model/subscription/subscription_plan_model.dart';
import '../../../../infrastructure/navigation/routes.dart';
import '../../../../values/app_colors.dart';
import '../../../../values/app_icons.dart';
import '../../../../values/app_string.dart';
import '../../../../values/app_values.dart';
import '../../../app_widgets/app_button_mixin.dart';
import '../../../app_widgets/app_text_mixin.dart';
import '../../../app_widgets/base_view.dart';
import '../../../custom_widgets/subscription_plan_tile_widget.dart';
import 'controllers/subscription_plan.controller.dart';

class SubscriptionPlanScreen extends GetView<SubscriptionPlanController>
    with AppBarMixin, AppButtonMixin, AppTextMixin {
  SubscriptionPlanScreen({Key? key}) : super(key: key);

  late TextTheme textTheme;
  late BuildContext buildContext;

  final SubscriptionPlanController _controller =
      Get.find(tag: Routes.SUBSCRIPTION_PLAN);

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: buildAppBarWithActions(
        title: AppString.subscriptionPlan,
        actions: [
          if (_controller.subscriptionEnum == SubscriptionEnum.CLUB_SIGNUP)
            buildSkipButton()
        ],
      ),
      body: SafeArea(
        child: Obx(() => buildBody(context)),
      ),
    );
  }

  /// Build skip button.
  Widget buildSkipButton() {
    return Padding(
      padding: const EdgeInsets.only(top: AppValues.appbarTopMargin),
      child: TextButton(
        onPressed: () => _controller.skipUserSubscription(),
        child: Text(
          AppString.skip,
          style: textTheme.displaySmall
              ?.copyWith(color: AppColors.appRedButtonColor),
        ),
      ),
    );
  }

  /// Widget build body.
  Widget buildBody(BuildContext context) => Padding(
        padding: const EdgeInsets.all(AppValues.screenMargin),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: AppValues.height_20,
                  ),
                  Expanded(child: buildSubscription()),
                  Container(
                    height: AppValues.height_20,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                if (_controller.subscriptionEnum ==
                    SubscriptionEnum.CLUB_SIGNUP)
                  buildThirtyDaysText(),
                if (_controller.subscriptionEnum ==
                    SubscriptionEnum.CLUB_SIGNUP)
                  Container(
                    height: AppValues.height_6,
                  ),
                if (_controller.subscriptionEnum ==
                    SubscriptionEnum.CLUB_SIGNUP)
                  buildSubscriptionPlanText(),
                Container(
                  height: AppValues.height_16,
                ),
                appWhiteButton(
                    title: AppString.strContinue,
                    onClick: () => _controller.subscribeToPaidSubscription()),
                Container(
                  height: AppValues.height_16,
                ),
                buildCancelAnyTimeText(),
              ],
            )
          ],
        ),
      );

  /// Build title
  Widget buildTitle() => Text(
        AppString.choosePaidPlanForYou,
        style: textTheme.labelMedium?.copyWith(
          color: AppColors.textColorDarkGray,
          fontWeight: FontWeight.w500,
        ),
      );

  /// buildCancelAnyTimeText Build text
  Widget buildThirtyDaysText() => Text(
        textAlign: TextAlign.left,
        AppString.thirtyDaysTrialStr,
        style: textTheme.bodyMedium?.copyWith(color: AppColors.textColorWhite),
      );

  /// buildCancelAnyTimeText Build text
  Widget buildSubscriptionPlanText() => Text(
        'then \$ ${_controller.selectedSubscriptionModel.value.amount ?? 0} per ${_controller.isMonthly.value ? 'month' : 'year'}',
        textAlign: TextAlign.left,
        style:
            textTheme.bodyMedium?.copyWith(color: AppColors.textColorDarkGray),
      );

  /// buildCancelAnyTimeText Build text
  Widget buildCancelAnyTimeText() => Text(
        textAlign: TextAlign.left,
        "Note: ${AppString.strCancelAnytimePlan}",
        style:
            textTheme.bodyMedium?.copyWith(color: AppColors.textColorDarkGray),
      );

  /// Build list widget.
  Widget buildList() => ListView.separated(
        separatorBuilder: (_, __) {
          return const Divider(
            height: 10,
            color: Colors.transparent,
          );
        },
        scrollDirection: Axis.vertical,
        itemCount: _controller.subscriptionPlanList.length,
        itemBuilder: (BuildContext context, int index) {
          return SubscriptionPlanTileWidget(
            index: index,
            model: _controller.subscriptionPlanList[index],
            selectedTile: _controller.selectPlan,
            selectedIndex: _controller.selectedIndex.value,
            expandKey: _controller.cardKeyList[index],
          );
        },
      );

  Widget buildTitleList1() => Column(
        children: [
          ExpansionPanelList(
            elevation: 4,
            expandedHeaderPadding: const EdgeInsets.all(6),
            expansionCallback: (int index, bool isExpanded) {
              _controller.selectedIndex.value = index;
            },
            children: _controller.subscriptionPlanList
                .mapIndexed<ExpansionPanel>(
                    (int index, SubscriptionPlanModel model) {
              return ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.appRedButtonColor)),
                    child: ListTile(
                      onTap: () {
                        _controller.selectedIndex.value = index;
                      },
                      title: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: AppValues.margin_15),
                            child: Text(
                              model.planTitle ?? "",
                              style: textTheme.headlineLarge?.copyWith(
                                  color: AppColors.textColorSecondary,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "\$${model.planAmount ?? ""}",
                            style: textTheme.headlineLarge?.copyWith(
                                color: AppColors.textColorSecondary,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            width: AppValues.margin_15,
                          ),
                          SvgPicture.asset(AppIcons.downArrow),
                        ],
                      ),
                    ),
                  );
                },
                body: Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, bottom: 16.0, right: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Features:",
                        style: textTheme.labelMedium?.copyWith(
                            color: AppColors.textColorDarkGray,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        model.planFeatures ?? "",
                        style: textTheme.displaySmall
                            ?.copyWith(color: AppColors.textColorDarkGray),
                      ),
                    ],
                  ),
                ),
                backgroundColor: AppColors.appRedButtonColor.withOpacity(0.2),
                isExpanded: _controller.selectedIndex.value == index,
              );
            }).toList(),
          ),
        ],
      );

  Widget buildSubscription() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.appRedButtonColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.appRedButtonColor.withOpacity(0.1),
            spreadRadius: 12,
            blurRadius: 18,
          ),
        ],
        // color: AppColors.appRedButtonColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                    child: buildTitlePlan(
                        _controller.selectedSubscriptionModel.value.planType ??
                            '')),
                if (_controller.enablePlanToggle.value) subscriptionPlanSwitch()
              ],
            ),
            buildPremium(
                "\$ ${_controller.selectedSubscriptionModel.value.amount ?? 0}"),
            const SizedBox(
              height: 10,
            ),
            Expanded(child: buildFeatures())
          ],
        ),
      ),
    );
  }

  /// Subscription switch toggle.
  Widget subscriptionPlanSwitch() {
    return AnimatedSwitch(
      onChanged: (value) => _controller.toggleSubscriptionPlanSwitch(value),
      colorOn: AppColors.switchColorTernary,
      height: 30,
      width: 30,
      value: _controller.isMonthly.value,
      colorOff: AppColors.switchColorTernary,
      textOn: "Yearly",
      textOff: "Monthly",
      textStyle: const TextStyle(color: Colors.white, fontSize: 7),
    );
  }

  /// build planTitle Widget
  Widget buildTitlePlan(String plan) {
    return Text(
      plan,
      style: textTheme.headlineLarge?.copyWith(
          color: AppColors.textColorSecondary, fontWeight: FontWeight.w500),
    );
  }

  /// build planPremium Widget
  Widget buildPremium(String rate) {
    return Text(
      rate,
      style: textTheme.headlineLarge?.copyWith(
          color: AppColors.textColorSecondary, fontWeight: FontWeight.w500),
    );
  }

  /// build features widget
  Widget buildFeatures() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Features:",
            style: textTheme.labelMedium?.copyWith(
                color: AppColors.textColorDarkGray,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: AppValues.height_10,
          ),
          HtmlWidget(
            _controller.selectedSubscriptionModel.value.description ?? "",
            textStyle: textTheme.displaySmall
                ?.copyWith(color: AppColors.textColorDarkGray),
          ),
        ],
      ),
    );
  }
}
