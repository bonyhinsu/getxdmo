import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';

import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../values/app_constant.dart';

class BlockedUsersProvider extends DioClient{
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for block user.
  Future<Response> getBlockedUserList({required int pageKey,}) async {
    final Map<String, dynamic> body = {
      NetworkParams.limit: AppConstants.paginationPageSize,
      NetworkParams.offset: pageKey,
    };
    return getBaseApi(
      url: NetworkAPI.blockedUserList,
        queryParameters: body
    );
  }
}