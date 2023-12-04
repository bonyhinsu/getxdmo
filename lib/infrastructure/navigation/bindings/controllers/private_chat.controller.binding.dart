import 'package:get/get.dart';

import '../../../../presentation/screens/block_unblock/controller/block_unblock.controller.dart';
import '../../../../presentation/screens/chats/private_chat/controllers/private_chat.controller.dart';
import '../../../../presentation/screens/chats/private_chat/controllers/report_user.controller.dart';
import '../../../../presentation/screens/follow_unfollow/follow_unfollow.controller.dart';
import '../../../../presentation/screens/report_user/controller/report_app_user.controller.dart';
import '../../routes.dart';

class PrivateChatControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrivateChatController>(() => PrivateChatController(),
        tag: Routes.PRIVATE_CHAT);
    Get.lazyPut<FollowUnfollowController>(
      () => FollowUnfollowController(),
    );
    Get.lazyPut<BlockUnblockController>(
      () => BlockUnblockController(),
    );

    Get.lazyPut<ReportUserController>(() => ReportUserController(),
        tag: Routes.REPORT_USER);

    Get.lazyPut<ReportAppUserController>(
      () => ReportAppUserController(),
    );
  }
}
