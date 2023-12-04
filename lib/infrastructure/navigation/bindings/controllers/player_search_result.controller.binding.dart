import 'package:get/get.dart';

import '../../../../presentation/screens/player/player_club_search_result/controllers/player_club_search_result.controller.dart';
import '../../routes.dart';

class PlayerSearchResultControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlayerClubSearchResultController>(
      () => PlayerClubSearchResultController(),
        tag: Routes.PLAYER_SEARCH_RESULT);
  }
}
