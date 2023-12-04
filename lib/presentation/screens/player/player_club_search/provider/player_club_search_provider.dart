import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';

import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../values/app_constant.dart';

class PlayerClubSearchProvider extends DioClient {
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for get user filter based on input string
  Future<Response> getSearchUsers() async {
    final Map<String, String> body = {};
    return postApiWithoutHeader(
      url: NetworkAPI.login,
      data: body,
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : get
  /// Detail : Api for fetch club list
  Future<Response> getClubList(List<int> postTypeIds, int pageKey,
      {String search = ''}) async {
    final Map<String, dynamic> body = {
      NetworkParams.limit: AppConstants.paginationPageSize,
      NetworkParams.offset: pageKey,
      // filter post by filter type.
      if (postTypeIds.isNotEmpty) NetworkParams.postTypeId: postTypeIds,

      // search post based on user input.
      if (search.isNotEmpty) NetworkParams.name: search
    };
    return getBaseApi(url: NetworkAPI.clubList, queryParameters: body);
  }


}