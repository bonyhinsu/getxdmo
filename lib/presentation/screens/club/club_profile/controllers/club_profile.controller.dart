import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:game_on_flutter/infrastructure/model/club/post/post_list_model.dart';
import 'package:game_on_flutter/infrastructure/navigation/route_config.dart';
import 'package:game_on_flutter/infrastructure/storage/preference_manager.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_dialog_with_title_widget.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_loading_mixin.dart';
import 'package:game_on_flutter/presentation/screens/club/club_profile/controllers/user_detail_controller.dart';
import 'package:game_on_flutter/presentation/screens/club/signup/register_club_details/controllers/register_club_details.controller.dart';
import 'package:game_on_flutter/values/app_constant.dart';
import 'package:game_on_flutter/values/app_icons.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:game_on_flutter/values/common_utils.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../../../../infrastructure/model/club/profile/upload_user_profile_response.dart';
import '../../../../../infrastructure/model/user_info_model.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../infrastructure/network/api_utils.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../app_widgets/image_capture_helper.dart';
import '../providers/club_profile_provider.dart';

class ClubProfileController extends GetxController with AppLoadingMixin {
  final menuList = [];

  Rx<PostImages> playerProfileImage = PostImages().obs;

  String clubName = "";

  RxString clubProfilePicture = "".obs;

  String clubEmail = "";

  /// Initialise image capture helper
  final _imageHelper = ImageCaptureHelper();

  /// userDetails reactive model to update UI when its field changes.
  Rx<UserDetails> userDetails = UserDetails().obs;

  final _provider = ClubProfileProvider();

  final logger = Logger();

  @override
  void onInit() {
    setFields();
    _prepareMenuList();
    super.onInit();
  }

  @override
  void onReady() {
    // SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
    //   addUserProfileListener();
    // });

    super.onReady();
  }

  /// Set club Fields
  void setFields() {
    Future.delayed(const Duration(milliseconds: 400), () {
      // Set listener value to the list.
      final UserDetailService userDetailService =
          Get.find(tag: AppConstants.USER_DETAILS);
      final userDetails = GetIt.I<PreferenceManager>().getUserDetails();
      if (userDetails != null) {
        _setDataToField(userDetails);
      }
      // Add user detail update listener.
      userDetailService.userDetailsStreamController.stream.listen((p0) {
        this.userDetails.value = userDetailService.userDetails.value;
        _setDataToField(userDetailService.userDetails.value);
      });
      userDetailService.getUserDetails();
    });

  }

  /// Set user details.
  void _setDataToField(UserDetails userDetails) {
    if ((userDetails.profileImage ?? "").isNotEmpty) {
      playerProfileImage.value =
          PostImages(image: userDetails.profileImage, isUrl: true);
    } else {
      playerProfileImage.value = PostImages(image: '');
    }
    playerProfileImage.refresh();
  }

  /// Add user profile listener
  void addUserProfileListener() {
    final UserDetailService service = Get.find(tag: AppConstants.USER_DETAILS);
    service.userDetails.stream.asBroadcastStream(
        onListen: (sub) => {userDetails.value = service.userDetails.value},
        onCancel: (sub) => sub.cancel());
    service.getUserDetails();
  }

