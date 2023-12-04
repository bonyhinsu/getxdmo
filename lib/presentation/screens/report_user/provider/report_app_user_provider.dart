import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';

import '../../../../infrastructure/network/network_config.dart';

class ReportAppUserProvider extends DioClient {
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for report app user.
  Future<Response> reportAppUser(
      {required String reportUserId,
      required int reportId,
      required String reportDescription}) async {
    final Map<String, dynamic> body = {
      NetworkParams.reportUserId: reportUserId,
      if (reportId != -1) NetworkParams.reportId: reportId,
      NetworkParams.description: reportDescription,
    };
    return postBaseApi(url: NetworkAPI.reportUser, data: body);
  }
}
