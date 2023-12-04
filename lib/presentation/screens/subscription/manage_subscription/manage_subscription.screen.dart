import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_on_flutter/presentation/screens/subscription/manage_subscription/view/user_subscription_shimmer_widget.dart';
import 'package:get/get.dart';

import '../../../../infrastructure/navigation/routes.dart';
import '../../../../values/app_colors.dart';
import '../../../../values/app_icons.dart';
import '../../../../values/app_string.dart';
import '../../../../values/app_values.dart';
import '../../../app_widgets/app_button_mixin.dart';
import '../../../app_widgets/app_text_mixin.dart';
import '../../../app_widgets/base_view.dart';
import '../../../custom_widgets/manage_subscription_tile_widget.dart';
import 'controllers/manage_subscription.controller.dart';

class ManageSubscriptionScreen extends GetView<ManageSubscriptionController>
    with AppBarMixin, AppButtonMixin, AppTextMixin {
  ManageSubscriptionScreen({Key? key}) : super(key: key);

  late TextTheme textTheme;
  late BuildContext buildContext;

  final ManageSubscriptionController _controller =
      Get.find(tag: Routes.MANAGE_SUBSCRIPTION);

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: buildAppBar(
        title: AppString.manageSubscriptions,
      ),
      floatingActionButton: _buildAddFab(),
      body: SafeArea(
        child: Obx(() => _buildBody(context)),
      ),
    );
  }

  /// Widget build body.
  Widget _buildBody(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppValues.screenMargin),
        child: _buildScrollableFields(),
      );

  /// Build scrollable fields.
  Widget _buildScrollableFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTitleRow(),
        Expanded(
          child: AnimatedSwitcher(
              duration: const Duration(
                  milliseconds: AppValues.shimmerWidgetChangeDurationInMillis),
              child: _controller.isLoading.isTrue
                  ? const UserSubscriptionShimmerWidget()
                  : _buildSubscriptionList()),
        )
      ],
    );
  }

  /// Build subscription list widget.
  ListView _buildSubscriptionList() {
    return ListView.separated(
      itemBuilder: (_, index) {
        return ManageSubscriptionTileWidget(
          model: _controller.subscriptionModel[index],
          onUpgrade: _controller.onUpgrade,
          onTap: _controller.onTap,
          onRenew: _controller.onRenew,
          index: index,
        );
      },
      padding: const EdgeInsets.symmetric(vertical: AppValues.screenMargin),
      separatorBuilder: (_, ctx) => Container(
        height: AppValues.margin_10,
      ),
      itemCount: _controller.subscriptionModel.length,
    );
  }

  /// add floating action button.
  Widget _buildAddFab() => Padding(
        padding: const EdgeInsets.only(
            bottom: AppValues.height_20, right: AppValues.height_6),
        child: FloatingActionButton(
          onPressed: () => _controller.activeNewSubscription(),
          backgroundColor: AppColors.fabButtonBackgroundChange,
          child: SvgPicture.asset(
            AppIcons.iconAdd,
            width: AppValues.iconSize_28,
            height: AppValues.iconSize_28,
            color: AppColors.textColorDarkGray,
          ),
        ),
      );

  /// Build title row.
  Widget _buildTitleRow() {
    return Container(
      color: AppColors.pageBackground,
      padding: const EdgeInsets.only(top: 30.0, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          screenTitle(
            textTheme: textTheme,
            isPrimaryText: true,
            value: AppString.strActiveSubscription,
          ),
        ],
      ),
    );
  }
}
