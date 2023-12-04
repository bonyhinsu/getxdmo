import 'package:get/get.dart';

import '../../../../presentation/screens/authentication/welcome/controllers/welcome.controller.dart';


class WelcomeControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WelcomeController>(
      () => WelcomeController(),
    );
  }
}
