import 'package:get/get.dart';

import '../../../../presentation/screens/player/player_profile/controllers/player_profile.controller.dart';
import '../../routes.dart';

class PlayerProfileControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlayerProfileController>(tag: Routes.PLAYER_PROFILE,
      () => PlayerProfileController(),
    );
  }
}
