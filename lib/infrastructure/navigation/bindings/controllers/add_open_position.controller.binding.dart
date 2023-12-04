import 'package:get/get.dart';

import '../../../../presentation/screens/club/add_open_position/controllers/add_open_position.controller.dart';
import '../../routes.dart';

class AddOpenPositionControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddOpenPositionController>(
      () => AddOpenPositionController(),tag: Routes.ADD_OPEN_POSITION
    );
  }
}
