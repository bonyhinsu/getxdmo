import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';
import 'package:get_it/get_it.dart';

import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/storage/preference_manager.dart';

class SubscriptionPlanProvider extends DioClient {
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : GET
  /// Detail : Api for fetch subscription API.
  Future<Response> getSubscriptionPlan() async {
    return getBaseApi(
      url: NetworkAPI.subscriptionPlan,
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for start subscription for user.
  Future<Response> addSubscription(
      {required String subscriptionId, required String sportTypeId}) async {
    final Map<String, String> body = {
      NetworkParams.subscriptionId: subscriptionId,
      NetworkParams.sportTypeId: sportTypeId,
      NetworkParams.userId: GetIt.I<PreferenceManager>().userId.toString(),
    };
    return postBaseApi(
      url: NetworkAPI.subscriptionPlan,
      data: body,
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for start new subscription for user.
  Future<Response> addNewSubscription(
      {required String subscriptionId,
      required int sportTypeId,
      required List<int> locationDetail,
      required List<int> playerCategoryDetail,
      required List<int> levelDetail}) async {
    final Map<String, dynamic> body = {
      NetworkParams.subscriptionId: subscriptionId,
      NetworkParams.sportTypeId: sportTypeId,
    };

    if (levelDetail.isNotEmpty) {
      body.addAll({
        NetworkParams.levelDetail: levelDetail,
      });
    }

    if (locationDetail.isNotEmpty) {
      body.addAll({
        NetworkParams.locationDetail: locationDetail,
      });
    }

    if (playerCategoryDetail.isNotEmpty) {
      body.addAll({
        NetworkParams.playerCategoryDetail: playerCategoryDetail,
      });
    }
    return postBaseApi(
      url:
          '${NetworkAPI.manageSubscription}/${GetIt.I<PreferenceManager>().userId.toString()}',
      data: body,
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for renew subscription for user.
  Future<Response> reNewExistingSubscription(
      {required String subscriptionId,required String sportId}) async {
    final Map<String, dynamic> body = {
      NetworkParams.subscriptionId: subscriptionId,
    };
    return postBaseApi(
      url:
          '${NetworkAPI.renewSubscription}/$sportId',
      data: body,
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for upgrade subscription for user.
  Future<Response> upgradeExistingSubscription(
      {required String subscriptionId,required String sportDetailId}) async {
    final Map<String, dynamic> body = {
      NetworkParams.subscriptionId: subscriptionId,
    };
    return patchBaseApi(
      url:
          '${NetworkAPI.upgradeSubscription}/$sportDetailId',
      data: body,
    );
  }
}
