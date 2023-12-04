import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';

import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../values/app_constant.dart';

class AddOpenPositionProvider extends DioClient {
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for open position
  Future<Response> addOpenPosition(
      {required String positionName,
      required String age,
      required String gender,
      required String location,
      required String level,
      required String description,
      required String reference,
      required String skill,
        required String eventImage}) async {
    final Map<String, dynamic> body = {
      NetworkParams.type: AppConstants.postTypeOpenPosition,
      NetworkParams.postTypeId: AppConstants.postTypeIdOpenPosition,
      NetworkParams.title: positionName,
      NetworkParams.age: age,
      NetworkParams.gender: gender,
      NetworkParams.location: location,
      NetworkParams.level: level,
      NetworkParams.references: reference,
      NetworkParams.skill: skill,
      NetworkParams.otherDetails: description,
    };
    return postBaseApi(
      url: NetworkAPI.post,
      data: body,
    );
  }
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : path
  /// Detail : Api for update open position for club.
  Future<Response> updateOpenPosition(
      {required String itemId,
        required String positionName,
        required String age,
        required String gender,
        required String location,
        required String level,
        required String description,
        required String reference,
        required String skill,
        required String eventImage}) async {
    final Map<String, dynamic> body = {
      NetworkParams.type: AppConstants.postTypeOpenPosition,
      NetworkParams.postTypeId: AppConstants.postTypeIdOpenPosition,
      NetworkParams.title: positionName,
      NetworkParams.age: age,
      NetworkParams.gender: gender,
      NetworkParams.location: location,
      NetworkParams.level: level,
      NetworkParams.references: reference,
      NetworkParams.skill: skill,
      NetworkParams.otherDetails: description,
    };
    return patchBaseApi(
      url: "${NetworkAPI.post}/$itemId",
      data: body,
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : get
  /// Detail : Api for get levels.
  Future<Response> getLevel() async {
    return getBaseApi(
      url: NetworkAPI.levels,
    );
  }
}
