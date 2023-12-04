import 'package:get/get.dart';

import '../../../../presentation/screens/home/club_home/controllers/club_home_controller.dart';
import '../../routes.dart';

class ClubHomeControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClubHomeController>(
      () => ClubHomeController(),
        tag: Routes.CLUB_HOME
    );
  }
}
