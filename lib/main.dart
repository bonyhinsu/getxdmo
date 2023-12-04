import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_on_flutter/infrastructure/storage/preference_manager.dart';
import 'package:game_on_flutter/presentation/screens/club/search_result/filter_provider.dart';
import 'package:game_on_flutter/values/app_constant.dart';
import 'package:game_on_flutter/values/common_utils.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'config/environment.dart';
import 'game_on_app.dart';
import 'infrastructure/firebase/firestore_manager.dart';
import 'infrastructure/model/common/app_fields.dart';
import 'infrastructure/network/api_utils.dart';
import 'infrastructure/network/services/device_info_service.dart';

final logger = Logger();

// This is our global ServiceLocator
GetIt getIt = GetIt.instance;

void main() async {
  const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: Environment.development,
  );

  Environment().initConfig(environment);

  WidgetsFlutterBinding.ensureInitialized();

  setupLocator();

  await _prepareGlobalServices();

  runApp(Provider(
      create: (context) => FilterItemProvider(),
      child: const GameOnApplication()));
}

/// Prepare global services.
Future<void> _prepareGlobalServices() async {
  try {
    /// Inject device info service
    await Get.putAsync(() => DeviceInfoService().initService(),
        tag: AppConstants.DEVICE_INFO_KEY);

    /// set system orientation as portrait.
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  } catch (ex) {
    print(ex.toString());
  }
}

/// Register getit dependency classes.
void setupLocator() {
  getIt.registerSingleton<PreferenceManager>(PreferenceManager());
  getIt.registerSingleton<CommonUtils>(CommonUtils());
  getIt.registerSingleton<ApiUtils>(ApiUtils.instance);
  getIt.registerSingleton<AppFields>(AppFields.instance);
  getIt.registerSingleton<FireStoreManager>(FireStoreManager());

  GetIt.I<PreferenceManager>().initPreference();
}
