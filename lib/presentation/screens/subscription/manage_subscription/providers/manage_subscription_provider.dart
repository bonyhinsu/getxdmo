import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';
import 'package:get_it/get_it.dart';

import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/storage/preference_manager.dart';

class ManageSubscriptionProvider extends DioClient {
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : get
  /// Detail : Api for fetch user active subscription plan.
  Future<Response> getUserActiveSubscription() async {
    return getBaseApi(
      url:
          '${NetworkAPI.getSelectedSportType}/${GetIt.I<PreferenceManager>().userId}',
    );
  }
}
