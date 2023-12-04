import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';

import '../../../../../../infrastructure/network/network_config.dart';

class PreferredPositionProvider extends DioClient {
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : get
  /// Detail : Api for get preferred position for player.
  Future<Response> getPreferredPositionFromSports(
      {required String sportsType}) async {
    return getBaseApi(
      url: '${NetworkAPI.getPositionBySportType}/$sportsType',
    );
  }
}
