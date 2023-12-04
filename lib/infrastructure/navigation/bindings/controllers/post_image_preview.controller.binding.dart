import 'package:get/get.dart';

import '../../../../presentation/screens/club/add_post/post_image_preview/controllers/post_image_preview.controller.dart';
import '../../routes.dart';

class PostImagePreviewControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostImagePreviewController>(
      () => PostImagePreviewController(),
      tag: Routes.POST_IMAGE_PREVIEW
    );
  }
}
