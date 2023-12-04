import 'package:get/get.dart';

import '../../../../presentation/screens/player/player_profile_privacy/select_club/controllers/select_club.controller.dart';
import '../../routes.dart';

class SelectClubControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectClubController>(
      () => SelectClubController(),tag: Routes.SELECT_CLUB
    );
  }
}
