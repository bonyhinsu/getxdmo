import 'package:get/get.dart';

import '../../../../presentation/screens/club/signup/club_player_type/controllers/club_player_type.controller.dart';
import '../../routes.dart';

class ClubPlayerTypeControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClubPlayerTypeController>(
      () => ClubPlayerTypeController(),
        tag: Routes.CLUB_PLAYER_TYPE
    );
  }
}
