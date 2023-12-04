import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';
import 'package:game_on_flutter/infrastructure/storage/preference_manager.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get_it/get_it.dart';

import '../../../../../infrastructure/network/network_config.dart';

class PlayerProfilePrivacyProvider extends DioClient {
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for add favourite list.
  Future<Response> profilePrivacy(RxList<dynamic> userId,
      {required String value}) async {
    final Map<dynamic, dynamic> body = {
      NetworkParams.type: value,
      if(userId.isNotEmpty)
      NetworkParams.selectedClubs: userId,
    };
    return postApiWithoutHeader(
      url: NetworkAPI.profilePrivacy,
      data: body,
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for add favourite list.
  Future<Response> selectedClub() async {

    return getApiWithoutHeader(
      url: NetworkAPI.selectedClub,
    );
  }
}
