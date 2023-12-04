import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';

import '../../../../../../infrastructure/network/network_config.dart';

class ClubLevelProvider extends DioClient{
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : get
  /// Detail : Api for get levels.
  Future<Response> getLevel() async {
    return getBaseApi(
      url: NetworkAPI.levels,
    );
  }
}
