import 'package:game_on_flutter/infrastructure/network/network_connectivity.dart';
import 'package:get/get.dart';
import 'package:restart_app/restart_app.dart';

import '../../../infrastructure/navigation/routes.dart';

class NoInternetController extends GetxController {
  @override
  void onInit() {
    NetworkConnectivity.instance.hideNoInternetFlushbar();
    super.onInit();
  }

  /// Retry click.
  void onRetryClick() {
    Restart.restartApp(webOrigin: Routes.SPLASH);
  }
}
