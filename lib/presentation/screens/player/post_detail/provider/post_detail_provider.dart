import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';

import '../../../../../infrastructure/network/network_config.dart';

class PostDetailProvider extends DioClient{
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : get
  /// Detail : Api for get post details.
  Future<Response> getPostDetail({required int postId}) async {
    return getBaseApi(
      url: "${NetworkAPI.post}/$postId",
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for delete post.
  Future<Response> deletePostAPI({required String postId}) async {
    return deleteBaseApi(
      url: "${NetworkAPI.post}/$postId",
    );
  }
}