import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../model/common/RequestOptions.dart';
import '../storage/preference_manager.dart';
import 'network_config.dart';

abstract class DioClient {
  final logger = Logger();
  final Dio _dio = Dio(BaseOptions(
    baseUrl: "",
    headers: {
      if (GetIt.I<PreferenceManager>().getUserToken.isNotEmpty)
        NetworkParams.headerAuthToken:
            "${NetworkParams.bearer} ${GetIt.I<PreferenceManager>().getUserToken}"
    },
    connectTimeout: const Duration(minutes: 3),
    // 10 seconds
    validateStatus: (status) {
      return true;
    },
    receiveDataWhenStatusError: true,
  ))
    ..transformer = MyTransformer()
    ..interceptors.add(
      AwesomeDioInterceptor(
        logRequestTimeout: false,
        logRequestHeaders: true,
        logResponseHeaders: false,
      ),
    );

  Future<Response> getBaseApi({
    required String url,
    Map<String, dynamic>? queryParameters,
  }) async {
    Response response = Response(requestOptions: RequestOptions());
    try {
      response = await _dio.get(url, queryParameters: queryParameters);
      return response;
    } on DioError catch (error, stacktrace) {
      logger.e(url, error, stacktrace);
      response.data = null;
      return response.data;
    }
  }

  Future<Response> postBaseApi({
    required String url,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Response response = await _dio.post(url,
        data: data, queryParameters: queryParameters, options: Options());
    return response;
  }

  Future<Response> postBaseApiForMultipart({
    required String url,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    Response response =
        await _dio.post(url, data: data, queryParameters: queryParameters);
    return response;
  }

  Future<Response> patchBaseApiForMultipart({
    required String url,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    Response response =
        await _dio.patch(url, data: data, queryParameters: queryParameters);
    return response;
  }

  Future<Response> deleteBaseApi({
    required String url,
  }) async {
    Response response = await _dio.delete(url);
    return response;
  }

  Future<Response> putConnectApi({
    required String url,
    dynamic data,
  }) async {
    Response response = await _dio.put(url, data: data);
    return response;
  }

  Future<Response> patchBaseApi({
    required String url,
    dynamic data,
  }) async {
    Response response = await _dio.patch(
      url,
      data: data,
    );
    return response;
  }

  Future<Response> postApiWithoutHeader({
    required String url,
    Map<String, dynamic>? queryParameters,
    dynamic data,
  }) async {
    Response userData = await _dio.post(url,
        queryParameters: queryParameters,
        data: data,
        options: Options(
          headers: null,
        ));
    return userData;
  }

  Future<Response> patchApiWithoutHeader({
    required String url,
    Map<String, dynamic>? queryParameters,
    dynamic data,
  }) async {
    Response userData = await _dio.patch(url,
        queryParameters: queryParameters,
        data: data,
        options: Options(
          headers: null,
        ));
    return userData;
  }

  Future<Response> getApiWithoutHeader({
    required String url,
    Map<String, dynamic>? queryParameters,
  }) async {
    Response userData = await _dio.get(url,
        queryParameters: queryParameters,
        options: Options(
          headers: null,
        ));
    return userData;
  }

  Future<Response> getApiWithHeader({
    required String url,
    required String header,
    Map<String, dynamic>? queryParameters,
  }) async {
    Response userData = await _dio.get(url,
        queryParameters: queryParameters,
        options: Options(
          headers: {
            NetworkParams.headerAuthToken: "${NetworkParams.bearer} $header"
          },
        ));
    return userData;
  }

  Future<Response> patchApiWithHeader({
    required String url,
    required String header,
    Map<String, dynamic>? queryParameters,
    dynamic data,
  }) async {
    Response userData = await _dio.patch(url,
        queryParameters: queryParameters,
        data: data,
        options: Options(
          headers: {
            NetworkParams.headerAuthToken: "${NetworkParams.bearer} $header"
          },
        ));
    return userData;
  }
}
