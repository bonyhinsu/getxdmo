import 'package:get/get.dart';

import '../../../../infrastructure/navigation/routes.dart';
import '../../../../presentation/screens/club/signup/club_level/controllers/club_level.controller.dart';
import 'favorite_bottomsheet_controller.dart';

class FavoriteBottomsheetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavoriteBottomsheetController>(
      () => FavoriteBottomsheetController(),
        tag: Routes.FAVORITE_FILTER
    );
  }
}
