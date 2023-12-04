import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';
import 'package:game_on_flutter/infrastructure/storage/preference_manager.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../infrastructure/network/network_config.dart';

class AddMemberBottomSheetProvider extends DioClient {
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for add member bottomsheet provider.
  Future<Response> addMemberBottomSheetProvider({
    required String email,
    required String name,
    required String role,
    required String phone,
    required bool isFromOtherMember,
  }) async {
    final Map<String, dynamic> body = {
      NetworkParams.email: email,
      NetworkParams.name: name,
      NetworkParams.type: role,
      NetworkParams.contactNumber: phone,
    };

    if (isFromOtherMember) {
      body.addAll({
        NetworkParams.isOtherContactInfo: 1,
      });
    }
    return postBaseApi(
      url:
          "${NetworkAPI.clubBoardMembers}/${GetIt.instance<PreferenceManager>().userId.toString()}",
      data: body,
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : patch
  /// Detail : Api for update member bottomSheet provider.
  Future<Response> updateMemberBottomSheetProvider({
    required String email,
    required String name,
    required String role,
    required String phone,
    required int id,
    required bool isFromOtherMember,
  }) async {
    final Map<String, dynamic> body = {
      NetworkParams.email: email,
      NetworkParams.name: name,
      NetworkParams.type: role,
      NetworkParams.contactNumber: phone,
    };
    if (isFromOtherMember) {
      body.addAll({
        NetworkParams.isOtherContactInfo: 1,
      });
    }
    return patchBaseApi(
      url: "${NetworkAPI.clubBoardMembers}/$id",
      data: body,
    );
  }
}
