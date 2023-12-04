import 'package:get/get.dart';

import '../../../../presentation/screens/player/player_favourite_selection/controllers/add_favourite_item_controller.dart';
import '../../../../presentation/screens/player/player_favourite_selection/controllers/player_favourite_selection.controller.dart';
import '../../routes.dart';

class PlayerFavouriteSelectionControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlayerFavouriteSelectionController>(
        () => PlayerFavouriteSelectionController(),
        tag: Routes.PLAYER_FAVOURITE_SELECTION);
  }
}
