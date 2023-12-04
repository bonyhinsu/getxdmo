import 'dart:async';

import 'package:dio/dio.dart' as dio;
import 'package:game_on_flutter/infrastructure/firebase/firestore_manager.dart';
import 'package:game_on_flutter/infrastructure/model/common/app_fields.dart';
import 'package:game_on_flutter/presentation/screens/club/club_profile/providers/user_detail_provider.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../../../../infrastructure/model/subscription/free_subscription_response.dart';
import '../../../../../infrastructure/model/user_detail_response_model.dart';
import '../../../../../infrastructure/model/user_info_model.dart';
import '../../../../../infrastructure/network/api_utils.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../infrastructure/storage/preference_manager.dart';
import '../../../../../values/common_utils.dart';

class UserDetailService extends GetxService {
  Rx<UserDetails> userDetails = UserDetails().obs;

  StreamController<UserDetails> userDetailsStreamController =
      StreamController<UserDetails>.broadcast();

  final logger = Logger();

  final UserDetailProvider _provider = UserDetailProvider();

  UserDetailService();

  /// get user details API.
  Future<UserDetails?> getUserDetails({String token = ''}) async {
    if (token.isNotEmpty) {
      GetIt.I<PreferenceManager>().setUserToken(token);
    }
    try {
      if (await NetworkConnectivity.instance.hasNetwork()) {
        dio.Response? response = await _provider.getUserDetails(
            token: token.isNotEmpty
                ? token
                : GetIt.I<PreferenceManager>().getUserToken);
        if (response.statusCode == NetworkConstants.success) {
          /// On success

          UserDetailResponseModel signupResponse =
              UserDetailResponseModel.fromJson(response.data);
          if (signupResponse.data != null) {
            userDetails.value = signupResponse.data!;
            GetIt.I<PreferenceManager>().setUserDetails(signupResponse.data!);
            GetIt.I<PreferenceManager>()
                .setUserName(signupResponse.data!.name ?? "");
            GetIt.I<PreferenceManager>()
                .setUserEmail(signupResponse.data!.email ?? "");
            GetIt.I<PreferenceManager>()
                .setUserProfile(signupResponse.data!.profileImage ?? "");
          }
          _updateUserDetailsToFirebase();
          userDetailsStreamController.add(userDetails.value);
          Future.delayed(
            Duration(milliseconds: 600),
            () {
              // _checkIfUserEnableChat();
            },
          );

          return signupResponse.data;
        } else {
          /// On Error
          _getUserDetailsError(response);
          return null;
        }
      }
    } catch (ex) {
      logger.e(ex);
      CommonUtils.showErrorSnackBar(message: ex.toString());
    }
    return null;
  }

  /// Update user details to the firebase.
  void _updateUserDetailsToFirebase() {
    try {
      FireStoreManager.instance.updateUserAccountData(
          firebaseUUID: GetIt.I<PreferenceManager>().userUUID,
          profile: userDetails.value.profileImage ?? "",
          name: userDetails.value.name ?? "",
          phoneNumber: userDetails.value.phoneNumber ?? "",
          email: userDetails.value.email ?? "");
    } catch (ex) {
      logger.e(ex);
    }
  }

  /// Perform api error.
  void _getUserDetailsError(dio.Response response) {
    GetIt.instance<ApiUtils>().parseErrorResponse(
      response,
    );
  }

  /// Save firebase details to the server.
  Future<void> saveFirebaseTokenToServer() async {
    try {
      if (await NetworkConnectivity.instance.hasNetwork()) {
        dio.Response? response = await _provider.updateFirebaseToken();
        if (response.statusCode == NetworkConstants.success) {
          /// On success
        } else {
          /// On Error
          _getUserDetailsError(response);
        }
      }
    } catch (ex) {
      logger.e(ex);
      CommonUtils.showErrorSnackBar(message: ex.toString());
    }
  }

  /// check if need to enable chat feature for the user or not.
  Future<void> _checkIfUserEnableChat() async {
    // Check if user has any paid subscription taken or not.
    final isUserHasPaidSubscription = userDetails.value.userSportsDetails
        ?.firstWhereOrNull((element) =>
            (element.subscriptionDetails?.first.subscriptionType ?? "")
                .toLowerCase()
                .contains('paid'));

    if (isUserHasPaidSubscription == null) {
      // If user haven't taken any subscription then check for if their date is
      // extended or allowed char or not.
      _checkUserSubscription().then((value) {});
    } else {
      AppFields.instance.enableChat = true;
    }
  }

  /// Check for user subscription
  Future<void> _checkUserSubscription() async {
    try {
      if (await NetworkConnectivity.instance.hasNetwork()) {
        String userToken = GetIt.I<PreferenceManager>().getUserToken;
        print("token all :" "${userToken}");
        dio.Response? response =
            await _provider.checkUserFreeSubscriptionStatus();
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          FreeSubscriptionResponse subscriptionResponse =
              FreeSubscriptionResponse.fromJson(response.data);

          // Subscription is not expired.
          final isSubscriptionNotExpired =
              (subscriptionResponse.data?.isExpire ?? "y").toLowerCase() == 'n';

          // true if chat feature allowed by admin.
          final isChatEnableByAdmin =
              (subscriptionResponse.data?.isAllowChat ?? "y").toLowerCase() ==
                  'y';

          AppFields.instance.enableChat = isChatEnableByAdmin;

          AppFields.instance.subscriptionExpired = !isSubscriptionNotExpired;
        } else {
          /// On Error
          _getUserDetailsError(response);
        }
      }
    } catch (ex) {
      logger.e(ex);
      CommonUtils.showErrorSnackBar(message: ex.toString());
    }
  }
}
