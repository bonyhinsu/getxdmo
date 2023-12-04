import 'package:game_on_flutter/infrastructure/storage/preference_manager.dart';
import 'package:game_on_flutter/values/app_constant.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../../infrastructure/navigation/route_config.dart';
import '../../../../../infrastructure/navigation/routes.dart';

class RoleSelectionController extends GetxController {
  RxInt selectedIndex = (-1).obs;

  bool _isSignUp = false;

  @override
  void onInit() {
    _getArguments();
    super.onInit();
  }

  /// Receive arguments from previous screen.
  void _getArguments() {
    if (Get.arguments != null) {
      _isSignUp = Get.arguments[RouteArguments.signUpRequest] ?? false;
    }
  }

  /// On select player.
  void onSelectPlayer() {
    selectedIndex.value = 1;
    _resetAndNavigate();
  }

  /// On select club
  void onSelectClub() {
    selectedIndex.value = 2;
    _resetAndNavigate();
  }

  /// Reset and navigate to next screen.
  void _resetAndNavigate() {
    Future.delayed(
        const Duration(
          milliseconds: 100,
        ), () {
      final selectedRole = selectedIndex.value;
      selectedIndex.value = -1;

      GetIt.I<PreferenceManager>().setUserType(selectedRole == 2
          ? AppConstants.userTypeClub
          : AppConstants.userTypePlayer);

      if (_isSignUp) {
        Get.toNamed(Routes.SPORT_TYPE);
      } else {
        Get.toNamed(Routes.LOGIN);
      }
    });
  }
}
