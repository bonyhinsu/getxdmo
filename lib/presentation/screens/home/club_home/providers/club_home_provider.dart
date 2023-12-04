import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';

import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../values/app_constant.dart';

class ClubHomeProvider extends DioClient {
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : get
  /// Detail : Api for fetch user post
  Future<Response> getUserPostAPI(List<int> postTypeIds, int pageKey,
      {String search = ''}) async {
    final Map<String, dynamic> body = {
      NetworkParams.limit: AppConstants.paginationPageSize,
      NetworkParams.offset: pageKey,

      // search post based on user input.
      if (search.isNotEmpty) NetworkParams.search: search
    };

    // filter post by filter type.
    if (postTypeIds.isNotEmpty) {
      postTypeIds.forEachIndexed((index, element) {
        body.addAll({'${NetworkParams.postTypeId}[$index]': element});
      });
    }
    return getBaseApi(url: NetworkAPI.playerList, queryParameters: body);
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : get
  /// Detail : Api for fetch advertisement.
  Future<Response> getAdvertisement() async {
    return getBaseApi(url: NetworkAPI.getAdvertisement);
  }


}
