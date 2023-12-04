import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';

import '../../../../../infrastructure/network/network_config.dart';

class ClubDetailProvider extends DioClient{
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for get club details.
  Future<Response> getUserDetail({required String clubId}) async {
    return getBaseApi(
      url: "${NetworkAPI.userDetails}/$clubId",
    );
  }
}