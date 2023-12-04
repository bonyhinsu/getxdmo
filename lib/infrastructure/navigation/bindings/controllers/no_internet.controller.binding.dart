import 'package:get/get.dart';

import '../../../../presentation/no_internet/controllers/no_internet.controller.dart';
import '../../routes.dart';

class NoInternetControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NoInternetController>(
      () => NoInternetController(),
      tag: Routes.NO_INTERNET
    );
  }
}
