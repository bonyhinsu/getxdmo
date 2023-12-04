import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';

import '../../../infrastructure/network/network_config.dart';

class AppSettingsProvider extends DioClient {
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for get application settings type.
  Future<Response> getSettings() async {
    return getApiWithoutHeader(
      url: NetworkAPI.settings,
    );
  }
}
