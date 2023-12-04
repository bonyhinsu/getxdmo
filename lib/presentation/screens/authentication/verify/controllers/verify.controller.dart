import 'dart:async';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_loading_mixin.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:game_on_flutter/values/common_utils.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../infrastructure/firebase/firebase_auth_manager.dart';
import '../../../../../infrastructure/firebase/firestore_manager.dart';
import '../../../../../infrastructure/model/club/signup/club_signup_data.dart';
import '../../../../../infrastructure/model/club/signup/selection_model.dart';
import '../../../../../infrastructure/model/club_member_response_model.dart';
import '../../../../../infrastructure/model/device_info_model.dart';
import '../../../../../infrastructure/model/signup_response_model.dart';
import '../../../../../infrastructure/model/user_info_model.dart';
import '../../../../../infrastructure/navigation/route_config.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../infrastructure/network/api_utils.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../infrastructure/storage/preference_manager.dart';
import '../../../../../values/app_constant.dart';
import '../../../club/signup/sports_selection/controllers/sports_selection.controller.dart';
import '../providers/verify_provider.dart';

class VerifyController extends GetxController with AppLoadingMixin {
  static const PIN_LENGTH = 6;

  /// OTP text field controller
  TextEditingController otpTextFieldController =
      TextEditingController(text: "");

  /// OTP focus node
  FocusNode otpFocusNode = FocusNode();

  /// Timer
  Timer? _timer;

  String _email = '';

  /// Provider
  final _provider = VerifyProvider();

  /// Resend OTP counter
  RxInt counterTime = 0.obs;

  /// True if input fields are valid so it enables next button.
  RxBool isValidated = false.obs;

  /// true if user has requested from forgot password.
  bool isForgotPasswordRequest = false;

  /// Verify type enum.
  VerifyTypeEnum verifyTypeEnum = VerifyTypeEnum.LOGIN;

  /// Logger.
  final logger = Logger();

  /// OTP error stream controller.
  late StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();

  @override
  void onClose() {
    _timer?.cancel();
    errorController.close();
    super.onClose();
  }

  @override
  void onInit() {
    _getArguments();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    startTimer();
    otpFocusNode.requestFocus();
  }

  /// Receive arguments from previous screen.
  void _getArguments() {
    if (Get.arguments != null) {
      verifyTypeEnum =
          Get.arguments[RouteArguments.verifyTypeEnum] ?? VerifyTypeEnum.LOGIN;
      _email = Get.arguments[RouteArguments.email] ?? '';
    }
  }

  /// Set OTP.
  void setOTP(String otp) {
    isValidated.value = otp.length == PIN_LENGTH;
  }

  /// on submit
  void onSubmit() {
    if (verifyTypeEnum == VerifyTypeEnum.LOGIN) {
      _verifyLoginOTP();
    } else {
      _verifyForgotPasswordOTP();
    }
  }

  /// Forgot password OTP.
  void _forgotPasswordOTPSuccess(dio.Response response) {
    hideGlobalLoading();
    _navigateToResetPassword();
  }

  void onBackPress() {
    Get.offAndToNamed(Routes.WELCOME);
  }

  /// verify otp success
  void verifyEmailOTPSuccess(dio.Response response) {
    SignupResponse signupResponse = SignupResponse.fromJson(response.data);
    if (signupResponse.status == true) {
      GetIt.instance<PreferenceManager>()
          .setUserToken(signupResponse.data?.token ?? "");

      if (signupResponse.data?.user != null) {
        GetIt.instance<PreferenceManager>().setUserType(
            signupResponse.data?.user?.type?.toLowerCase() == 'club'
                ? AppConstants.userTypeClub
                : AppConstants.userTypePlayer);
        GetIt.instance<PreferenceManager>()
            .setUserId(signupResponse.data?.user?.id ?? -1);
        GetIt.instance<PreferenceManager>()
            .setUserDetails(signupResponse.data!.user!);
        GetIt.instance<PreferenceManager>()
            .setUserEmail(signupResponse.data!.user!.email ?? "");
        GetIt.instance<PreferenceManager>().setLogin(true);
      }
      _loginWithFirebase();
    }
  }

