import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../../../../infrastructure/network/dio_client.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/storage/preference_manager.dart';

class SubscriptionDetailProvider extends DioClient {
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for fetch user subscription detail.
  Future<Response> getSubscriptionDetail(String subscriptionId) async {
    return getBaseApi(
      url: '${NetworkAPI.subscriptionPlan}/$subscriptionId',
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for cancel user subscription.
  Future<Response> cancelUserSubscription(String subscriptionId) async {
    return patchBaseApi(
      url: '${NetworkAPI.subscriptionPlanCancel}/$subscriptionId',
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for renew subscription for user.
  Future<Response> reNewExistingSubscription(
      {required String subscriptionId}) async {
    final Map<String, dynamic> body = {
      NetworkParams.subscriptionId: subscriptionId,
    };
    return postBaseApi(
      url:
      '${NetworkAPI.renewSubscription}/${GetIt.I<PreferenceManager>().userId.toString()}',
      data: body,
    );
  }
}
