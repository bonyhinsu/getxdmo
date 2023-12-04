import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:game_on_flutter/infrastructure/navigation/route_config.dart';
import 'package:game_on_flutter/main.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_loading_mixin.dart';
import 'package:game_on_flutter/presentation/screens/subscription/subscription_plan/providers/subscription_plan_provider.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../../infrastructure/model/club/signup/club_signup_data.dart';
import '../../../../../infrastructure/model/subscription/subscription_plan_model.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../infrastructure/network/api_utils.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../infrastructure/storage/preference_manager.dart';
import '../../../../../values/app_constant.dart';
import '../../../../../values/common_utils.dart';
import '../../../authentication/general_data/controllers/app_master_data.controller.dart';
import '../../../club/club_favorite/controllers/club_data_provider_controller.dart';
import '../../../club/club_profile/controllers/user_detail_controller.dart';
import '../../../club/search_result/controllers/user_filter_menu_controller.dart';
import '../../manage_subscription/controllers/manage_subscription.controller.dart';

class SubscriptionPlanController extends GetxController with AppLoadingMixin {
  /// List of subscription plan.
  RxList<SubscriptionPlanModel> subscriptionPlanList = RxList();

  /// Initialse provider
  final _provider = SubscriptionPlanProvider();

  /// selected plan
  RxInt selectedIndex = 0.obs;

  /// subscription plan type.
  SubscriptionEnum subscriptionEnum = SubscriptionEnum.CLUB_SIGNUP;

  /// switch on off for subscription
  RxBool isMonthly = true.obs;

  /// Enable switch if true to switch current subscription plan.
  RxBool enablePlanToggle = true.obs;

  final List<GlobalKey> cardKeyList = [];

  /// subscription list.
  RxList<SubscriptionPlanResponseData> subscriptionList = RxList();

  /// current active selected model.
  Rx<SubscriptionPlanResponseData> selectedSubscriptionModel =
      SubscriptionPlanResponseData().obs;

  ///club signup data.
  SignUpData? signUpData;

  /// Current plan Id
  int currentPlanId = -1;

  /// Sport detail id
  int sportDetailId = -1;

  /// Subscription type
  String subscriptionType = '';

  @override
  void onInit() {
    _getArgument();
    getSubscriptionPlan();
    super.onInit();
  }

  @override
  void onReady() {
    if (subscriptionEnum == SubscriptionEnum.CLUB_SIGNUP) {
      CommonUtils.showSuccessSnackBar(
          message: AppString.clubSignupSuccessMessage);
    }
    super.onReady();
  }

  /// Get arguments form previous screen.
  void _getArgument() {
    if (Get.arguments != null) {
      subscriptionEnum = Get.arguments[RouteArguments.subscriptionEnum] ??
          SubscriptionEnum.CLUB_SIGNUP;

      enablePlanToggle.value = subscriptionEnum != SubscriptionEnum.RENEW &&
          subscriptionEnum != SubscriptionEnum.CLUB_UPGRADE_SUBSCRIPTION;

      signUpData = Get.arguments[RouteArguments.signupData] ?? SignUpData();
      currentPlanId = Get.arguments[RouteArguments.itemId] ?? -1;
      sportDetailId = Get.arguments[RouteArguments.sportDetailId] ?? -1;
      subscriptionType = Get.arguments[RouteArguments.subscriptionType] ?? '';
    }
  }

  /// On skip click
  void subscribeToPaidSubscription() {
    switch (subscriptionEnum) {
      case SubscriptionEnum.ADD_NEW_SUBSCRIPTION:
        addNewSubscriptionToUser(selectedSubscriptionModel.value.id ?? 1);
        break;

      case SubscriptionEnum.CLUB_UPGRADE_SUBSCRIPTION:
      case SubscriptionEnum.CLUB_UPGRADE_SUBSCRIPTION_FROM_FREE:
        upgradeSubscription(selectedSubscriptionModel.value.id ?? 1);
        break;

      case SubscriptionEnum.RENEW:
        renewSubscription();
        break;

      default:
        addSubscriptionToUser(selectedSubscriptionModel.value.id ?? 1);
    }
  }

