import 'package:get/get.dart';

import '../../../../presentation/screens/club/signup/club_board_members/controllers/club_board_members.controller.dart';
import '../../routes.dart';

class ClubBoardMembersControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClubBoardMembersController>(
      () => ClubBoardMembersController(),
        tag: Routes.CLUB_BOARD_MEMBERS
    );
    Get.lazyPut<ClubBoardMembersController>(
            () => ClubBoardMembersController(),
        tag: Routes.CLUB_BOARD_MEMBERS_DIRECTORS
    );
    Get.lazyPut<ClubBoardMembersController>(
            () => ClubBoardMembersController(),
        tag: Routes.CLUB_BOARD_MEMBERS_PRESIDENT
    );
  }
}
