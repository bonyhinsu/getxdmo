import 'package:get/get.dart';

import '../../../../presentation/screens/player/player_club_search/controllers/player_club_search.controller.dart';
import '../../routes.dart';

class PlayerClubSearchControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlayerClubSearchController>(
      () => PlayerClubSearchController(),
        tag: Routes.PLAYER_CLUB_SEARCH
    );
  }
}
