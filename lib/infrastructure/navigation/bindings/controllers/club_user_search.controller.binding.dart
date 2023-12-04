import 'package:get/get.dart';

import '../../../../presentation/screens/club/club_user_search/controllers/club_user_search.controller.dart';
import '../../routes.dart';

class ClubUserSearchControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClubUserSearchController>(
      () => ClubUserSearchController(),
        tag: Routes.CLUB_USER_SEARCH
    );
  }
}
