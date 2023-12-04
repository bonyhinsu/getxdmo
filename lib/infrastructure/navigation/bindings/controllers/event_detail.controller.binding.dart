import 'package:get/get.dart';

import '../../../../presentation/screens/player/event_detail/controllers/event_detail.controller.dart';
import '../../routes.dart';

class EventDetailControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EventDetailController>(
      () => EventDetailController(),
        tag: Routes.EVENT_DETAIL
    );
  }
}
