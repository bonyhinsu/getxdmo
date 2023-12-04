import 'package:get/get.dart';

import '../../../../presentation/screens/home/club_notification/controllers/club_notification.controller.dart';
import '../../routes.dart';

class ClubNotificationControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClubNotificationController>(
      () => ClubNotificationController(),tag: Routes.CLUB_NOTIFICATION
    );

  }
}
