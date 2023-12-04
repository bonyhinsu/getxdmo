import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';
import 'package:get_it/get_it.dart';

import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/storage/preference_manager.dart';
import '../../../../../values/app_constant.dart';

class ClubFavoriteProvider extends DioClient {
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : get
  /// Detail : Api for fetch user post
  Future<Response> getUserPostAPI(List<int> favouriteListId, int pageKey,
      {String search = ''}) async {
    final Map<String, dynamic> body = {
      NetworkParams.limit: AppConstants.paginationPageSize,
      NetworkParams.offset: pageKey,
      // search post based on user input.
      if (search.isNotEmpty) NetworkParams.search: search,
    };

    // filter post by filter type.
    if (favouriteListId.isNotEmpty) {
      favouriteListId.forEachIndexed((index, element) {
        body.addAll({'${NetworkParams.favouriteListId}[$index]': element});
      });
    }

    return getBaseApi(url: NetworkAPI.getFavouriteList, queryParameters: body);
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : get
  /// Detail : Api for get player favourite favourite list.
  Future<Response> getPlayerFavouriteList() async {
    return getBaseApi(
      url: '${NetworkAPI.favourites}/${GetIt.I<PreferenceManager>().userId}',
    );
  }


}
