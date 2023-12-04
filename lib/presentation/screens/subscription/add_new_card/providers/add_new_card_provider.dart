import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';

import '../../../../../infrastructure/network/network_config.dart';

class AddNewCardProvider extends DioClient {

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for fetch add payment detail.
  Future<Response> addPaymentDetail() async {
    final Map<String, String> body = {};
    return postApiWithoutHeader(
      url: NetworkAPI.login,
      data: body,
    );
  }
}
