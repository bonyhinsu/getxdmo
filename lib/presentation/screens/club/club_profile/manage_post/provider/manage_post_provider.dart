import 'package:collection/collection.dart';
import 'package:dio/dio.dart';

import '../../../../../../infrastructure/network/dio_client.dart';
import '../../../../../../infrastructure/network/network_config.dart';
import '../../../../../../values/app_constant.dart';

class ManagePostProvider extends DioClient {
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for delete post.
  Future<Response> deletePostAPI({required String postId}) async {
    return deleteBaseApi(
      url: "${NetworkAPI.post}/$postId",
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : get
  /// Detail : Api for fetch user post
  Future<Response> getUserPostAPI(List<int> postTypeIds, int pageKey,
      {String search = ''}) async {
    final Map<String, dynamic> body = {
      NetworkParams.limit: AppConstants.paginationPageSize,
      NetworkParams.offset: pageKey,
      // search post based on user input.
      if (search.isNotEmpty) NetworkParams.search: search
    };

    // filter post by filter type.
    if (postTypeIds.isNotEmpty) {
      postTypeIds.forEachIndexed((index, element) {
        body.addAll({'${NetworkParams.postTypeId}[$index]': element});
      });
    }
    return getBaseApi(url: NetworkAPI.post, queryParameters: body);
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


}
