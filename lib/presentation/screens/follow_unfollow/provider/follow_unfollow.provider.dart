import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';

import '../../../../infrastructure/network/network_config.dart';

class FollowUnfollowProvider extends DioClient{

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for unfollow user.
  Future<Response> followUnfollowUser({required String userId}) async {
    final Map<String, String> body = {};
    return postApiWithoutHeader(
      url: '${NetworkAPI.followUnfollow}/$userId',
      data: body,
    );
  }
}