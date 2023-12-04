import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';

import '../../../../../../infrastructure/network/network_config.dart';

class ClubBoardMembersProvider extends DioClient {

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for club board members.
  Future<Response> getClubBoardMembers({required String clubId}) async {
    return getBaseApi(
      url: "${NetworkAPI.clubBoardMembers}/$clubId",
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
