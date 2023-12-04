import 'package:game_on_flutter/values/common_utils.dart';
import 'package:get/get.dart';

mixin AppLoadingMixin {
  RxBool isLoading = false.obs;

  void showLoading() {
    isLoading.value = true;
  }

  void hideLoading() {
    isLoading.value = false;
  }

  void showGlobalLoading() {
    CommonUtils.hideShowLoadingIndicator(context: Get.context!, isShow: true);
  }

  void hideGlobalLoading() {
    CommonUtils.hideShowLoadingIndicator(context: Get.context!, isShow: false);
  }

}
