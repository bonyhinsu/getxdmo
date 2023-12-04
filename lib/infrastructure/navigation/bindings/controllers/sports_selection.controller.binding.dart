import 'package:get/get.dart';

import '../../../../presentation/screens/club/signup/sports_selection/controllers/sports_selection.controller.dart';
import '../../routes.dart';

class SportsSelectionControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SportsSelectionController>(() => SportsSelectionController(),
        tag: Routes.SPORT_TYPE);
  }
}
