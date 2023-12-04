import 'dart:io';

import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';
import 'package:get_it/get_it.dart';

import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/storage/preference_manager.dart';

class ClubProfileProvider extends DioClient {

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : POST
  /// Detail : Api for logout.
  Future<Response> logoutUser() async {
    return deleteBaseApi(
      url: "${NetworkAPI.logout}/${GetIt.I<PreferenceManager>().userId}",
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : POST
  /// Detail : Api for delete account.
  Future<Response> deleteAccountUser() async {
    return deleteBaseApi(
      url: "${NetworkAPI.userDetails}/${GetIt.I<PreferenceManager>().userId}",
    );
  }
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : POST
  /// Detail : Api for upload user profile image.
  Future<Response> updateUserProfile(File? profilePicture) async {
    String profilePath = (profilePicture ?? File('')).path.split('/').last;
    final map = {
      /// Profile picture
      if ((profilePicture?.path ?? "").isNotEmpty)
        'profileImage': await MultipartFile.fromFile(
            profilePicture!.path,
            filename: profilePath),
    };
    FormData formData = FormData.fromMap(map);
    return patchBaseApiForMultipart(
      url: "${NetworkAPI.userDetails}/uploadUserImage",
      data: formData
    );
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

}
