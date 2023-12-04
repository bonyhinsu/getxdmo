import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';

import '../../../../../infrastructure/network/network_config.dart';

class MasterDataProvider extends DioClient{

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for get sports type.
  Future<Response> getSportType() async {
    return getBaseApi(
      url: NetworkAPI.sportsType,
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : get
  /// Detail : Api for get levels.
  Future<Response> getLevel() async {
    return getBaseApi(
      url: NetworkAPI.levels,
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : get
  /// Detail : Api for get location
  Future<Response> getLocations() async {
    return getBaseApi(
      url: NetworkAPI.locations,
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : get
  /// Detail : Api for get player type.
  Future<Response> getPlayerType() async {
    return getBaseApi(
      url: NetworkAPI.playerType,
    );
  }

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