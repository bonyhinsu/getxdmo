import 'package:get/get.dart';

import '../../../../presentation/screens/authentication/verify/controllers/verify.controller.dart';
import '../../../../presentation/screens/club/club_profile/controllers/user_detail_controller.dart';
import '../../../../values/app_constant.dart';
import '../../routes.dart';

class VerifyControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifyController>(
      () => VerifyController(),
      tag: Routes.VERIFY
    );

    Get.putAsync<UserDetailService>(() async => UserDetailService(),
        permanent: true, tag: AppConstants.USER_DETAILS);
  }
}
