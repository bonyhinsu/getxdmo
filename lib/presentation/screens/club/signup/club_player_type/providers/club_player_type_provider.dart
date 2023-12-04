import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';

import '../../../../../../infrastructure/network/network_config.dart';

class ClubPlayerTypeProvider extends DioClient {
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : get
  /// Detail : Api for get player type.
  Future<Response> getPlayerType() async {
    return getBaseApi(
      url: NetworkAPI.playerType,
    );
  }
}
