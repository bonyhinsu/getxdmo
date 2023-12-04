import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';

import '../../../../../infrastructure/network/network_config.dart';

class ClubPlayerDetailProvider extends DioClient {
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for get user details.
  Future<Response> getUserDetail({required String userId}) async {
    return getBaseApi(
      url: "${NetworkAPI.userDetails}/$userId",
    );
  }


}
