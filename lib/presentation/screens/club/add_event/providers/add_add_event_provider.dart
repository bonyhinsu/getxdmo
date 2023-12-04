import 'dart:io';

import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/model/club/post/post_list_model.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';

import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../values/app_constant.dart';

class AddAddEventProvider extends DioClient {
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for fetch sport API.
  Future<Response> addEvent(
      {required String title,
      required String time,
      required String date,
      required String location,
      required String typeOfEvent,
      required String otherDetails,
      required PostImages eventImage}) async {
    final Map<String, dynamic> body = {
      NetworkParams.type: AppConstants.postTypeEvent,
      NetworkParams.postTypeId: AppConstants.postTypeIdEvent,
      NetworkParams.title: title,
      NetworkParams.selectDate: date,
      NetworkParams.selectTime: time,
      NetworkParams.location: location,
      NetworkParams.typeOfEvent: typeOfEvent,
      NetworkParams.otherDetails: otherDetails,
    };

    if ((eventImage.image ?? "").isNotEmpty) {
      if (eventImage.isUrl == false) {
        final element = File((eventImage.image ?? ""));
        String fileName = element.path.split('/').last;
        final multipartFile =
            await MultipartFile.fromFile(element.path, filename: fileName);
        body.addAll({NetworkParams.image: multipartFile});
      }

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
  /// Detail : Api for update event for club.
  Future<Response> updateEvent(
      {required String itemId,
      required String title,
      required String time,
      required String date,
      required String location,
      required String typeOfEvent,
      required String otherDetails,
      required PostImages eventImage}) async {
    final Map<String, dynamic> body = {
      NetworkParams.type: AppConstants.postTypeEvent,
      NetworkParams.postTypeId: AppConstants.postTypeIdEvent,
      NetworkParams.title: title,
      NetworkParams.selectDate: date,
      NetworkParams.selectTime: time,
      NetworkParams.location: location,
      NetworkParams.typeOfEvent: typeOfEvent,
      NetworkParams.otherDetails: otherDetails,
    };

    if ((eventImage.image ?? "").isNotEmpty) {
      if (eventImage.isUrl == false) {
        final element = File((eventImage.image ?? ""));
        String fileName = element.path.split('/').last;
        final multipartFile =
            await MultipartFile.fromFile(element.path, filename: fileName);
        body.addAll({NetworkParams.image: multipartFile});
      } else {
        body.addAll({NetworkParams.image: (eventImage.image ?? "")});
      }

      // Add Delay while preparing multipart image.
      await Future.delayed(
        const Duration(milliseconds: 300),
      );
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