  void skipUserSubscription() {
    final freeSubscriptionModel = subscriptionList.value.firstWhere((element) =>
        (element.subscriptionType ?? "").toLowerCase().contains('free'));

    // Add free subscription to the user.
    addSubscriptionToUser(freeSubscriptionModel.id ?? 1, isFree: true);
  }

  /// Select plan
  void selectPlan(SubscriptionPlanModel model, int index) {
    selectedIndex.value = index;
    selectedIndex.refresh();
    subscriptionPlanList.refresh();
  }

  /// Navigate to payment method.
  void navigateToPaymentMethod() {
    Get.toNamed(Routes.PAYMENT_METHOD, arguments: {
      RouteArguments.paymentPlanDetail:
          subscriptionPlanList[selectedIndex.value],
    });
  }

  /// get subscription plan API
  void getSubscriptionPlan() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showGlobalLoading();
      dio.Response? response = await _provider.getSubscriptionPlan();
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _getPlanSuccess(response);
        } else {
          /// On Error
          _onError(response);
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

  /// Perform login api success
  void _getPlanSuccess(dio.Response response) {
    try {
      SubscriptionPlanResponseModel clubMemberResponseModel =
          SubscriptionPlanResponseModel.fromJson(response.data);

      subscriptionList.value = clubMemberResponseModel.data ?? [];

      if (subscriptionEnum == SubscriptionEnum.RENEW) {
        final selectedSubscription = subscriptionList.value.firstWhere(
            (element) =>
                (element.planType ?? "").toLowerCase() ==
                subscriptionType.toLowerCase());
        isMonthly.value = (selectedSubscription.planType ?? "monthly")
            .toLowerCase()
            .contains('monthly');
      } else {
        isMonthly.value =
            subscriptionEnum != SubscriptionEnum.CLUB_UPGRADE_SUBSCRIPTION;
      }
      _getSelectedSubscriptionData();
    } catch (ex) {
      logger.e(ex);
    }

    hideGlobalLoading();
  }

  /// Perform renew subscription api success
  void _renewSubscriptionSuccess(dio.Response response) {
    hideGlobalLoading();
    _navigateToDashboard(AppString.subscriptionRenewed);
  }

  /// Perform api error.
  void _onError(dio.Response response) {
    hideGlobalLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }

  /// toggle subscription plan switch
  void toggleSubscriptionPlanSwitch(bool value) {
    isMonthly.value = value;
    _getSelectedSubscriptionData();
  }

  /// select object data based on switch data.
  void _getSelectedSubscriptionData() {
    if (subscriptionList.value.isNotEmpty) {
      if (isMonthly.isTrue) {
        selectedSubscriptionModel.value = subscriptionList.value.firstWhere(
            (element) =>
                (element.planType ?? "").toLowerCase().contains('monthly'));
      } else {
        selectedSubscriptionModel.value = subscriptionList.value.firstWhere(
            (element) =>
                (element.planType ?? "").toLowerCase().contains('yearly'));
      }
    }
  }

  /// add subscription to user.
  void addSubscriptionToUser(int subscriptionId, {bool isFree = false}) async {
    try {
      if (await NetworkConnectivity.instance.hasNetwork()) {
        showGlobalLoading();
        dio.Response? response = await _provider.addSubscription(
            sportTypeId: (signUpData?.sportType?.first.itemId ?? -1).toString(),
            subscriptionId: subscriptionId.toString());
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _addSubscriptionAPISuccess(response, isFree: isFree);
        } else {
          /// On Error
          _addSubscriptionAPIError(response);
        }
      }
    } catch (ex) {
      logger.e(ex);
      hideGlobalLoading();
      CommonUtils.showErrorSnackBar(message: ex.toString());
    }
  }

  /// add new subscription to user.
  void addNewSubscriptionToUser(int subscriptionId) async {
    try {
      if (await NetworkConnectivity.instance.hasNetwork()) {
        showGlobalLoading();
        dio.Response? response = await _provider.addNewSubscription(
          subscriptionId: subscriptionId.toString(),
          sportTypeId: (signUpData?.sportType ?? []).isNotEmpty
              ? (signUpData?.sportType ?? []).first.itemId
              : -1,
          locationDetail: (signUpData?.location ?? []).isNotEmpty
              ? (signUpData?.location ?? []).map((e) => e.itemId).toList()
              : [],
          playerCategoryDetail: (signUpData?.sportType ?? []).isNotEmpty
              ? (signUpData?.playerType ?? []).map((e) => e.itemId).toList()
              : [],
          levelDetail: (signUpData?.sportType ?? []).isNotEmpty
              ? (signUpData?.playerLevel ?? []).map((e) => e.itemId).toList()
              : [],
        );
        if (response.statusCode == NetworkConstants.created) {
          /// On success
          _addNewSubscriptionAPISuccess(response);
        } else {
          /// On Error
          _addSubscriptionAPIError(response);
        }
      }
    } catch (ex) {
      logger.e(ex);
      hideGlobalLoading();
      CommonUtils.showErrorSnackBar(message: ex.toString());
    }
  }

  /// Perform add user subscription api success
  void _addNewSubscriptionAPISuccess(dio.Response response) async {
    final UserDetailService service = Get.find(tag: AppConstants.USER_DETAILS);
    await service.getUserDetails();

    ManageSubscriptionController _controller =
        Get.find(tag: Routes.MANAGE_SUBSCRIPTION);
    _controller.getActiveSubscriptionPlanAPI();

    Get.lazyPut<ClubDataProviderController>(() => ClubDataProviderController(),
        tag: Routes.CLUB_DATA_PROVIDER);

    Get.lazyPut<MasterDataController>(() => MasterDataController(),
        tag: Routes.MASTER_DATA_PROVIDER);

    UserFilterMenuController masterDataController =
        Get.find(tag: Routes.CLUB_PLAYER_FILTER);
    masterDataController.forceRefreshAllData();

    hideGlobalLoading();
    Get.until((route) => route.settings.name == Routes.MANAGE_SUBSCRIPTION);
    CommonUtils.showSuccessSnackBar(
        message:
            "Congratulations! You have subscribed to ${(signUpData?.sportType ?? []).first.title}.");
  }

  /// Perform add user subscription api success
  void _addSubscriptionAPISuccess(dio.Response response,
      {bool isFree = false}) {
    hideGlobalLoading();

    _navigateToDashboard(isFree ? AppString.freePlanSubscriptionMessage : "");
  }

  /// Navigate to dashboard.
  void _navigateToDashboard(String message) {
    GetIt.I<PreferenceManager>().setLogin(true);
    Get.offAllNamed(Routes.CLUB_MAIN,
        arguments: {RouteArguments.message: message});
  }

  /// Perform add user subscription api error.
  void _addSubscriptionAPIError(dio.Response response) {
    hideGlobalLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response, isFromLogin: true);
  }

  /// Renew subscription plan.
  void renewSubscription() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showGlobalLoading();
      dio.Response? response = await _provider.reNewExistingSubscription(
          subscriptionId:(selectedSubscriptionModel.value.id ?? 1).toString(),
          sportId: sportDetailId.toString());
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _renewSubscriptionSuccess(response);
        } else {
          /// On Error
          _onError(response);
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

  /// Upgrade subscription plan.
  void upgradeSubscription(int subscriptionId) async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showGlobalLoading();
      dio.Response? response = await _provider.upgradeExistingSubscription(
          subscriptionId: subscriptionId.toString(),
          sportDetailId: sportDetailId.toString());
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _upgradeSubscriptionSuccess(response);
        } else {
          /// On Error
          _onError(response);
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

  /// Perform upgrade subscription api success
  void _upgradeSubscriptionSuccess(dio.Response response) {
    hideGlobalLoading();
    _navigateToDashboard('');
  }
}

enum SubscriptionEnum {
  CLUB_SIGNUP,
  CLUB_UPGRADE_SUBSCRIPTION,
  CLUB_UPGRADE_SUBSCRIPTION_FROM_FREE,
  ADD_NEW_SUBSCRIPTION,
  RENEW,
}
