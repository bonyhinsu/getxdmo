import 'package:flutter/scheduler.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:get/get.dart';

import '../../../../../infrastructure/model/club/post/create_post_menu_model.dart';
import '../../../../../infrastructure/navigation/routes.dart';

class CreatePostBottomsheetController extends GetxController {
  List<CreatePostMenuModel> createPostMenuList = [];

  @override
  void onInit() {
    _createBottomSheetMenu();
    super.onInit();
  }

  /// Create bottomSheet menu item
  void _createBottomSheetMenu() {
    createPostMenuList.addAll([
      CreatePostMenuModel(
        title: AppString.strEvent,
        routePath: Routes.ADD_EVENT,
      ),
      CreatePostMenuModel(
        title: AppString.strEventNew,
        routePath: Routes.ADD_POST,
      ),
      CreatePostMenuModel(
        title: AppString.strResult,
        routePath: Routes.ADD_RESULT,
      ),
      CreatePostMenuModel(
        title: AppString.strOpenPositions,
        routePath: Routes.ADD_OPEN_POSITION,
      ),
    ]);
  }

  /// Menu click event.
  ///
  /// required [CreatePostMenuModel].
  void onClickMenu(CreatePostMenuModel model) {
    Get.until((route) => route.settings.name == Routes.CLUB_MAIN);
    Future.delayed(const Duration(milliseconds: 200), () {
      // SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Get.toNamed(model.routePath);
      // });
    });
  }
}
