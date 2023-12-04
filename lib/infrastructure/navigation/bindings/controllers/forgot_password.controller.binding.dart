import 'package:get/get.dart';

import '../../../../presentation/screens/authentication/forgot_password/controllers/forgot_password.controller.dart';
import '../../routes.dart';

class ForgotPasswordControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController(),
        tag: Routes.FORGOT_PASSWORD);
  }
}
