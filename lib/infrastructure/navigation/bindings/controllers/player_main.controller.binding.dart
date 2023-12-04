import 'package:get/get.dart';

import '../../../../presentation/screens/authentication/general_data/controllers/app_master_data.controller.dart';
import '../../../../presentation/screens/chats/chat_main/controllers/chat_main.controller.dart';
import '../../../../presentation/screens/club/club_favorite/controllers/club_data_provider_controller.dart';
import '../../../../presentation/screens/club/club_favorite/favorite_bottomsheet_controller.dart';
import '../../../../presentation/screens/club/club_profile/controllers/club_profile.controller.dart';
import '../../../../presentation/screens/club/club_profile/controllers/user_detail_controller.dart';
import '../../../../presentation/screens/club/search_result/controllers/user_filter_menu_controller.dart';
import '../../../../presentation/screens/player/player_club_favourite/controllers/player_club_favourite.controller.dart';
import '../../../../presentation/screens/player/player_home/controllers/player_favourite_filter_controller.dart';
import '../../../../presentation/screens/player/player_home/controllers/player_home.controller.dart';
import '../../../../presentation/screens/player/player_main/controllers/player_main.controller.dart';
import '../../../../presentation/screens/player/player_profile/controllers/player_profile.controller.dart';
import '../../../../values/app_constant.dart';
import '../../routes.dart';

class PlayerMainControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.putAsync<UserDetailService>(() async => UserDetailService(),
        permanent: true, tag: AppConstants.USER_DETAILS);

    Get.lazyPut<PlayerMainController>(() => PlayerMainController(),
        tag: Routes.PLAYER_MAIN);

    Get.lazyPut<PlayerClubFavouriteController>(
        () => PlayerClubFavouriteController(),
        tag: Routes.PLAYER_FAVOURITE_CLUB);

    Get.lazyPut<FavoriteBottomsheetController>(
        () => FavoriteBottomsheetController(),
        tag: Routes.FAVORITE_FILTER);

    Get.lazyPut<ClubProfileController>(() => ClubProfileController(),
        tag: Routes.CLUB_PROFILE);

    Get.lazyPut<ChatMainController>(() => ChatMainController(),
        tag: Routes.CHAT_MAIN);

    Get.lazyPut<PlayerHomeController>(() => PlayerHomeController(),
        tag: Routes.PLAYER_HOME);

    Get.lazyPut<PlayerProfileController>(() => PlayerProfileController(),
        tag: Routes.PLAYER_PROFILE);

    Get.lazyPut<PlayerFavouriteFilterController>(() => PlayerFavouriteFilterController(),
        tag: Routes.PLAYER_FILTER_DATA_PROVIDER);

    Get.lazyPut<ClubDataProviderController>(() => ClubDataProviderController(),
        tag: Routes.CLUB_DATA_PROVIDER);

    Get.lazyPut<MasterDataController>(() => MasterDataController(),
        tag: Routes.MASTER_DATA_PROVIDER);

    Get.lazyPut<UserFilterMenuController>(() => UserFilterMenuController(),
        tag: Routes.CLUB_PLAYER_FILTER);
  }
}
