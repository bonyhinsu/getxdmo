import 'package:dio/dio.dart' as dio;
import 'package:game_on_flutter/infrastructure/navigation/route_config.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_loading_mixin.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../../infrastructure/model/subscription/subscription_detail_response_model.dart';
import '../../../../../infrastructure/model/subscription/subscription_sport_model.dart';
import '../../../../../infrastructure/model/subscription/user_previous_subscription_model.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../infrastructure/network/api_utils.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../values/app_string.dart';
import '../../../../../values/common_utils.dart';
import '../../../../app_widgets/app_dialog_with_title_widget.dart';
import '../../manage_subscription/controllers/manage_subscription.controller.dart';
import '../../subscription_plan/controllers/subscription_plan.controller.dart';
import '../providers/subscription_detail_provider.dart';

class SubscriptionDetailController extends GetxController with AppLoadingMixin {
  /// Holds transaction list.
  RxList<UserPreviousSubscriptionModel> transactionList = RxList();

  final _provider = SubscriptionDetailProvider();

  /// current plan detail
  Rx<SubscriptionSportModel> currentPlanDetail =
      SubscriptionSportModel.blank().obs;

  /// Subscription Id
  int subscriptionId = -1;

  /// Sport detail Id
  int subscriptionSportId = -1;

  /// Store true for enable renew subscription button.
  RxBool enableRenew = false.obs;

  /// Store true for enable cancel subscription button.
  RxBool enableCancel = false.obs;

  @override
  void onInit() {
    _getArgument();
    super.onInit();
  }

  void _getArgument() {
    if (Get.arguments != null) {
      subscriptionId = Get.arguments[RouteArguments.subscriptionId] ?? -1;
      subscriptionSportId = Get.arguments[RouteArguments.sportDetailId] ?? -1;
      _getSubscriptionDetail();
    }
  }

  /// Renew subscription pattern
  void onRenewSubscription() {
    Get.toNamed(Routes.SUBSCRIPTION_PLAN, arguments: {
      RouteArguments.paymentPlanDetail: currentPlanDetail.value,
      RouteArguments.sportDetailId: subscriptionSportId,
      RouteArguments.itemId: subscriptionId,
      RouteArguments.subscriptionType: currentPlanDetail.value.subscriptionType,
      RouteArguments.subscriptionEnum: SubscriptionEnum.RENEW,
    });
  }

  /// on cancel subscription.
  void onCancelSubscription() {
    cancelSubscriptionConfirmationDialog();
  }

  /// Cancel subscription dialog.
  void cancelSubscriptionConfirmationDialog() {
    Get.dialog(AppDialogWithTitleWidget(
      onDone: cancelUserSubscription,
      dialogText: AppString.cancelSubscriptionMessage,
      dialogTitle: 'Cancel ${currentPlanDetail.value.sportName} Subscription',
    ));
  }