  /// Prepare menu list.
  void _prepareMenuList() {
    userDetails.value =
        GetIt.I<PreferenceManager>().getUserDetails() ?? UserDetails();

    menuList.add(MenuModel.prepare(
        title: AppString.updateClubInformation,
        menuIcon: AppIcons.infoIcon,
        isArrowShow: true,
        routeName: Routes.REGISTER_CLUB_DETAILS));
    menuList.add(MenuModel.prepare(
        title: AppString.updateBoardMembers,
        menuIcon: AppIcons.groupIcon,
        isArrowShow: true,
        routeName: Routes.CLUB_BOARD_MEMBERS));
    menuList.add(MenuModel.prepare(
        title: AppString.updateCoachingStaff,
        menuIcon: AppIcons.iconCoachingStaff,
        isArrowShow: true,
        routeName: Routes.CLUB_COACHING_STAFF));
    menuList.add(MenuModel.prepare(
        title: AppString.updateContactInformation,
        menuIcon: AppIcons.callRedIcon,
        isArrowShow: true,
        routeName: Routes.OTHER_CONTACT_INFORMATION));
    menuList.add(MenuModel.prepare(
        title: AppString.managePost,
        menuIcon: AppIcons.imageIcon,
        isArrowShow: true,
        routeName: Routes.MANAGE_POST));
    menuList.add(MenuModel.prepare(
        title: AppString.updateCluSetting,
        menuIcon: AppIcons.settingIcon,
        isArrowShow: true,
        routeName: Routes.SPORT_TYPE));
    menuList.add(MenuModel.prepare(
        title: AppString.changePassword,
        menuIcon: AppIcons.changePasswordIcon,
        isArrowShow: true,
        routeName: Routes.NEW_PASSWORD));
    menuList.add(MenuModel.prepare(
        title: AppString.manageSubscriptions,
        isArrowShow: true,
        menuIcon: AppIcons.subscriptionIcon,
        routeName: Routes.MANAGE_SUBSCRIPTION));
    menuList.add(MenuModel.prepare(
        title: AppString.deleteAccount,
        isArrowShow: false,
        menuIcon: AppIcons.iconDelete,
        routeName: ""));
    menuList.add(MenuModel.prepare(
        title: AppString.logout,
        menuIcon: AppIcons.logoutIcon,
        isArrowShow: false,
        routeName: ''));
  }

  /// Check for message.
  void _checkForMessage(dynamic value) {
    if (value == null) {
      return;
    }
    if (value is String) {
      CommonUtils.showSuccessSnackBar(message: value);
    }
  }

  /// on item click.
  void onItemClick(MenuModel model) async {
    if (model.routeName.isNotEmpty) {
      if (model.routeName == Routes.REGISTER_CLUB_DETAILS) {
        await Get.toNamed(model.routeName, arguments: {
          RouteArguments.clubViewType: ClubDetailViewTypeEnum.editClubDetail
        })?.then((value) => _checkForMessage);
        return;
      }
      Get.toNamed(model.routeName,
              arguments: {RouteArguments.updateDetails: true})
          ?.then((value) => _checkForMessage);
    } else {
      if (model.title == AppString.logout) {
        _logOutDialog();
      } else if (model.title == AppString.deleteAccount) {
        _deleteAccountDialog();
      }
    }
  }

  /// Shows warning dialog before logout.
  void _logOutDialog() {
    Get.dialog(AppDialogWithTitleWidget(
      onDone: logoutAPI,
      dialogTitle: AppString.logoutTitle,
      dialogText: AppString.logOutMessage,
    ));
  }

  /// do logout
  void _onLogout() {
    GetIt.I<PreferenceManager>().clearAll();
    Get.offAllNamed(Routes.WELCOME);
  }

  /// Shows warning dialog before user request for delete account.
  void _deleteAccountDialog() {
    Get.dialog(AppDialogWithTitleWidget(
      onDone: deleteAccountAPI,
      dialogText: AppString.deleteAccountConfirmationMessage,
      dialogTitle: AppString.deleteAccount,
    ));
  }

  /// Capture image from internal storage
  void captureImageFromInternal() async {
    if ((playerProfileImage.value.image ?? "").isNotEmpty) {
      if (playerProfileImage.value.isUrl) {
        deleteUserProfile();
      } else {
        playerProfileImage.value.image = "";
      }
      return;
    }

    final capturedImage =
        await _imageHelper.getImage(onRemoveImage: removeProfile);
    if (capturedImage.isNotEmpty) {
      playerProfileImage.value.image = capturedImage;
      uploadUserProfile();
    }
  }

