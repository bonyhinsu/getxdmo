import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';
import 'package:game_on_flutter/infrastructure/storage/preference_manager.dart';
import 'package:get_it/get_it.dart';

import '../../../../../infrastructure/network/network_config.dart';

class PlayerFavouriteSelectionProvider extends DioClient {
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : get
  /// Detail : Api for get player favourite favourite list.
  Future<Response> getPlayerFavouriteList() async {
    return getBaseApi(
      url: '${NetworkAPI.favourites}/${GetIt.I<PreferenceManager>().userId}',
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : get
  /// Detail : Api for get player selected favourite favourite list.
  Future<Response> getPlayerSelectedFavouriteList({required String userId}) async {
    return getBaseApi(
      url:
          '${NetworkAPI.selectedFavouriteList}/$userId',
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for add favourite list.
  Future<Response> addPlayerFavouriteList({required String value}) async {
    final Map<String, String> body = {
      NetworkParams.name: value,
    };
    return postApiWithoutHeader(
      url: NetworkAPI.favourites,
      data: body,
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : patch
  /// Detail : Api for update player favourite list.
  Future<Response> updatePlayerFavouriteList({required String value, required int itemId}) async {
    final Map<String, String> body = {
      NetworkParams.name: value,
    };
    return patchBaseApi(
      url: "${NetworkAPI.favourites}/$itemId",
      data: body,
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : delete
  /// Detail : Api for delete player favourite list.
  Future<Response> deletePlayerFavouriteList({required String id}) async {
    return deleteBaseApi(
      url: '${NetworkAPI.favourites}/$id',
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for add user to favourite list.
  Future<Response> addUserToFavourite(
      {required String favouriteUserId,
      required List<int> selectedList}) async {
    final Map<String, dynamic> body = {
      NetworkParams.favouriteUserId: favouriteUserId,
      NetworkParams.selectedList: selectedList,
    };
    return postBaseApi(
      url: NetworkAPI.addSelectFavouriteList,
      data: body,
    );
  }
}
