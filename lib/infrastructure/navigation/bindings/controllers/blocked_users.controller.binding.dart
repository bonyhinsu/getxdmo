import 'package:get/get.dart';

import '../../../../presentation/screens/player/blocked_users/controllers/blocked_users.controller.dart';
import '../../routes.dart';

class BlockedUsersControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BlockedUsersController>(
      () => BlockedUsersController(),
      tag: Routes.BLOCKED_USERS,
    );
  }
}
