import 'package:get/get.dart';

import '../../../../presentation/screens/player/sign_up/preffered_position/controllers/preffered_position.controller.dart';
import '../../routes.dart';

class PrefferedPositionControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrefferedPositionController>(
      () => PrefferedPositionController(),
        tag: Routes.PREFFERED_POSITION
    );
  }
}
