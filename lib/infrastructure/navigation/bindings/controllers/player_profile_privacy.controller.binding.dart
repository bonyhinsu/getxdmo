import 'package:game_on_flutter/presentation/screens/player/player_profile_privacy/profile_hide_preference_bottomsheet.dart';
import 'package:get/get.dart';

import '../../../../presentation/screens/player/player_profile_privacy/controllers/player_profile_privacy.controller.dart';
import '../../../../presentation/screens/player/player_profile_privacy/profile_hide_preference_bottomsheet_controller.dart';
import '../../../../presentation/screens/player/player_profile_privacy/select_club/controllers/select_club.controller.dart';
import '../../routes.dart';

class PlayerProfilePrivacyControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlayerProfilePrivacyController>(tag: Routes.PLAYER_PROFILE_PRIVACY,
      () => PlayerProfilePrivacyController(),
    );
    Get.lazyPut<ProfileHidePreferenceBottomsheetController>(tag: Routes.PROFILE_HIDE_PREFERENCE_BOTTOMSHEET,
      () => ProfileHidePreferenceBottomsheetController(),
    );
    Get.lazyPut<SelectClubController>(
            () => SelectClubController(),tag: Routes.SELECT_CLUB
    );
  }
}
