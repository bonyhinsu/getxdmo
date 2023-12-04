import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';

import '../../../../../infrastructure/network/network_config.dart';

class LoginProvider extends DioClient {
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for authenticate user using email and password.
  Future<Response> loginUser(
      {required String email, required String password}) async {
    final Map<String, String> body = {
      NetworkParams.email: email,
      NetworkParams.password: password,
    };
    return postApiWithoutHeader(
      url: NetworkAPI.loginUser,
      data: body,
    );
  }
}
