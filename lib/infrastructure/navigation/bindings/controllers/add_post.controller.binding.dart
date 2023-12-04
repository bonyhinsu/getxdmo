import 'package:get/get.dart';

import '../../../../presentation/screens/club/add_post/controllers/add_post.controller.dart';
import '../../routes.dart';

class AddPostControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddPostController>(() => AddPostController(),
        tag: Routes.ADD_POST);
  }
}
