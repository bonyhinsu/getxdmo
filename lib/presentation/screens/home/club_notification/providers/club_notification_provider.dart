import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';


import '../../../../../infrastructure/network/network_config.dart';

class ClubNotificationProvider extends DioClient {
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : get
  /// Detail : Api for fetch Notification List
  Future<Response> getNotificationPostAPI(List<int> postTypeIds,
      int pageKey) async {
    final Map<String, dynamic> body = {
      NetworkParams.offset: pageKey,
    };

    return getBaseApi(url: NetworkAPI.notificationList, queryParameters: body);
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : patch
  /// Detail : Api for readall Notification List
  Future<Response> readNotification() async {
    return patchBaseApi(url: NetworkAPI.readNotification);
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : get
  /// Detail : Api for readSingleNotification Notification
  Future<Response> readOneNotification(int id) async {
    return patchBaseApi(url: "${NetworkAPI.readNotification}/$id");
  }


}
