import 'package:get/get.dart';

import '../../../../presentation/screens/subscription/payment_mathod/controllers/payment_mathod.controller.dart';
import '../../routes.dart';

class PaymentMethodControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentMethodController>(
      () => PaymentMethodController(),
        tag: Routes.PAYMENT_METHOD
    );
  }
}
