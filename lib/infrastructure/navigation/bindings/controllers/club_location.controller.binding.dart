import 'package:get/get.dart';

import '../../../../presentation/screens/club/signup/club_location/controllers/club_location.controller.dart';
import '../../routes.dart';

class ClubLocationControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClubLocationController>(
      () => ClubLocationController(),
        tag: Routes.CLUB_LOCATION
    );
  }
}
