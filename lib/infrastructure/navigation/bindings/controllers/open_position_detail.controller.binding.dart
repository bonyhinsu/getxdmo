import 'package:get/get.dart';

import '../../../../presentation/screens/player/open_position_detail/controllers/open_position_detail.controller.dart';
import '../../routes.dart';

class OpenPositionDetailControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OpenPositionDetailController>(
      () => OpenPositionDetailController(),
        tag: Routes.OPEN_POSITION_DETAIL
    );
  }
}
