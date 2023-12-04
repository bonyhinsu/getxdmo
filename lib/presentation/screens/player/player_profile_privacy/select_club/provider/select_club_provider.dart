import 'package:dio/dio.dart';
import 'package:game_on_flutter/values/app_constant.dart';

import '../../../../../../infrastructure/network/dio_client.dart';
import '../../../../../../infrastructure/network/network_config.dart';



class SelectClubProvider extends DioClient {
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : get
  /// Detail : Api for fetch user selected club for profile privacy.
  Future<Response> getAllUserSelectedClubs(List<int> postTypeIds, int pageKey,
  {String search = ''}) async {
    final Map<String, dynamic> body = {
      NetworkParams.limit:AppConstants.pageSize,
      // search post based on user input.
      NetworkParams.offset: pageKey,
      if (search.isNotEmpty) NetworkParams.name: search
    };

    return getBaseApi(url: NetworkAPI.selectedWithAllClub, queryParameters: body);
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : get
  /// Detail : Api for fetch user selected club for profile privacy.
  Future<Response> getOnlySelectedClub(int pageKey) async {
    final Map<String, dynamic> body = {
      NetworkParams.limit:AppConstants.pageSize,
      // search post based on user input.
      NetworkParams.offset: pageKey,
    };

    return getBaseApi(url: NetworkAPI.userSelectedClubToBeHiddenFrom, queryParameters: body);
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : Get
  /// Detail : Api for fetching user preferred privacy setting.
  Future<Response> getUserSelectedPreference() async {
    return getApiWithoutHeader(
      url: NetworkAPI.selectedClub,
    );
  }

}
