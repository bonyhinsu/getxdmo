import 'package:game_on_flutter/presentation/screens/club/club_favorite/controllers/club_favorite.controller.dart';
import 'package:game_on_flutter/presentation/screens/player/player_profile/controllers/player_profile.controller.dart';
import 'package:get/get.dart';

import '../../../../presentation/screens/authentication/general_data/controllers/app_master_data.controller.dart';
import '../../../../presentation/screens/chats/chat_main/controllers/chat_main.controller.dart';
import '../../../../presentation/screens/club/club_favorite/controllers/club_data_provider_controller.dart';
import '../../../../presentation/screens/club/club_favorite/favorite_bottomsheet_controller.dart';
import '../../../../presentation/screens/club/club_main/controllers/club_main.controller.dart';
import '../../../../presentation/screens/club/club_profile/controllers/club_profile.controller.dart';
import '../../../../presentation/screens/club/club_profile/controllers/user_detail_controller.dart';
import '../../../../presentation/screens/club/search_result/controllers/user_filter_menu_controller.dart';
import '../../../../presentation/screens/home/club_home/controllers/club_home_controller.dart';
import '../../../../presentation/screens/home/club_home/controllers/create_post_bottomsheet_controller.dart';
import '../../../../values/app_constant.dart';
import '../../routes.dart';

class ClubMainControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.putAsync<UserDetailService>(() async => UserDetailService(),
        permanent: true, tag: AppConstants.USER_DETAILS);

    Get.lazyPut<ClubMainController>(() => ClubMainController(),
        tag: Routes.CLUB_MAIN);
    Get.lazyPut<ClubProfileController>(() => ClubProfileController(),
        tag: Routes.CLUB_PROFILE);
    Get.lazyPut<PlayerProfileController>(() => PlayerProfileController(),
        tag: Routes.PLAYER_PROFILE);
    Get.lazyPut<ClubHomeController>(() => ClubHomeController(),
        tag: Routes.CLUB_HOME);
    Get.lazyPut<ClubFavoriteController>(() => ClubFavoriteController(),
        tag: Routes.CLUB_FAVORITE);
    Get.lazyPut<ClubMainController>(() => ClubMainController(),
        tag: Routes.CLUB_MAIN);
    Get.lazyPut<ClubProfileController>(() => ClubProfileController(),
        tag: Routes.CLUB_PROFILE);
    Get.lazyPut<ClubHomeController>(() => ClubHomeController(),
        tag: Routes.CLUB_HOME);

    Get.lazyPut<ClubFavoriteController>(() => ClubFavoriteController(),
        tag: Routes.CLUB_FAVORITE);

    Get.lazyPut<FavoriteBottomsheetController>(
        () => FavoriteBottomsheetController(),
        tag: Routes.FAVORITE_FILTER);

    Get.lazyPut<ClubMainController>(() => ClubMainController(),
        tag: Routes.CLUB_MAIN);

    Get.lazyPut<ClubProfileController>(() => ClubProfileController(),
        tag: Routes.CLUB_PROFILE);

    Get.lazyPut<CreatePostBottomsheetController>(
        () => CreatePostBottomsheetController(),
        tag: Routes.CREATE_POST);

    Get.lazyPut<ChatMainController>(() => ChatMainController(),
        tag: Routes.CHAT_MAIN);

    Get.lazyPut<ClubDataProviderController>(() => ClubDataProviderController(),
        tag: Routes.CLUB_DATA_PROVIDER);

    Get.lazyPut<MasterDataController>(() => MasterDataController(),
        tag: Routes.MASTER_DATA_PROVIDER);

    Get.lazyPut<UserFilterMenuController>(() => UserFilterMenuController(),
        tag: Routes.CLUB_PLAYER_FILTER);
  }
}
