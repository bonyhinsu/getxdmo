import 'package:get/get.dart';

import '../../../../presentation/screens/club/signup/club_level/controllers/club_level.controller.dart';
import '../../routes.dart';

class ClubLevelControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClubLevelController>(
      () => ClubLevelController(),
        tag: Routes.CLUB_LEVEL
    );
  }
}
