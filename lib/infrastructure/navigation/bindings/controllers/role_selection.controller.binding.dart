import 'package:get/get.dart';

import '../../../../presentation/screens/authentication/role_selection/controllers/role_selection.controller.dart';

class RoleSelectionControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RoleSelectionController>(
      () => RoleSelectionController(),
    );
  }
}
