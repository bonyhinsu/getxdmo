import 'package:get/get.dart';

import '../../../../presentation/screens/player/post_detail/controllers/post_detail.controller.dart';
import '../../routes.dart';

class PostDetailControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostDetailController>(
      () => PostDetailController(),
        tag: Routes.POST_DETAIL
    );
  }
}
