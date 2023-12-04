import 'package:dio/dio.dart' as dio;
import 'package:game_on_flutter/presentation/app_widgets/app_loading_mixin.dart';
import 'package:game_on_flutter/presentation/screens/subscription/payment_mathod/view/payent_confirmation_bottomsheet.dart';
import 'package:game_on_flutter/presentation/screens/subscription/payment_mathod/providers/payment_method_provider.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../../infrastructure/model/subscription/payment_method_model.dart';
import '../../../../../infrastructure/model/subscription/subscription_plan_model.dart';
import '../../../../../infrastructure/model/subscription/subscription_sport_model.dart';
import '../../../../../infrastructure/navigation/route_config.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../infrastructure/network/api_utils.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../values/app_colors.dart';
import '../../../../../values/common_utils.dart';
import '../../add_new_card/controllers/add_new_card.controller.dart';
import '../view/order_summary_bottomsheet.dart';

class PaymentMethodController extends GetxController with AppLoadingMixin {
  /// Initialise provider.
  final _provider = PaymentMethodProvider();

  /// Payment method list
  RxList<PaymentMethodModel> paymentMethodList = RxList();

  /// Stores selected card index.
  RxInt selectedCardIndex = 0.obs;

  SubscriptionPlanModel? subscriptionModel;

  @override
  void onInit() {
    _getArguments();
    // TODO: implement getActiveSubscriptionPlanAPI API.
    _prepareDummyData();
    super.onInit();
  }

  /// Receive arguments from previous screen.
  void _getArguments() {
    if (Get.arguments != null) {
      subscriptionModel = Get.arguments[RouteArguments.paymentPlanDetail];
    }
  }

  /// select card
  void selectCard(PaymentMethodModel model, int index) {
    paymentMethodList[selectedCardIndex.value].isSelected = false;
    selectedCardIndex.value = index;
    paymentMethodList[selectedCardIndex.value].isSelected = true;
    paymentMethodList.refresh();
  }

  /// Prepare dummy data to the field.
  void _prepareDummyData() {
    paymentMethodList.addAll([
      PaymentMethodModel.withDummyData("Mastercard", "1234123412341234",
          isSelected: true),
      PaymentMethodModel.withDummyData("Visa", "1234123412341234"),
    ]);
  }

  /// Add card to the list and select that card.
  void addNewCardAndSelect(PaymentMethodModel cardModel) {
    paymentMethodList[selectedCardIndex.value].isSelected = false;
    paymentMethodList.add(cardModel);
    selectedCardIndex.value = paymentMethodList.length - 1;
    paymentMethodList.refresh();
  }

  /// get active subscription plan
  void getActiveSubscriptionPlanAPI() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showGlobalLoading();
      dio.Response? response = await _provider.getUserSavedPaymentMethod();
      if (response != null) {
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
    hideGlobalLoading();
  }

  /// Perform api error.
  void _onError(dio.Response response) {
    hideGlobalLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }

  /// new payment method
  void addNewPaymentMethod() {
    Get.toNamed(Routes.ADD_NEW_CARD, arguments: {
      RouteArguments.addCardType: AddCardTypeEnum.ADD_CARD_AND_SUBSCRIBE
    });
  }

  /// Order summary bottomSheet.
  void viewOrderSummaryBottomSheet() {
    if (subscriptionModel == null) {
      return;
    }
    Get.bottomSheet(
        OrderSummeryBottomSheetWidget(
          onPayClick: () => _initialiseInAppPurchase(),
          subscriptionModel: subscriptionModel!,
        ),
        barrierColor: AppColors.bottomSheetBgBlurColor,
        isScrollControlled: true,
        enableDrag: false);
  }

  /// navigate user to platform in-app purchase.
  void _initialiseInAppPurchase() {
    /// TODO:: navigate to in-app purchase.
    showGlobalLoading();

    Future.delayed(const Duration(seconds: 2), () {
      hideGlobalLoading();
      viewPaymentConfirmationBottomSheet();
    });
  }

  /// Order summary bottomSheet.
  void viewPaymentConfirmationBottomSheet() {
    Get.bottomSheet(
        PaymentConfirmationBottomSheet(
          onDone: () => Get.offAllNamed(Routes.CLUB_MAIN),
        ),
        barrierColor: AppColors.bottomSheetBgBlurColor,
        isScrollControlled: true,
        enableDrag: false);
  }
}
