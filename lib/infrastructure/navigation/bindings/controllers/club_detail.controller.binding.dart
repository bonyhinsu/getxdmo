import 'package:get/get.dart';

import '../../../../presentation/screens/follow_unfollow/follow_unfollow.controller.dart';
import '../../../../presentation/screens/player/club_detail/controllers/club_detail.controller.dart';
import '../../routes.dart';

class ClubDetailControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClubDetailController>(
      () => ClubDetailController(),
        tag: Routes.CLUB_DETAIL
    );

    Get.lazyPut<FollowUnfollowController>(
          () => FollowUnfollowController(),
    );
  }
}
