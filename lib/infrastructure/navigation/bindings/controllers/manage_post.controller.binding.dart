import 'package:get/get.dart';

import '../../../../presentation/screens/club/club_profile/manage_post/controllers/manage_post.controller.dart';
import '../../../../presentation/screens/club/club_profile/manage_post/controllers/post_filter_controller.dart';
import '../../routes.dart';

class ManagePostControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManagePostController>(
      () => ManagePostController(),
        tag: Routes.MANAGE_POST
    );

    Get.lazyPut<PostFilterController>(
      () => PostFilterController(),
        tag: Routes.POST_FILTER_BOTTOMSHEET
    );
  }
}
