import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';

import '../../../../../infrastructure/network/network_config.dart';

class ForgotPasswordProvider extends DioClient {
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for forgot password.
  Future<Response> forgotPassword({required String email}) async {
    final Map<String, String> body = {
      NetworkParams.email:email
    };
    return postApiWithoutHeader(
      url: NetworkAPI.forgotPassword,
      data: body,
    );
  }
}
