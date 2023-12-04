import 'package:dio/dio.dart';

import '../../../../../infrastructure/network/dio_client.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../values/app_constant.dart';

class ClubUserSearchProvider extends DioClient {
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : get
  /// Detail : Api for fetch user post
  Future<Response> getUserPostAPI(List<int> postTypeIds,
      int pageKey,
      {String search = ''}) async {
    final Map<String, dynamic> body = {
      NetworkParams.limit: AppConstants.paginationPageSize,
      NetworkParams.offset: pageKey,
      // filter post by filter type.
      if (postTypeIds.isNotEmpty) NetworkParams.postTypeId: postTypeIds,

      // search post based on user input.
      if (search.isNotEmpty) NetworkParams.search: search,


    };

    return getBaseApi(url: NetworkAPI.playerList, queryParameters: body);
  }
}
