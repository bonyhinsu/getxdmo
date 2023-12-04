import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';

import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../values/app_constant.dart';

class PlayerSearchResultProvider extends DioClient {
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : get
  /// Detail : Api for fetch club list with pagination
  Future<Response> getClubList(List<int> postTypeIds, String filterLocation,
      String filterLevels, String filterSports, int pageKey,
      {String search = ''}) async {
    final Map<String, dynamic> body = {
      NetworkParams.limit: AppConstants.paginationPageSize,
      NetworkParams.offset: pageKey,
      // filter post by filter type.
      if (postTypeIds.isNotEmpty) NetworkParams.postTypeId: postTypeIds,

      // search post based on user input.
      if (search.isNotEmpty) NetworkParams.search: search,

      if (filterLocation.isNotEmpty) NetworkParams.locationName: filterLocation,

      if (filterLevels.isNotEmpty) NetworkParams.levelName: filterLevels,

      if (filterSports.isNotEmpty) NetworkParams.sportTypeName: filterSports,
    };
    return getBaseApi(
        url: NetworkAPI.playerSearchClubResult, queryParameters: body);
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : get
  /// Detail : Api for fetch advertisement.
  Future<Response> getAdvertisement() async {
    return getBaseApi(url: NetworkAPI.getAdvertisement);
  }
}
