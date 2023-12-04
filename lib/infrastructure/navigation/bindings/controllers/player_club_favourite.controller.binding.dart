import 'package:get/get.dart';

import '../../../../presentation/screens/player/player_club_favourite/controllers/player_club_favourite.controller.dart';

class PlayerClubFavouriteControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlayerClubFavouriteController>(
      () => PlayerClubFavouriteController(),
    );
  }
}
