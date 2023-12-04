import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';

import '../../../../../../infrastructure/network/network_config.dart';

class ClubLocationProvider extends DioClient {
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : get
  /// Detail : Api for get location
  Future<Response> getLocations() async {
    return getBaseApi(
      url: NetworkAPI.locations,
    );
  }
}
