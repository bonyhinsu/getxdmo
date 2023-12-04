import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../../../../infrastructure/network/dio_client.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/storage/preference_manager.dart';

class VerifyProvider extends DioClient {
  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for verify login OTP.
  Future<Response> verifyLoginPasswordOTP({required String email, required String otp}) async {
    final Map<String, String> body = {
      NetworkParams.email:email,
      NetworkParams.otpCode:otp,
    };
    return postApiWithoutHeader(
      url: NetworkAPI.loginUserVerify,
      data: body,
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for verify forgot password OTP.
  Future<Response> verifyForgotPasswordOTP({required String email,required String otp}) async {
    final Map<String, String> body = {
      NetworkParams.email:email,
      NetworkParams.forgotPasswordOtpCode:otp,
    };
    return postApiWithoutHeader(
      url: NetworkAPI.forgotPasswordVerify,
      data: body,
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for resend OTP.
  Future<Response> resendOTP({required String email}) async {
    final Map<String, String> body = {
      NetworkParams.email:email
    };
    return postApiWithoutHeader(
      url: NetworkAPI.resendVerification,
      data: body,
    );
  }

  ///Returns [dio.Response] with success or error object.
  ///
  /// Method : post
  /// Detail : Api for club board members.
  Future<Response> getClubBoardMembers({required String clubId}) async {
    return getApiWithHeader(
      header: GetIt.I<PreferenceManager>().getUserToken,
      url: "${NetworkAPI.clubBoardMembers}/$clubId",
    );
  }

}
