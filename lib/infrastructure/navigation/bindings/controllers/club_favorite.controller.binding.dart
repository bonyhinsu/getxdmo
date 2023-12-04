import 'package:get/get.dart';

import '../../../../presentation/screens/club/club_favorite/controllers/club_favorite.controller.dart';

class ClubFavoriteControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClubFavoriteController>(
      () => ClubFavoriteController(),
    );
  }
}
