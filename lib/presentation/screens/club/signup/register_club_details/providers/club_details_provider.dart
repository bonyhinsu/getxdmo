import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../infrastructure/network/network_config.dart';
import '../../../../../../infrastructure/storage/preference_manager.dart';
import '../controllers/register_club_details.controller.dart';
import '../model/location_data_model.dart';

class RegisterClubDetailsProvider extends DioClient {
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : patch
  /// Detail : Api for update club detail.
  Future<Response> updateClubDetail({
    required String clubName,
    required String clubPhoneNumber,
    required String clubAddress,
    required String clubEmail,
    required String clubPassword,
    required String clubVideo,
    required String phoneNumber,
    required String address,
    required String type,
    required String introduction,
    required String bio,
    required String referenceAndInfo,
    required int sportTypeId,
    required List<int> playerCategoryDetail,
    required List<int> levelDetail,
    required String uuid,
    required String osVersion,
    required String deviceName,
    required String modelName,
    required String deviceType,
    required String ip,
    required List<int> locationDetail,
    required bool updateAllDetails,
  }) async {
    final Map<String, dynamic> body = {
      NetworkParams.name: clubName,
      NetworkParams.email: clubEmail,
      NetworkParams.phoneNumber: phoneNumber,
      NetworkParams.address: address,
      NetworkParams.video: clubVideo,
      NetworkParams.type: type,
      NetworkParams.introduction: introduction,
      NetworkParams.referenceAndInfo: referenceAndInfo,
      NetworkParams.bio: bio,
      NetworkParams.deviceType: deviceType,
      NetworkParams.uuid: uuid,
      NetworkParams.osVersion: osVersion,
      NetworkParams.deviceName: deviceName,
      NetworkParams.modelName: modelName,
      NetworkParams.ip: ip,
    };

    if (sportTypeId != -1) {
      body.addAll({
        NetworkParams.sportTypeId: sportTypeId,
      });
    }

    if (levelDetail.isNotEmpty) {
      body.addAll({
        NetworkParams.levelDetail: levelDetail,
      });
    }

    if (locationDetail.isNotEmpty) {
      body.addAll({
        NetworkParams.locationDetail: locationDetail,
      });
    }

    if (playerCategoryDetail.isNotEmpty) {
      body.addAll({
        NetworkParams.playerCategoryDetail: playerCategoryDetail,
      });
    }

    return patchBaseApi(
      url:
          "${NetworkAPI.updateUserDetails}/${GetIt.I<PreferenceManager>().userId}",
      data: body,
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for register club.
  Future<Response> registerClubDetail({
    required String clubName,
    required String clubPhoneNumber,
    required String clubAddress,
    required String clubEmail,
    required String clubPassword,
    required String clubVideo,
    required String phoneNumber,
    required String address,
    required String type,
    required String introduction,
    required String bio,
    required String referenceAndInfo,
    required int sportTypeId,
    required List<int> playerCategoryDetail,
    required List<int> levelDetail,
    required String uuid,
    required String osVersion,
    required String deviceName,
    required String modelName,
    required String deviceType,
    required String ip,
    required List<LocationDataModel> locationDetail,
  }) async {
    final Map<String, dynamic> body = {
      NetworkParams.name: clubName,
      NetworkParams.email: clubEmail,
      NetworkParams.password: clubPassword,
      NetworkParams.phoneNumber: phoneNumber,
      NetworkParams.address: address,
      NetworkParams.video: clubVideo,
      NetworkParams.type: type,
      NetworkParams.introduction: introduction,
      NetworkParams.referenceAndInfo: referenceAndInfo,
      NetworkParams.bio: bio,
      NetworkParams.deviceType: deviceType,
      NetworkParams.uuid: uuid,
      NetworkParams.osVersion: osVersion,
      NetworkParams.deviceName: deviceName,
      NetworkParams.modelName: modelName,
      NetworkParams.ip: ip,
    };

    if (sportTypeId != -1) {
      body.addAll({
        NetworkParams.sportTypeId: sportTypeId,
      });
    }

    /// level details
    if (levelDetail.isNotEmpty) {
      body.addAll({
        NetworkParams.levelDetail: levelDetail,
      });
    }

    /// locations
    if (locationDetail.isNotEmpty) {
      body.addAll({
        NetworkParams.locationDetail: locationDetail,
      });
    }

    /// Player category
    if (playerCategoryDetail.isNotEmpty) {
      body.addAll({
        NetworkParams.playerCategoryDetail: playerCategoryDetail,
      });
    }

    return postBaseApi(
      url: NetworkAPI.register,
      data: body,
    );
  }

  Future<Response> updateUserProfile(File? profilePicture) async {
    String profilePath = (profilePicture ?? File('')).path.split('/').last;
    final map = {
      /// Profile picture
      if ((profilePicture?.path ?? "").isNotEmpty)
        'profileImage': await MultipartFile.fromFile(profilePicture!.path,
            filename: profilePath),
    };
    FormData formData = FormData.fromMap(map);
    return patchBaseApiForMultipart(
        url: "${NetworkAPI.userDetails}/uploadUserImage", data: formData);
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : POST
  /// Detail : Api for delete user profile image.
  Future<Response> deleteUserProfileImage() async {
    return deleteBaseApi(
      url: "${NetworkAPI.userDetails}/deleteUserImage/${GetIt.I<PreferenceManager>().userId}",
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : POST
  /// Detail : Api for delete user additional image.
  Future<Response> deleteUserAdditionalImage({required int imageId}) async {
    return deleteBaseApi(
      url: "${NetworkAPI.userDetails}/deleteUserPhotos/$imageId",
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : PATCH
  /// Detail : Api for add user profile image and additional image.
  Future<Response> addUserImages({
    required File profilePicture,
    required List<ClubProfileImage> additionalImage,
  }) async {
    final Map<String, dynamic> body = {};

    /// Profile picture
    if ((profilePicture.path ?? "").isNotEmpty) {
      String profilePath = (profilePicture ?? File('')).path.split('/').last;
      body.addAll({
        'profileImage': await MultipartFile.fromFile(profilePicture.path,
            filename: profilePath),
      });
    }

    /// Club additional images.
    if (additionalImage.isNotEmpty) {
      additionalImage.forEachIndexed((index, element) async {
        if (element.isURL == false) {
          final fileObj = File(element.path ?? "");
          String fileName = fileObj.path.split('/').last;
          final multipartFile =
              await MultipartFile.fromFile(fileObj.path, filename: fileName);
          body.addAll({'${NetworkParams.userImages}[$index]': multipartFile});
        }
      });
    }

    // Add Delay while preparing multipart image.
    await Future.delayed(
      Duration(milliseconds: 300 * additionalImage.length),
    );

    FormData formData = FormData.fromMap(body, ListFormat.multiCompatible);
    return patchApiWithoutHeader(
      url:
          "${NetworkAPI.userDetails}/addUserThumbnails/${GetIt.I<PreferenceManager>().userId}",
      data: formData
    );
  }


}
