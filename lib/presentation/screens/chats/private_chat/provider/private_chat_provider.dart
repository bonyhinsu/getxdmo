import 'dart:io';

import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';

import '../../../../../infrastructure/network/network_config.dart';

class PrivateChatProvider extends DioClient{
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : POST
  /// Detail : Api for upload attachment image.
  Future<Response> uploadUserAttachment(File? image) async {
    String imagePath = (image ?? File('')).path.split('/').last;
    final map = {
      /// Profile picture
      if ((image?.path ?? "").isNotEmpty)
        'image': await MultipartFile.fromFile(
            image!.path,
            filename: imagePath),
    };
    FormData formData = FormData.fromMap(map);
    return patchBaseApiForMultipart(
        url: "${NetworkAPI.userDetails}/uploadUserImage",
        data: formData
    );
  }

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