import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';
import 'package:game_on_flutter/values/app_constant.dart';

import '../../../../../infrastructure/model/club/post/post_list_model.dart';
import '../../../../../infrastructure/network/network_config.dart';

class AddPostProvider extends DioClient {
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for add post.
  Future<Response> addClubPost({
    required String otherDetails,
    required List<PostImages> postImages,
  }) async {
    final Map<String, dynamic> body = {
      NetworkParams.type: AppConstants.postTypePost,
      NetworkParams.postTypeId: AppConstants.postTypeIdPost,
      NetworkParams.otherDetails: otherDetails,
    };

    if (postImages.isNotEmpty) {
      postImages.forEachIndexed((index, postImage) async {
        if (!postImage.isUrl) {
          final element = File(postImage.image ?? "");
          String fileName = element.path.split('/').last;
          final multipartFile =
              await MultipartFile.fromFile(element.path, filename: fileName);
          body.addAll({'${NetworkParams.arrayImages}[$index]': multipartFile});
        } else {
          body.addAll(
              {'${NetworkParams.arrayImages}[$index]': postImage.image});
        }
      });

      // Add Delay while preparing multipart image.
      await Future.delayed(
        Duration(milliseconds: 100 * postImages.length),
      );
    }

    FormData formData = FormData.fromMap(body);
    return postBaseApiForMultipart(
      url: NetworkAPI.post,
      data: formData,
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : patch
  /// Detail : Api for update post.
  Future<Response> updateClubPost({
    required String id,
    required String otherDetails,
    required List<PostImages> postImages,
  }) async {
    final Map<String, dynamic> body = {
      NetworkParams.type: AppConstants.postTypePost,
      NetworkParams.postTypeId: AppConstants.postTypeIdPost,
      NetworkParams.otherDetails: otherDetails,
    };

    if (postImages.isNotEmpty) {
      postImages.forEachIndexed((index, postImage) async {
        if (!postImage.isUrl) {
          final element = File(postImage.image ?? "");
          String fileName = element.path.split('/').last;
          final multipartFile =
              await MultipartFile.fromFile(element.path, filename: fileName);
          body.addAll({'${NetworkParams.arrayImages}[$index]': multipartFile});
        }
      });

      // Add Delay while preparing multipart image.
      await Future.delayed(
        Duration(milliseconds: 100 * postImages.length),
      );
    }

    FormData formData = FormData.fromMap(body);
    return patchBaseApiForMultipart(
      url: "${NetworkAPI.post}/$id",
      data: formData,
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for delete post image.
  Future<Response> deletePostImageAPI({required String postId}) async {
    return deleteBaseApi(
      url: "${NetworkAPI.post}/deletePostImage/$postId",
    );
  }
}
