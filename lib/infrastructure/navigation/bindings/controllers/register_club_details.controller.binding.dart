import 'package:get/get.dart';

import '../../../../presentation/screens/club/signup/register_club_details/controllers/register_club_details.controller.dart';
import '../../routes.dart';

class RegisterClubDetailsControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterClubDetailsController>(() => RegisterClubDetailsController(),
        tag: Routes.REGISTER_CLUB_DETAILS);
  }
}
