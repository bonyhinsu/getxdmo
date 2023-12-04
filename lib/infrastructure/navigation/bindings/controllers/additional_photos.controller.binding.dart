import 'package:get/get.dart';

import '../../../../presentation/screens/player/additional_photos/controllers/additional_photos.controller.dart';
import '../../routes.dart';

class AdditionalPhotosControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdditionalPhotosController>(
      () => AdditionalPhotosController(),
        tag: Routes.ADDITIONAL_PHOTOS
    );
  }
}
