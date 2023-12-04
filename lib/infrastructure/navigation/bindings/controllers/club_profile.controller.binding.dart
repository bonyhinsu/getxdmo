import 'package:get/get.dart';

import '../../../../presentation/screens/club/club_profile/controllers/club_profile.controller.dart';
import '../../routes.dart';

class ClubProfileControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClubProfileController>(
      () => ClubProfileController(),
        tag: Routes.CLUB_PROFILE
    );
  }
}
