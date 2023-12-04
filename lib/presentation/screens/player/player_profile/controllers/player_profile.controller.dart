import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:game_on_flutter/presentation/app_widgets/app_dialog_with_title_widget.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../../../../infrastructure/model/club/post/post_list_model.dart';
import '../../../../../infrastructure/model/club/profile/upload_user_profile_response.dart';
import '../../../../../infrastructure/model/user_info_model.dart';
import '../../../../../infrastructure/navigation/route_config.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../infrastructure/network/api_utils.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../infrastructure/storage/preference_manager.dart';
import '../../../../../values/app_constant.dart';
import '../../../../../values/app_icons.dart';
import '../../../../../values/app_string.dart';
import '../../../../../values/common_utils.dart';
import '../../../../app_widgets/app_loading_mixin.dart';
import '../../../../app_widgets/image_capture_helper.dart';
import '../../../club/club_profile/controllers/club_profile.controller.dart';
import '../../../club/club_profile/controllers/user_detail_controller.dart';
import '../../register_player_detail/controllers/register_player_detail.controller.dart';
import '../providers/player_profile_provider.dart';

class PlayerProfileController extends GetxController with AppLoadingMixin {
  final menuList = [];

  /// Player profile image
  Rx<PostImages> playerProfileImage = PostImages().obs;

  RxString playerName = "".obs;

  RxString playerProfilePicture = "".obs;

  RxString playerEmail = "".obs;

  /// Initialise image capture helper
  final _imageHelper = ImageCaptureHelper();

  final _provider = PlayerProfileProvider();

  final logger = Logger();

  /// userDetails reactive model to update UI when its field changes.
  Rx<UserDetails> userDetails = UserDetails().obs;

  @override
  void onInit() {
    super.onInit();
    setFields();
    _prepareMenuList();
  }

  /// Set player Fields
  void setFields() {
    Future.delayed(const Duration(milliseconds: 400), () async {
      // Set listener value to the list.
      final UserDetailService userDetailService =
          Get.find(tag: AppConstants.USER_DETAILS);
      final userDetails = await userDetailService.getUserDetails();
      if (userDetails != null) {
        _setDataToField(userDetails);
      }
      // Add user detail update listener.
      userDetailService.userDetails.stream.listen((p0) {
        _setDataToField(userDetailService.userDetails.value);
      });
    });
  }

  /// Set user details.
  void _setDataToField(UserDetails userDetails) {
    playerName.value = userDetails.name ?? "";
    playerEmail.value = userDetails.email ?? "";
    if ((userDetails.profileImage ?? "").isNotEmpty) {
      playerProfileImage.value =
          PostImages(image: userDetails.profileImage, isUrl: true);
    } else {
      playerProfileImage.value = PostImages(image: '');
    }
  }

  /// on item click.
  void onItemClick(MenuModel model) {
    if (model.routeName.isNotEmpty) {
      if (model.routeName == Routes.REGISTER_PLAYER_DETAIL) {
        Get.toNamed(model.routeName, arguments: {
          RouteArguments.playerViewType:
              PlayerDetailViewTypeEnum.editPlayerDetail
        });
        return;
      }
      Get.toNamed(model.routeName,
          arguments: {RouteArguments.updateDetails: true});
    } else {
      if (model.title == AppString.logout) {
        _logOutDialog();
      } else if (model.title == AppString.deleteAccount) {
        _deleteAccountDialog();
      }
    }
  }

  /// Add user profile listener
  void addUserProfileListener() {
    final UserDetailService service = Get.find(tag: AppConstants.USER_DETAILS);
    service.userDetailsStreamController.stream.listen((s){
      userDetails.value = service.userDetails.value;
      _setDataToField(userDetails.value);
    });
    service.getUserDetails();
  }

  /// Prepare menu list.
  void _prepareMenuList() {
    menuList.add(MenuModel.prepare(
        title: AppString.updatePersonalInformation,
        menuIcon: AppIcons.infoIcon,
        isArrowShow: true,
        routeName: Routes.REGISTER_PLAYER_DETAIL));
    menuList.add(MenuModel.prepare(
        title: AppString.updateSettings,
        menuIcon: AppIcons.settingIcon,
        isArrowShow: true,
        routeName: Routes.SPORT_TYPE));
    menuList.add(MenuModel.prepare(
        title: AppString.profilePrivacy,
        menuIcon: AppIcons.profilePrivacy,
        isArrowShow: true,
        routeName: Routes.PLAYER_PROFILE_PRIVACY));
    menuList.add(MenuModel.prepare(
        title: AppString.changePassword,
        menuIcon: AppIcons.changePasswordIcon,
        isArrowShow: true,
        routeName: Routes.NEW_PASSWORD));
    menuList.add(MenuModel.prepare(
        title: AppString.deleteAccount,
        menuIcon: AppIcons.iconDelete,
        isArrowShow: false,
        routeName: ""));
    menuList.add(MenuModel.prepare(
        title: AppString.logout,
        menuIcon: AppIcons.logoutIcon,
        isArrowShow: false,
        routeName: ''));
  }

  /// Shows warning dialog before logout.
  void _logOutDialog() {
    Get.dialog(AppDialogWithTitleWidget(
      onDone: logoutAPI,
      dialogTitle: AppString.logoutTitle,
      dialogText: AppString.logOutMessage,
    ));
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

  /// do logout
  void _onLogout() {
    GetIt.I<PreferenceManager>().clearAll();
    Get.offAllNamed(Routes.WELCOME);
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
    playerProfileImage.value.image = "";
    UploadUserProfileResponse userDetailResponseModel =
        UploadUserProfileResponse.fromJson(response.data);

    GetIt.I<PreferenceManager>()
        .setUserProfile(userDetailResponseModel.data?.url ?? "");

    final UserDetailService service = Get.find(tag: AppConstants.USER_DETAILS);
    service.getUserDetails();
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
  void _deleteUserProfileSuccess(dio.Response response) async {
    removeProfile();
    final UserDetailService service = Get.find(tag: AppConstants.USER_DETAILS);
    await service.getUserDetails();
    hideGlobalLoading();
  }
}
