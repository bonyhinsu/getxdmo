import 'package:dio/dio.dart';

import '../../../../../infrastructure/network/dio_client.dart';
import '../../../../../infrastructure/network/network_config.dart';

class PaymentMethodProvider extends DioClient {
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for fetch user saved payment method.
  Future<Response> getUserSavedPaymentMethod() async {
    final Map<String, String> body = {};
    return postApiWithoutHeader(
      url: NetworkAPI.login,
      data: body,
    );
  }
}
