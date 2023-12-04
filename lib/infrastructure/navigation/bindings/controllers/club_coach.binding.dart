import 'package:get/get.dart';

import '../../../../presentation/screens/club/signup/coaching_staff/view_coach/controller/club_coach.controller.dart';
import '../../routes.dart';

class ClubCoachBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClubCoachController>(() => ClubCoachController(),
        tag: Routes.CLUB_COACHING_STAFF);
  }
}
