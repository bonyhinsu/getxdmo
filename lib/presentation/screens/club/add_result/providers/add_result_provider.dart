import 'dart:io';

import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';

import '../../../../../infrastructure/model/club/post/post_list_model.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../values/app_constant.dart';

class AddResultProvider extends DioClient {
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for add new result for club.
  Future<Response> addResult(
      {required String title,
      required String date,
      required String location,
      required String score,
      required String participantsA,
      required String participantsB,
      required String highLights,
      required String otherDetails,
      required PostImages eventImage}) async {
    final Map<String, dynamic> body = {
      NetworkParams.type: AppConstants.postTypeResult,
      NetworkParams.postTypeId: AppConstants.postTypeIdResult,
      NetworkParams.title: title,
      NetworkParams.selectDate: date,
      NetworkParams.highlights: highLights,
      NetworkParams.location: location,
      NetworkParams.participantsA: participantsA,
      NetworkParams.participantsB: participantsB,
      NetworkParams.otherDetails: otherDetails,
      NetworkParams.score: score
    };

    if ((eventImage.image ?? "").isNotEmpty) {
      final pickedFile = File(eventImage.image ?? "");
      String fileName = pickedFile.path.split('/').last;
      final multipartFile =
          await MultipartFile.fromFile(pickedFile.path, filename: fileName);
      body.addAll({NetworkParams.image: multipartFile});

      // Add Delay while preparing multipart image.
      await Future.delayed(
        const Duration(milliseconds: 300),
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
  /// Method : path
  /// Detail : Api for update result for club.
  Future<Response> updateResult(
      {required String itemId,
      required String title,
      required String date,
      required String location,
      required String score,
      required String participantsA,
      required String participantsB,
      required String highLights,
      required String otherDetails,
      required PostImages eventImage}) async {
    final Map<String, dynamic> body = {
      NetworkParams.type: AppConstants.postTypeResult,
      NetworkParams.postTypeId: AppConstants.postTypeIdResult,
      NetworkParams.title: title,
      NetworkParams.selectDate: date,
      NetworkParams.highlights: highLights,
      NetworkParams.location: location,
      NetworkParams.participantsA: participantsA,
      NetworkParams.participantsB: participantsB,
      NetworkParams.otherDetails: otherDetails,
      NetworkParams.score: score
    };

    if (eventImage.deletedImageUrl.isNotEmpty) {
      body.addAll({NetworkParams.deleteBannerImage: eventImage.deletedImageUrl});
    }

    if ((eventImage.image ?? "").isNotEmpty) {
      if (eventImage.isUrl == false) {
        final pickedFile = File(eventImage.image ?? "");
        String fileName = pickedFile.path.split('/').last;
        final multipartFile =
            await MultipartFile.fromFile(pickedFile.path, filename: fileName);
        body.addAll({NetworkParams.image: multipartFile});

        // Add Delay while preparing multipart image.
        await Future.delayed(
          const Duration(milliseconds: 300),
        );
      } else {
        body.addAll({NetworkParams.image: eventImage.image});
      }
    } else {
      body.addAll({NetworkParams.image: ''});
    }
    FormData formData = FormData.fromMap(body);

    return patchBaseApiForMultipart(
      url: "${NetworkAPI.post}/$itemId",
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
