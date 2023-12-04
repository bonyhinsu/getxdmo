import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';
import 'package:get_it/get_it.dart';

import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/storage/preference_manager.dart';

class NewPasswordProvider extends DioClient {
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : patch
  /// Detail : Api for change password API.
  Future<Response> changePassword({required String password}) async {
    final Map<String, String> body = {
      NetworkParams.email: GetIt.I<PreferenceManager>().userEmail,
      NetworkParams.password: password,
      NetworkParams.confirmPassword: password,
    };
    return patchBaseApi(
      url: NetworkAPI.changePassword,
      data: body,
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for reset password API.
  Future<Response> resetPassword({required String email,required String password }) async {
    final Map<String, String> body = {
      NetworkParams.email: email,
      NetworkParams.password: password,
      NetworkParams.confirmPassword: password,
    };
    return postApiWithoutHeader(
      url: NetworkAPI.resetPassword,
      data: body,
    );
  }
}
