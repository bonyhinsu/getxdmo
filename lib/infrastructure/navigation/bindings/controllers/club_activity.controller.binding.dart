import 'package:get/get.dart';

import '../../../../presentation/screens/club/club_activity/controllers/club_activity.controller.dart';

class ClubActivityControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClubActivityController>(
      () => ClubActivityController(),
    );
  }
}
