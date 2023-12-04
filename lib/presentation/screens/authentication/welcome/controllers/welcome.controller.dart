import 'package:game_on_flutter/infrastructure/navigation/routes.dart';
import 'package:get/get.dart';

import '../../../../../infrastructure/navigation/route_config.dart';

class WelcomeController extends GetxController {
  /// navigate to role selection screen
  void onButtonClick({required bool isSignUp}) => isSignUp
      ? Get.toNamed(Routes.ROLE_SELECTION,
          arguments: {RouteArguments.signUpRequest: isSignUp})
      : Get.toNamed(Routes.LOGIN);
}
