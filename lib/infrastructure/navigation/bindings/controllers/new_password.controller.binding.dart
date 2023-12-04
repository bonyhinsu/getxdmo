import 'package:get/get.dart';

import '../../../../presentation/screens/authentication/new_password/controllers/new_password.controller.dart';
import '../../routes.dart';

class NewPasswordControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewPasswordController>(
      () => NewPasswordController(),
        tag: Routes.NEW_PASSWORD
    );
  }
}
