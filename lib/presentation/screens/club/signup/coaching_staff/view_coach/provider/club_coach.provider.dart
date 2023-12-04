import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';

import '../../../../../../../infrastructure/network/network_config.dart';

class ClubCoachProvider extends DioClient{
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for club coaches.
  Future<Response> getClubCoaches({required String clubId}) async {
    return getBaseApi(
      url: "${NetworkAPI.clubCoachingStaff}/$clubId",
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : delete
  /// Detail : Api for delete club coach.
  Future<Response> deleteClubBoardCoach({required String itemId}) async {
    return deleteBaseApi(
      url: "${NetworkAPI.clubCoachingStaff}/$itemId",
    );
  }
}