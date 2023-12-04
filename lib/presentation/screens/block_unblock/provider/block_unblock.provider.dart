import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';

import '../../../../infrastructure/network/network_config.dart';

class BlockUnblockProvider extends DioClient{
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for block user.
  Future<Response> blockUser({required String userId}) async {
    return postBaseApi(
      url: '${NetworkAPI.blockUser}/$userId',
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : get
  /// Detail : Api for check block status between current user and other user.
  Future<Response> checkForBlockStatus({required String userId}) async {
    return getBaseApi(
      url: '${NetworkAPI.checkIsUserBlock}/$userId',
    );
  }


}