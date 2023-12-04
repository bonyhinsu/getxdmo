import 'package:get/get.dart';

import '../../../../presentation/screens/player/player_home/controllers/player_home.controller.dart';
import '../../routes.dart';

class PlayerHomeControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlayerHomeController>(
      () => PlayerHomeController(),
        tag: Routes.PLAYER_HOME
    );
  }
}
