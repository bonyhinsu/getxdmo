import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';

import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../values/app_constant.dart';

class PlayerHomeProvider extends DioClient {
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for delete post.
  Future<Response> deletePostAPI() async {
    final Map<String, String> body = {};
    return postApiWithoutHeader(
      url: NetworkAPI.login,
      data: body,
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for delete post.
  Future<Response> updatePostAPI() async {
    final Map<String, String> body = {};
    return postApiWithoutHeader(
      url: NetworkAPI.login,
      data: body,
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : get
  /// Detail : Api for fetch user post
  Future<Response> getUserPostAPI(List<int> postTypeIds, int pageKey,
      {String search = ''}) async {
    final Map<String, dynamic> body = {
      NetworkParams.offset: pageKey,
      NetworkParams.limit: AppConstants.paginationPageSize,
      // filter post by filter type.
      if (postTypeIds.isNotEmpty) NetworkParams.postTypeId: postTypeIds,

      // search post based on user input.
      if (search.isNotEmpty) NetworkParams.search: search
    };
    return getBaseApi(url: NetworkAPI.getRecentPostList, queryParameters: body);
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : get
  /// Detail : Api fetch post type ids
  Future<Response> getUserPostTypeAPI() async {
    final Map<String, String> body = {};
    return getBaseApi(
      url: NetworkAPI.postFilterType,
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : get
  /// Detail : Api for fetch advertisement.
  Future<Response> getAdvertisement() async {
    return getBaseApi(url: NetworkAPI.getAdvertisement);
  }
}
