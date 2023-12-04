import 'package:get/get.dart';

import '../../../../presentation/screens/image_preview/controllers/image_preview.controller.dart';
import '../../routes.dart';

class ImagePreviewControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImagePreviewController>(() => ImagePreviewController(),
        tag: Routes.IMAGE_PREVIEW);
  }
}
