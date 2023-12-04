import 'package:get/get.dart';

import '../../../../presentation/screens/follow_unfollow/follow_unfollow.controller.dart';
import '../../../../presentation/screens/home/club_player_detail/controllers/club_player_detail.controller.dart';
import '../../routes.dart';

class ClubPlayerDetailControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClubPlayerDetailController>(
      () => ClubPlayerDetailController(),
        tag: Routes.CLUB_PLAYER_DETAIL
    );

    Get.lazyPut<FollowUnfollowController>(
            () => FollowUnfollowController(),
    );
  }
}
