import 'package:dio/dio.dart' as dio;
import 'package:game_on_flutter/infrastructure/navigation/route_config.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_loading_mixin.dart';
import 'package:game_on_flutter/presentation/screens/club/signup/sports_selection/controllers/sports_selection.controller.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../../../../infrastructure/model/subscription/subscription_sport_model.dart';
import '../../../../../infrastructure/model/subscription/user_subscription_model.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../infrastructure/network/api_utils.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../values/common_utils.dart';
import '../../subscription_plan/controllers/subscription_plan.controller.dart';
import '../providers/manage_subscription_provider.dart';

class ManageSubscriptionController extends GetxController with AppLoadingMixin {
  RxList<SubscriptionSportModel> subscriptionModel = RxList();

  /// logger
  final logger = Logger();

  /// Initialise provider
  final _provider = ManageSubscriptionProvider();

  @override
  void onInit() {
    getActiveSubscriptionPlanAPI();

    super.onInit();
  }

  /// Activate new subscription.
  void activeNewSubscription() {
    Get.toNamed(Routes.SPORT_TYPE, arguments: {
      RouteArguments.sportTypeEnum: SportTypeEnum.ADD_SUBSCRIPTION,
      RouteArguments.addedSportType: subscriptionModel.value,
    });
  }

  /// On upgrade plan
  void onUpgrade(SubscriptionSportModel model, int index) {
    Get.toNamed(Routes.SUBSCRIPTION_PLAN, arguments: {
      RouteArguments.sportDetailId: model.userSportDetailId,
      RouteArguments.subscriptionEnum: model.isFreePlan
          ? SubscriptionEnum.CLUB_UPGRADE_SUBSCRIPTION_FROM_FREE
          : SubscriptionEnum.CLUB_UPGRADE_SUBSCRIPTION
    });
  }

  /// on renew plan
  void onRenew(SubscriptionSportModel model, int index) {
    Get.toNamed(Routes.SUBSCRIPTION_PLAN, arguments: {
      RouteArguments.paymentPlanDetail: model,
      RouteArguments.sportDetailId: model.userSportDetailId,
      RouteArguments.subscriptionId: model.itemId,
      RouteArguments.subscriptionType: model.subscriptionType,
      RouteArguments.subscriptionEnum: SubscriptionEnum.RENEW,
    });
  }

  /// on tap
  void onTap(SubscriptionSportModel model, int index) {
    if (!model.isFreePlan) {
      Get.toNamed(Routes.SUBSCRIPTION_DETAIL, arguments: {
        RouteArguments.subscriptionId: model.itemId,
        RouteArguments.sportDetailId: model.userSportDetailId,
        RouteArguments.subscriptionIndex: index
      });
    }
  }

  /// get active subscription plan
  void getActiveSubscriptionPlanAPI() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showLoading();
      dio.Response? response = await _provider.getUserActiveSubscription();
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _getPlanSuccess(response);
        } else {
          /// On Error
          _onError(response);
        }
      } else {
        hideLoading();
        GetIt.I<CommonUtils>().showServerDownError();
      }
    } else {
      hideLoading();
      GetIt.I<CommonUtils>().showNetworkError();
    }
  }

  /// Remove subscription from subscription list.
  void removeSubscriptionFromList(int index) {
    subscriptionModel.removeAt(index);
  }

  /// Perform login api success
  void _getPlanSuccess(dio.Response response) {
    try {
      SubscriptionListModel model =
          SubscriptionListModel.fromJson(response.data);
      subscriptionModel.clear();
      for (SubscriptionListData element in (model.data ?? [])) {
        final subscriptionItem = _subscriptionSportModel(element);
        subscriptionModel.add(subscriptionItem);
      }
    } catch (ex) {
      logger.e(ex);
    }
    hideLoading();
  }

  /// Perform api error.
  void _onError(dio.Response response) {
    hideLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }

  /// Returns [SubscriptionSportModel] instance from [SubscriptionListData].
  SubscriptionSportModel _subscriptionSportModel(SubscriptionListData data) {
    final isYearlyPlan =
        (data.subscriptionData?.subscriptionDetails?.planType ?? 'monthly')
                .toLowerCase() ==
            'yearly';

    final isCancelled =
        (data.subscriptionData?.isCancel ?? 'n').toLowerCase().contains('y');
    String subscriptionAmount =
        (data.subscriptionData?.subscriptionDetails?.amount ?? 0).toString();

    String expiryDate = data.subscriptionData?.expiryDate ?? "";
    int remainingDaysCount =
        expiryDate.isEmpty ? 0 : CommonUtils.getRemainingDays1(expiryDate);

    return SubscriptionSportModel(
      itemId: data.subscriptionData?.id ?? -1,
      userSportDetailId: data.subscriptionData?.userSportDetailId ?? -1,
      sportName: data.sportTypeDetails?.name ?? "",
      subscriptionType: data.subscriptionData?.subscriptionDetails?.planType??"",
      logoImage: data.sportTypeDetails?.logo ?? "",
      amount: subscriptionAmount,
      nextRenewalDate: data.subscriptionData?.expiryDate ?? "",
      isFreePlan: subscriptionAmount == '0',
      isYearly: isYearlyPlan,
      isCancelled: isCancelled,
      canRenew:
          remainingDaysCount >= 0 && data.subscriptionData?.isExpire == 'n',
      isUpgradable: subscriptionAmount == '0' && remainingDaysCount >= 0,
      subscriptionStartDate: data.subscriptionData?.activateDate ?? "",
    );
  }
}
