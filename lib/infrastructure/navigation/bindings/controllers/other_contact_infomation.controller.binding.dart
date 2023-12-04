import 'package:get/get.dart';

import '../../../../presentation/screens/club/signup/other_contact_infomation/controllers/other_contact_infomation.controller.dart';
import '../../routes.dart';

class OtherContactInfomationControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtherContactInfomationController>(
        () => OtherContactInfomationController(),
        tag: Routes.OTHER_CONTACT_INFORMATION);

    Get.lazyPut<OtherContactInfomationController>(
        () => OtherContactInfomationController(),
        tag: Routes.CLUB_BOARD_MEMBERS_OTHER);
  }
}
