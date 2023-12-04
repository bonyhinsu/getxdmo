import 'package:get/get.dart';

import '../../../../presentation/screens/subscription/subscription_detail/controllers/subscription_detail.controller.dart';
import '../../routes.dart';

class SubscriptionDetailControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubscriptionDetailController>(
      () => SubscriptionDetailController(),
        tag: Routes.SUBSCRIPTION_DETAIL
    );
  }
}
