import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../../infrastructure/network/network_config.dart';
import '../../../../../../../infrastructure/storage/preference_manager.dart';

class AddClubCoachProvider extends DioClient {
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for add coaching staff.
  Future<Response> addCoachForClub({
    required String email,
    required String name,
    required String phone,
    required String dateOfBirth,
    required String gender,
    required String experience,
    required String speciality,
  }) async {
    final Map<String, String> body = {
      NetworkParams.email: email,
      NetworkParams.name: name,
      NetworkParams.contactNumber: phone,
      NetworkParams.dateOfBirth: dateOfBirth,
      NetworkParams.gender: gender,
      NetworkParams.experience: experience,
      NetworkParams.speciality: speciality,
    };
    return postBaseApi(
      url:
          "${NetworkAPI.clubCoachingStaff}/${GetIt.instance<PreferenceManager>().userId.toString()}",
      data: body,
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : update
  /// Detail : Api for update coaching staff.
  Future<Response> updateCoachForClub({
    required String email,
    required String name,
    required String phone,
    required String dateOfBirth,
    required String gender,
    required String experience,
    required String speciality,
    required int id,
  }) async {
    final Map<String, String> body = {
      NetworkParams.email: email,
      NetworkParams.name: name,
      NetworkParams.contactNumber: phone,
      NetworkParams.dateOfBirth: dateOfBirth,
      NetworkParams.gender: gender,
      NetworkParams.experience: experience,
      NetworkParams.speciality: speciality,
    };
    return patchBaseApi(
      url: "${NetworkAPI.clubCoachingStaff}/$id",
      data: body,
    );
  }
}
