import 'package:game_on_flutter/infrastructure/network/dio_client.dart';
import 'package:dio/dio.dart';

import '../../../../../../infrastructure/network/network_config.dart';

class OtherContactsProvider extends DioClient {

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for club board members.
  Future<Response> getClubBoardMembers({required String clubId}) async {
    final Map<String, String> body = {
      NetworkParams.isOtherContactInfo: '1',
    };
    return getBaseApi(
      url: "${NetworkAPI.clubBoardMembers}/$clubId",
      queryParameters: body
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : delete
  /// Detail : Api for delete club board members.
  Future<Response> deleteClubBoardMembers({required String itemId}) async {
    return deleteBaseApi(
      url: "${NetworkAPI.clubBoardMembers}/$itemId",
    );
  }
}
