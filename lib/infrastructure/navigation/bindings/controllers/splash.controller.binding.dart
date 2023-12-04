import 'package:get/get.dart';

import '../../../../presentation/screens/splash/controllers/splash.controller.dart';
import '../../../../values/app_constant.dart';
import '../../../network/services/app_settings_service.dart';

class SplashControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(
      () => SplashController(),
    );

    /// Inject device info service
    Get.lazyPut(() => AppSettingsService(),
        tag: AppConstants.APP_SETTINGS);
  }
}