  /// Get club board members.
  void getClubBoardMembers() async {
    try {
      if (await NetworkConnectivity.instance.hasNetwork()) {
        dio.Response? response = await _provider.getClubBoardMembers(
            clubId: GetIt.I<PreferenceManager>().userId.toString());
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _getClubMembersSuccess(response);
        } else {
          /// On Error
          _getBoardMembersError(response);
        }
      } else {
        hideGlobalLoading();
        GetIt.I<CommonUtils>().showServerDownError();
      }
    } catch (ex) {
      logger.e(ex);
      hideGlobalLoading();
      CommonUtils.showErrorSnackBar(message: ex.toString());
    }
  }

  /// Perform get club member success.
  void _getClubMembersSuccess(dio.Response response) {
    hideGlobalLoading();
    ClubMemberResponseModel clubMemberResponseModel =
        ClubMemberResponseModel.fromJson(response.data);
    if (clubMemberResponseModel.status == true) {
      final president = clubMemberResponseModel.data?.president ?? [];

      if (president.isEmpty) {
        /// Navigate to add board members.
        _navigateToBoardMembers();
      } else {
        /// Navigate to club dashboard.
        _navigateToClubDashboard();
      }
    }
  }

  /// Perform api error.
  void _getBoardMembersError(dio.Response response) {
    hideGlobalLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }

  /// Navigate to add board members.
  void _navigateToBoardMembers() {
    final signupRequestModel = _prepareSignUpDataForClub();
    Get.offAllNamed(Routes.CLUB_BOARD_MEMBERS, arguments: {
      RouteArguments.signupData: signupRequestModel,
      RouteArguments.message: AppString.addClubBoardMembersMessage,
      RouteArguments.sportTypeEnum: SportTypeEnum.PENDING_PROFILE
    });
  }

  /// Navigate to new password.
  void _navigateToResetPassword() {
    Get.offAllNamed(Routes.NEW_PASSWORD,
        arguments: {RouteArguments.email: _email});
  }

  /// Navigate to club dashboard screen.
  void _navigateToClubDashboard() {
    Get.offAllNamed(Routes.CLUB_MAIN);
  }

  /// Navigate to player dashboard.
  void _navigateToPlayerDashboard() {
    Get.offAllNamed(Routes.PLAYER_MAIN);
  }

  /// Reset timer widget.
  void resetTimer() {
    startTimer();
  }

  /// Prepare signup model to store data in signUpData.
  SignUpData _prepareSignUpDataForClub() {
    final signUpData = SignUpData();
    UserDetails? userDetails = GetIt.I<PreferenceManager>().getUserDetails();
    List<SelectionModel> sports = [];
    for (var element in (userDetails?.userSportsDetails ?? [])) {
      sports.add(SelectionModel.withoutIcon(
          title: element.sportTypeDetails?.name,
          itemId: element.sportTypeDetails?.id ?? -1));
    }
    signUpData.sportType = sports;
    signUpData.clubName = userDetails?.name ?? "";
    signUpData.clubPhoneNumber = userDetails?.phoneNumber ?? "";
    signUpData.clubAddress = userDetails?.address ?? "";
    signUpData.clubEmail = userDetails?.email ?? "";
    signUpData.clubVideo = userDetails?.video ?? "";
    signUpData.clubIntro = userDetails?.introduction ?? "";
    signUpData.clubBio = userDetails?.bio ?? "";
    signUpData.clubOtherInformation = userDetails?.referenceAndInfo ?? "";
    // for (var element in userDetails.add) {
    //   signUpData.clubImages?.add(element.path ?? "");
    // }

    return signUpData;
  }

  /// start timer from 30 to 0.
  void startTimer() {
    if (counterTime.value != 0) {
      return;
    }
    otpTextFieldController.clear();
    CommonUtils.showSuccessSnackBar(message: AppString.resendOTPSuccess);
    counterTime.value = 30;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (counterTime.value == 0) {
          timer.cancel();
        } else {
          counterTime.value--;
        }
      },
    );
  }

  /// Verify Login OTP api response.
  Future<void> _verifyLoginOTP() async {
    try {
      if (await NetworkConnectivity.instance.hasNetwork()) {
        showGlobalLoading();
        final response = await _provider.verifyLoginPasswordOTP(
            email: _email, otp: otpTextFieldController.text);

        if (response.statusCode == NetworkConstants.success) {
          verifyEmailOTPSuccess(response);
        } else {
          verifyOtpError(response);
        }
      }
    } catch (ex) {
      logger.e(ex);
      hideGlobalLoading();
      CommonUtils.showErrorSnackBar(message: ex.toString());
    }
  }

  /// Verify Login OTP api response.
  Future<void> _verifyForgotPasswordOTP() async {
    try {
      if (await NetworkConnectivity.instance.hasNetwork()) {
        showGlobalLoading();
        final response = await _provider.verifyForgotPasswordOTP(
            email: _email, otp: otpTextFieldController.text);

        if (response.statusCode == NetworkConstants.success) {
          _forgotPasswordOTPSuccess(response);
        } else {
          verifyOtpError(response);
        }
      }
    } catch (ex) {
      logger.e(ex);
      hideGlobalLoading();
      CommonUtils.showErrorSnackBar(message: ex.toString());
    }
  }

  /// API for resend OTP to user email.
  Future<void> resendOTPAPI() async {
    try {
      if (await NetworkConnectivity.instance.hasNetwork()) {
        showGlobalLoading();
        final response = await _provider.resendOTP(email: _email);

        if (response.statusCode == NetworkConstants.success) {
          _resendOTPSuccess(response);
        } else {
          verifyOtpError(response);
        }
      }
    } catch (ex) {
      logger.e(ex);
      hideGlobalLoading();
      CommonUtils.showErrorSnackBar(message: ex.toString());
    }
  }

  /// Resend OTP success.
  Future<void> _resendOTPSuccess(dio.Response response) async {
    hideGlobalLoading();
    resetTimer();
  }

  /// verify otp error
  void verifyOtpError(dio.Response response) {
    hideGlobalLoading();
    otpTextFieldController.clear();
    otpFocusNode.requestFocus();
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }

  /// Login user in firebase
  void _loginWithFirebase() async {
    String lastLoginDateAndTime = DateTime.now().toIso8601String();

    final DeviceInfoModel objDeviceModel =
        Get.find(tag: AppConstants.DEVICE_INFO_KEY);

    //Save user and application detail
    FirebaseAuthManager.instance.loginUserWithEmailAndPassword(
      _email.trim(),
      GetIt.I<CommonUtils>().getUserPassword(),
      (uuid) async {
        UserDetails? userDetails =
            GetIt.I<PreferenceManager>().getUserDetails();
        GetIt.I<PreferenceManager>().setFirebaseChatUserId(uuid);
        GetIt.I<PreferenceManager>().setFirebaseUUID(uuid);

        /// Step2 : Update user detail is firebase user document
        await GetIt.I<FireStoreManager>().saveUserData(
          email: _email,
          uuid: uuid,
          userId: GetIt.I<PreferenceManager>().userId.toString(),
          deviceType: objDeviceModel.deviceType ?? "",
          buildNumber: objDeviceModel.uuid ?? "",
          userName: userDetails?.name ?? "",
          userType: GetIt.I<PreferenceManager>().getUserType,
          lastLoginDateAndTime: lastLoginDateAndTime,
          version: objDeviceModel.buildVersion ?? "",
        );

        _navigateToScreen();
      },
      (error) {
        print("loginUserWithEmailAndPassword $error");
        if (error.contains("firebase_auth/user-not-found")) {
          _registerUserWithFireBase(
            email: _email,
            deviceType: objDeviceModel.deviceType ?? "",
            buildNumber: objDeviceModel.uuid ?? "",
            lastLoginDateAndTime: lastLoginDateAndTime,
            version: objDeviceModel.buildVersion ?? "",
          );
        }
        GetIt.I<CommonUtils>().showSomethingIssueError();
        hideGlobalLoading();
      },
    );
  }

  /// Register new user if the user is not exists in firebase.
  ///
  /// required [email]
  /// required [deviceType]
  /// required [buildNumber]
  /// required [version]
  /// required [lastLoginDateAndTime]
  void _registerUserWithFireBase({
    String email = "",
    String deviceType = "",
    String buildNumber = "",
    String version = "",
    String lastLoginDateAndTime = "",
  }) {
    //Save user and application detail
    FirebaseAuthManager.instance.registerUserWithEmailAndPassword(
      email.trim(),
      GetIt.I<CommonUtils>().getUserPassword(),
      (uuid) async {
        UserDetails? userDetails =
            GetIt.I<PreferenceManager>().getUserDetails();

        /// Step2 : Update user detail is firebase user document
        await GetIt.I<FireStoreManager>().saveUserData(
            email: email.trim(),
            uuid: uuid,
            userId: GetIt.I<PreferenceManager>().userId.toString(),
            isRegisterUser: true,
            userName: userDetails?.name ?? "",
            deviceType: deviceType,
            buildNumber: buildNumber,
            lastLoginDateAndTime: lastLoginDateAndTime,
            version: version);
        GetIt.I<PreferenceManager>().setFirebaseUUID(uuid);
        _navigateToScreen();
      },
      (error) {
        print("_registerUserWithFireBase $error");
        isLoading.value = false;
      },
    );
  }

  _navigateToScreen() {
    if (GetIt.I<PreferenceManager>().isClub) {
      getClubBoardMembers();
    } else {
      hideGlobalLoading();
      _navigateToPlayerDashboard();
    }
  }
}

enum VerifyTypeEnum { LOGIN, FORGOT_PASSWORD }
