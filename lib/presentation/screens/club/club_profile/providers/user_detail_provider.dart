import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../../../../infrastructure/network/dio_client.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/storage/preference_manager.dart';

class UserDetailProvider extends DioClient {
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : get
  /// Detail : Api for get user details.
  Future<Response> getUserDetails({required String token}) async {
    return getApiWithHeader(
      url: "${NetworkAPI.userDetails}/${GetIt.I<PreferenceManager>().userId}",
      header: token,
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : get
  /// Detail : Api for update firebase details.
  Future<Response> updateFirebaseToken() async {
    final Map<String, String> body = {
      NetworkParams.firebaseToken: GetIt.I<PreferenceManager>().getUserToken,
      NetworkParams.firebaseUuid: GetIt.I<PreferenceManager>().userUUID,
      NetworkParams.firebaseUserId:
          GetIt.I<PreferenceManager>().getFirebaseChatUserId,
    };
    return patchApiWithHeader(
        url: NetworkAPI.storeFirebaseToken,
        data: body,
        header: GetIt.I<PreferenceManager>().getUserToken);
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : get
  /// Detail : Api to check user free subscription status.
  Future<Response> checkUserFreeSubscriptionStatus() async {
    return getBaseApi(
      url:
          '${NetworkAPI.getFreeSubscription}/${GetIt.I<PreferenceManager>().userId}',
    );
  }
}
