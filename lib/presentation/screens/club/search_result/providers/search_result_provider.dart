import 'package:dio/dio.dart';

import '../../../../../infrastructure/network/dio_client.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../values/app_constant.dart';

class SearchResultProvider extends DioClient {
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : get
  /// Detail : Api for fetch user post based on filter.
  Future<Response> getUserPostAPI(
      List<int> postTypeIds,
      int pageKey,
      String filterLocation,
      String filterLevels,
      String filterSports,
      String filterGenders,
      String filterPositions,
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

      if (filterGenders.isNotEmpty) NetworkParams.gender: filterGenders,

      if (filterPositions.isNotEmpty)
        NetworkParams.positionName: filterPositions,
    };

    return getBaseApi(url: NetworkAPI.playerList, queryParameters: body);
  }
}
