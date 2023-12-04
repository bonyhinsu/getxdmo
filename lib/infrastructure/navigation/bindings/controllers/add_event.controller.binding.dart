import 'package:get/get.dart';

import '../../../../presentation/screens/club/add_event/controllers/add_event.controller.dart';
import '../../routes.dart';

class AddEventControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddEventController>(
      () => AddEventController(),
        tag: Routes.ADD_EVENT
    );
  }
}
