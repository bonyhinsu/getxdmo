import 'package:get/get.dart';

import '../../../../presentation/screens/club/club_profile/controllers/user_detail_controller.dart';
import '../../../../presentation/screens/player/register_player_detail/controllers/register_player_detail.controller.dart';
import '../../../../values/app_constant.dart';
import '../../routes.dart';

class RegisterPlayerDetailControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterPlayerDetailController>(
      () => RegisterPlayerDetailController(),
        tag: Routes.REGISTER_PLAYER_DETAIL
    );

    Get.putAsync<UserDetailService>(() async => UserDetailService(),
        permanent: true, tag: AppConstants.USER_DETAILS);
  }
}
