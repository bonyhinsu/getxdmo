import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';
import 'package:get_it/get_it.dart';

import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/storage/preference_manager.dart';
import '../../../club/signup/register_club_details/controllers/register_club_details.controller.dart';
import '../../../club/signup/register_club_details/model/location_data_model.dart';

class RegisterPlayerDetailProvider extends DioClient {
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for register player.
  Future<Response> registerPlayerDetail({
    required String playerName,
    required String email,
    required String password,
    required String video,
    required String phoneNumber,
    required String address,
    required String type,
    required String introduction,
    required String dateOfBirth,
    required String height,
    required String weight,
    required String gender,
    required String bio,
    required String reference,
    required String uuid,
    required String osVersion,
    required String deviceName,
    required String modelName,
    required String deviceType,
    required String ip,
    required int sportTypeId,
    required List<int> levelDetail,
    required List<int> playerPosition,
    required File profilePicture,
    required List<ClubProfileImage> additionalImage,
    required List<LocationDataModel> locationDetail,
  }) async {
    final Map<String, dynamic> body = {
      NetworkParams.name: playerName,
      NetworkParams.email: email,
      NetworkParams.password: password,
      NetworkParams.phoneNumber: phoneNumber,
      NetworkParams.address: address,
      NetworkParams.video: video,
      NetworkParams.type: type,
      NetworkParams.dateOfBirth: dateOfBirth,
      NetworkParams.introduction: introduction,
      NetworkParams.referenceAndInfo: reference,
      NetworkParams.bio: bio,
      NetworkParams.height: height.toString(),
      NetworkParams.weight: weight.toString(),
      NetworkParams.gender: gender,
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

    if (playerPosition.isNotEmpty) {
      body.addAll({
        NetworkParams.playerPosition: playerPosition,
      });
    }
    if (locationDetail.isNotEmpty) {
      body.addAll({
        NetworkParams.locationDetail: locationDetail,
      });
    }
    return postBaseApi(
      url: NetworkAPI.register,
      data: body,
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : get
  /// Detail : Api for get user details.
  Future<Response> getUserDetails() async {
    return getBaseApi(
      url: "${NetworkAPI.userDetails}/${GetIt.I<PreferenceManager>().userId}",
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for update player detail.
  Future<Response> updatePlayerDetail({
    required String playerName,
    required String email,
    required String video,
    required String phoneNumber,
    required String address,
    required String type,
    required String introduction,
    required String dateOfBirth,
    required String height,
    required String weight,
    required String gender,
    required String bio,
    required String reference,
    required int sportTypeId,
    required List<int> levelDetail,
    required List<int> playerPosition,
    required String uuid,
    required String osVersion,
    required String deviceName,
    required String modelName,
    required String deviceType,
    required String ip,
    required File profilePicture,
    required List<ClubProfileImage> additionalImage,
    required List<int> locationDetail,
  }) async {
    final Map<String, dynamic> body = {
      NetworkParams.name: playerName,
      NetworkParams.email: email,
      NetworkParams.phoneNumber: phoneNumber,
      NetworkParams.address: address,
      NetworkParams.video: video,
      NetworkParams.dateOfBirth: dateOfBirth,
      NetworkParams.type: type,
      NetworkParams.height: height.toString(),
      NetworkParams.weight: weight.toString(),
      NetworkParams.gender: gender,
      NetworkParams.introduction: introduction,
      NetworkParams.referenceAndInfo: reference,
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

    if (playerPosition.isNotEmpty) {
      body.addAll({
        NetworkParams.playerPosition: playerPosition,
      });
    }

    return patchBaseApi(
      url:
          "${NetworkAPI.updateUserDetails}/${GetIt.I<PreferenceManager>().userId}",
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
  /// Method : get
  /// Detail : Api for get player type.
  Future<Response> getPlayerType() async {
    return getBaseApi(
      url: NetworkAPI.playerType,
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