  /// API to fetch user subscription transactions.
  void _getSubscriptionDetail() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showLoading();
      dio.Response? response =
          await _provider.getSubscriptionDetail(subscriptionSportId.toString());
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _getTransactionSuccess(response);
        } else {
          /// On Error
          _apiError(response);
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

  /// Perform transaction api success
  void _getTransactionSuccess(dio.Response response) {
    hideLoading();
    hideGlobalLoading();

    SubscriptionDetailModel subscriptionDetailModel =
        SubscriptionDetailModel.fromJson(response.data);

    if (subscriptionDetailModel.data != null) {
      final subscriptionModel = subscriptionDetailModel.data!;
      // Subscription history
      _prepareSubscriptionHistory(subscriptionModel);

      // Subscription plan model
      _prepareSubscriptionPlanModel(subscriptionModel);
    }
  }

  /// Subscription history
  void _prepareSubscriptionHistory(
      SubscriptionDetailModelData subscriptionModel) {
    transactionList.clear();
    subscriptionModel.getSubscriptionHistory?.forEach((element) {
      transactionList.add(UserPreviousSubscriptionModel(
          element.activateDate ?? "", (element.paidAmount ?? 0).toString()));
    });
  }

  /// Subscription plan model
  void _prepareSubscriptionPlanModel(
      SubscriptionDetailModelData subscriptionModel) {
    String expiryDate = subscriptionModel.nextPaymentDate ?? "";
    int remainingDaysCount =
        expiryDate.isEmpty ? 0 : CommonUtils.getRemainingDays1(expiryDate);

    String subscriptionAmount =
        (subscriptionModel.subscriptionPlanAmount ?? 0).toString();

    currentPlanDetail.value = SubscriptionSportModel(
        sportName:
            subscriptionModel.userSportDetail?.sportTypeDetails?.name ?? "",
        logoImage:
            subscriptionModel.userSportDetail?.sportTypeDetails?.logo ?? "",
        isYearly: (subscriptionModel.subscriptionPlanDuration ?? "monthly")
            .toLowerCase()
            .contains('yearly'),
        isPng:
            !(subscriptionModel.userSportDetail?.sportTypeDetails?.logo ?? "")
                .contains('svg'),
        amount: (subscriptionModel.subscriptionPlanAmount ?? 0).toString(),
        isUpgradable: subscriptionAmount == '0' && remainingDaysCount >= 0,
        nextRenewalDate: subscriptionModel.nextPaymentDate ?? "",
        subscriptionStartDate: subscriptionModel.firstPaymentDate ?? "",
        subscriptionType:
            subscriptionModel.subscriptionPlanDuration ?? "monthly");

    final isCancelled =
        (subscriptionModel.getSubscriptionHistory?.first.isCancel ?? 'n')
            .toLowerCase()
            .contains('y');

    // Check if enable cancel subscription button should be enable or not.
    enableCancel.value =
        !isCancelled && remainingDaysCount > 0 && subscriptionAmount != '0';

    // Check if enable renew subscription button should be enable or not.
    enableRenew.value =
        isCancelled && remainingDaysCount > 0 && subscriptionAmount != '0';
  }

  /// Perform api error.
  void _apiError(dio.Response response) {
    hideLoading();
    hideGlobalLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }

  /// API to cancel user subscription.
  void cancelUserSubscription() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showGlobalLoading();
      dio.Response? response =
          await _provider.cancelUserSubscription(subscriptionId.toString());
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _cancelTransactionSuccess(response);
        } else {
          /// On Error
          _apiError(response);
        }
      } else {
        hideGlobalLoading();
        GetIt.I<CommonUtils>().showServerDownError();
      }
    } else {
      hideGlobalLoading();
      GetIt.I<CommonUtils>().showNetworkError();
    }
  }

  /// API to renew user subscription.
  void renewUserSubscription() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showGlobalLoading();
      dio.Response? response = await _provider.reNewExistingSubscription(
          subscriptionId: subscriptionSportId.toString());
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.success ||
            response.statusCode == NetworkConstants.created) {
          /// On success
          _renewSubscriptionAPISuccess(response);
        } else {
          /// On Error
          _apiError(response);
        }
      } else {
        hideGlobalLoading();
        GetIt.I<CommonUtils>().showServerDownError();
      }
    } else {
      hideGlobalLoading();
      GetIt.I<CommonUtils>().showNetworkError();
    }
  }

  /// Perform transaction api success
  void _cancelTransactionSuccess(dio.Response response) {
    /// Update subscription plan detail
    _getSubscriptionDetail();

    /// Check is controller is registered or not.
    bool isControllerRegister = Get.isRegistered<ManageSubscriptionController>(
        tag: Routes.MANAGE_SUBSCRIPTION);
    if (isControllerRegister) {
      final ManageSubscriptionController controller =
          Get.find(tag: Routes.MANAGE_SUBSCRIPTION);

      /// Remove subscription from the list
      controller.getActiveSubscriptionPlanAPI();

      /// Navigate back to manage subscription.
      Get.until((route) => route.settings.name == Routes.MANAGE_SUBSCRIPTION);
    } else {
      /// If controller is not register then simply go to back from the current screen.
      Get.back();
    }
  }

  /// Perform renew subscription success
  ///
  /// required [response]
  void _renewSubscriptionAPISuccess(dio.Response response) {
    /// Update subscription plan detail
    _getSubscriptionDetail();

    /// Check is controller is registered or not.
    bool isControllerRegister = Get.isRegistered<ManageSubscriptionController>(
        tag: Routes.MANAGE_SUBSCRIPTION);
    if (isControllerRegister) {
      final ManageSubscriptionController controller =
          Get.find(tag: Routes.MANAGE_SUBSCRIPTION);

      /// Remove subscription from the list
      controller.getActiveSubscriptionPlanAPI();

      /// Navigate back to manage subscription.
      // Get.until((route) => route.settings.name == Routes.MANAGE_SUBSCRIPTION);
    } else {
      /// If controller is not register then simply go to back from the current screen.
      // Get.back();
    }
  }
}
