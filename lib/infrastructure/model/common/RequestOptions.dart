import 'package:dio/dio.dart';

class MyTransformer extends BackgroundTransformer {
  @override
  Future<String> transformRequest(RequestOptions options) async {
    if (options.data is List<String>) {
      throw DioException(
        error: "Can't send List to sever directly",
        requestOptions: options,
      );
    } else {
      return super.transformRequest(options);
    }
  }

  /// The [Options] doesn't contain the cookie info. we add the cookie
  /// info to [Options.extra], and you can retrieve it in [ResponseInterceptor]
  /// and [Response] with `response.request.extra["cookies"]`.
  @override
  Future transformResponse(
      RequestOptions options,
      ResponseBody responseBody,
      ) async {
    options.extra['self'] = 'XX';
    return super.transformResponse(options, responseBody);
  }
}