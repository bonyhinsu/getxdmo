import 'package:get/get.dart';

import '../../../../presentation/screens/subscription/manage_subscription/controllers/manage_subscription.controller.dart';
import '../../routes.dart';

class ManageSubscriptionControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManageSubscriptionController>(
      () => ManageSubscriptionController(),
      tag: Routes.MANAGE_SUBSCRIPTION
    );
  }
}
