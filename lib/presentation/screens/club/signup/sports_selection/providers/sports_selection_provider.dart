import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';

import '../../../../../../infrastructure/network/network_config.dart';

class SportsSelectionProvider extends DioClient {
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for get sports type.
  Future<Response> getSportType() async {
    return getBaseApi(
      url: NetworkAPI.sportsType,
    );
  }
}