  ///Remove user profile
  void removeProfile() {
    // remove user profile which is picked by the user.
    if ((playerProfileImage.value.image ?? "").isNotEmpty) {
      playerProfileImage.value.image = "";
    }
  }

  /// logout API.
  void logoutAPI() async {
    try {
      if (await NetworkConnectivity.instance.hasNetwork()) {
        showGlobalLoading();
        dio.Response? response = await _provider.logoutUser();
        if (response.statusCode == NetworkConstants.deleteSuccess) {
          /// On success
          _logoutAPISuccess(response);
        } else {
          /// On Error
          _logoutAPIError(response);
        }
      }
    } catch (ex) {
      logger.e(ex);
      hideGlobalLoading();
      CommonUtils.showErrorSnackBar(message: ex.toString());
    }
  }

  /// Perform logout api success
  void _logoutAPISuccess(dio.Response response) {
    hideGlobalLoading();

    _onLogout();
  }

  /// Perform logout api error.
  void _logoutAPIError(dio.Response response) {
    hideGlobalLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response, isFromLogin: true);
  }

  /// Delete account API.
  void deleteAccountAPI() async {
    try {
      if (await NetworkConnectivity.instance.hasNetwork()) {
        showGlobalLoading();
        dio.Response? response = await _provider.deleteAccountUser();
        if (response.statusCode == NetworkConstants.deleteSuccess) {
          /// On success
          _logoutAPISuccess(response);
        } else {
          /// On Error
          _logoutAPIError(response);
        }
      }
    } catch (ex) {
      logger.e(ex);
      hideGlobalLoading();
      CommonUtils.showErrorSnackBar(message: ex.toString());
    }
  }

  /// Upload user profile API.
  void uploadUserProfile() async {
    try {
      if (await NetworkConnectivity.instance.hasNetwork()) {
        showGlobalLoading();
        dio.Response? response = await _provider
            .updateUserProfile(File(playerProfileImage.value.image ?? ""));
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _uploadUserProfileSuccess(response);
        } else {
          /// On Error
          _logoutAPIError(response);
        }
      }
    } catch (ex) {
      logger.e(ex);
      hideGlobalLoading();
      CommonUtils.showErrorSnackBar(message: ex.toString());
    }
  }

  /// Upload user profile success
  void _uploadUserProfileSuccess(dio.Response response) {
    hideGlobalLoading();

    UploadUserProfileResponse userDetailResponseModel =
        UploadUserProfileResponse.fromJson(response.data);

    GetIt.I<PreferenceManager>()
        .setUserProfile(userDetailResponseModel.data?.url ?? "");
    playerProfileImage.value =
        PostImages(isUrl: true, image: userDetailResponseModel.data?.url ?? "");
    final UserDetailService service = Get.find(tag: AppConstants.USER_DETAILS);
    service.getUserDetails();
    playerProfileImage.refresh();
  }

  /// Delete user profile API.
  void deleteUserProfile() async {
    try {
      if (await NetworkConnectivity.instance.hasNetwork()) {
        showGlobalLoading();
        dio.Response? response = await _provider.deleteUserProfileImage();
        if (response.statusCode == NetworkConstants.deleteSuccess) {
          /// On success
          _deleteUserProfileSuccess(response);
        } else {
          /// On Error
          _logoutAPIError(response);
        }
      }
    } catch (ex) {
      logger.e(ex);
      hideGlobalLoading();
      CommonUtils.showErrorSnackBar(message: ex.toString());
    }
  }

  /// Upload user profile success
  void _deleteUserProfileSuccess(dio.Response response) {
    hideGlobalLoading();

    removeProfile();
    GetIt.I<PreferenceManager>().setUserProfile("");

    final UserDetailService service = Get.find(tag: AppConstants.USER_DETAILS);
    service.getUserDetails();
  }
}

class MenuModel {
  String title;
  String menuIcon;
  String routeName;
  bool isArrowShow;

  MenuModel.prepare(
      {required this.title,
      required this.menuIcon,
      required this.routeName,
      required this.isArrowShow});
}
