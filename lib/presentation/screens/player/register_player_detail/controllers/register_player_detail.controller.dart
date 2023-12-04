import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:game_on_flutter/values/app_constant.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../../infrastructure/firebase/firebase_auth_manager.dart';
import '../../../../../infrastructure/firebase/firestore_manager.dart';
import '../../../../../infrastructure/model/club/post/post_list_model.dart';
import '../../../../../infrastructure/model/club/profile/upload_user_profile_response.dart';
import '../../../../../infrastructure/model/club/signup/club_signup_data.dart';
import '../../../../../infrastructure/model/club/signup/selection_model.dart';
import '../../../../../infrastructure/model/common/app_fields.dart';
import '../../../../../infrastructure/model/common/sportstype_response_model.dart';
import '../../../../../infrastructure/model/device_info_model.dart';
import '../../../../../infrastructure/model/signup_response_model.dart';
import '../../../../../infrastructure/model/user_info_model.dart';
import '../../../../../infrastructure/navigation/route_config.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../infrastructure/network/api_utils.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../infrastructure/storage/preference_manager.dart';
import '../../../../../values/app_colors.dart';
import '../../../../../values/app_string.dart';
import '../../../../../values/app_values.dart';
import '../../../../../values/common_utils.dart';
import '../../../../app_widgets/app_dialog_widget.dart';
import '../../../../app_widgets/app_loading_mixin.dart';
import '../../../../app_widgets/form_validation_mixin.dart';
import '../../../../app_widgets/image_capture_helper.dart';
import '../../../../app_widgets/user_feature_mixin.dart';
import '../../../club/club_profile/controllers/user_detail_controller.dart';
import '../../../club/signup/register_club_details/controllers/register_club_details.controller.dart';
import '../../../club/signup/register_club_details/model/location_data_model.dart';
import '../providers/register_player_detail_provider.dart';

class RegisterPlayerDetailController extends GetxController
    with FormValidationMixin, UserFeatureMixin, AppLoadingMixin {
  /// Text editing controller
  late TextEditingController nameController;
  late TextEditingController phoneNumberController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController videoController;
  late TextEditingController introController;
  late TextEditingController bioController;
  late TextEditingController referenceController;
  late TextEditingController heightController;
  late TextEditingController weightController;
  late TextEditingController dobController;

  /// Focus node
  late FocusNode nameFocusNode;
  late FocusNode phoneNumberFocusNode;
  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;
  late FocusNode videoFocusNode;
  late FocusNode introFocusNode;
  late FocusNode bioFocusNode;
  late FocusNode referenceFocusNode;
  late FocusNode heightFocusNode;
  late FocusNode weightFocusNode;
  late FocusNode dobFocusNode;

  /// error text widget
  RxString clubNameError = "".obs;
  RxString phoneNumberError = "".obs;
  RxString emailError = "".obs;
  RxString passwordError = "".obs;
  RxString heightError = "".obs;
  RxString weightError = "".obs;
  RxString dobError = "".obs;
  RxString videoError = "".obs;

  /// Player profile image
  Rx<PostImages> playerProfileImage = PostImages().obs;

  /// Initialise image capture helper
  final _imageHelper = ImageCaptureHelper();

  /// bool to check field are valid or not.
  ///
  /// if true then enable button.
  RxBool isValidField = RxBool(false);

  RxBool enableAddIcon = RxBool(true);

  RxBool enableViewAll = RxBool(false);

  /// Stores form key
  final formKey = GlobalKey<FormState>();

  /// Stores edit detail bool
  PlayerDetailViewTypeEnum playerDetailViewTypeEnum =
      PlayerDetailViewTypeEnum.register;

  /// Club detail provides
  final _provider = RegisterPlayerDetailProvider();

  /// Local fields
  Rx<SelectionModel> gender = SelectionModel().obs;

  String _name = "";
  String _phoneNumber = "";
  String _email = "";
  String _password = "";
  String _video = "";
  String _intro = "";
  String _bio = "";
  String _height = "";
  String _weight = "";
  String _dateOfBirth = "";
  String _reference = "";

  /// signup data.
  SignUpData? signUpData;

  ///list of  images.
  RxList<ClubProfileImage> playerImages = RxList();

  /// Gender list
  List<SelectionModel> genders = [];

  final logger = Logger();

  @override
  void onInit() {
    _initialiseFields();
    _getArguments();
    super.onInit();
  }

  /// Setup initial fields.
  void _initialiseFields() {
    nameController = TextEditingController(text: "");
    phoneNumberController = TextEditingController(text: "");
    emailController = TextEditingController(text: "");
    passwordController = TextEditingController(text: "");
    videoController = TextEditingController(text: "");
    introController = TextEditingController(text: "");
    bioController = TextEditingController(text: "");
    referenceController = TextEditingController(text: "");
    heightController = TextEditingController(text: "");
    weightController = TextEditingController(text: "");
    dobController = TextEditingController(text: "");

    nameFocusNode = FocusNode();
    phoneNumberFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    videoFocusNode = FocusNode();
    introFocusNode = FocusNode();
    bioFocusNode = FocusNode();
    referenceFocusNode = FocusNode();
    heightFocusNode = FocusNode();
    weightFocusNode = FocusNode();
    dobFocusNode = FocusNode();
  }

  /// Get argument from previous screen
  void _getArguments() async {
    if (Get.arguments != null) {
      signUpData = Get.arguments[RouteArguments.signupData] ??
          SignUpData.prepareDummyDataForPlayer();

      playerDetailViewTypeEnum = Get.arguments[RouteArguments.playerViewType] ??
          PlayerDetailViewTypeEnum.register;

      _prepareGenderList();

      if (playerDetailViewTypeEnum != PlayerDetailViewTypeEnum.register) {
        _getUserDetails();
      }
    }
  }

  /// get user details API.
  void _getUserDetails() async {
    final UserDetailService service = Get.find(tag: AppConstants.USER_DETAILS);
    if ((service.userDetails.value.email ?? "").isEmpty) {
      await service.getUserDetails();
    }
    _setPlayerDetail(service.userDetails.value);
  }

  /// Set club details
  void _setPlayerDetail(UserDetails userDetails) {
    String convertedDate =
        CommonUtils.ddmmmyyyyDateWithTimezone2(userDetails.dateOfBirth ?? "");
    nameController.text = userDetails.name ?? "";
    dobController.text = convertedDate;
    heightController.text = userDetails.height ?? "";
    weightController.text = userDetails.weight ?? "";
    phoneNumberController.text = userDetails.phoneNumber ?? "";
    emailController.text = userDetails.email ?? "";
    videoController.text = userDetails.video ?? "";
    bioController.text = userDetails.bio ?? "";
    referenceController.text = userDetails.referenceAndInfo ?? "";

    _setGenderToRadioButton(userDetails.gender ?? (genders.first.title ?? ""));
    setName(userDetails.name ?? "");
    setDateOfBirth(convertedDate);
    setHeight(userDetails.height ?? "");
    setWeight(userDetails.weight ?? "");
    setPhoneNumber(userDetails.phoneNumber ?? "");
    setEmail(userDetails.email ?? "");
    setVideo(userDetails.video ?? "");
    setBio(userDetails.bio ?? "");
    setClubOtherInformation(userDetails.referenceAndInfo ?? "");

    userDetails.userPhotos?.forEach((element) {
      playerImages.add(ClubProfileImage(
        '${AppFields.instance.imagePrefix}${element.image}',
        element.id,
        true,
      ));
    });
    playerProfileImage.value =
        PostImages(image: userDetails.profileImage ?? "", isUrl: true);
    _checkValidation();
  }

  /// Set user gender to selection.
  void _setGenderToRadioButton(String gender) {
    this.gender.value = genders.firstWhere((element) =>
        (element.title ?? "").toLowerCase() == gender.toLowerCase());
  }

  /// Return true if all the validation completed otherwise
  /// false and show error to the UI.
  bool _checkForAdditionalValidation() {
    final validVideoURL = validUrl;
    if (!validVideoURL) {
      videoError.value = AppString.videoURLErrorMessage;
      CommonUtils.showErrorSnackBar(message: AppString.videoURLErrorMessage);
      return false;
    }

    final validEmailId = isValidEmail;
    if (!validEmailId) {
      emailError.value = AppString.emailErrorMessage;
      CommonUtils.showErrorSnackBar(message: AppString.emailErrorMessage);
      return false;
    }
    return true;
  }

  /// on Submit called.
  void onSubmit() {
    if (formKey.currentState!.validate()) {
      _clearFieldErrors();
      if (_checkForAdditionalValidation()) {
        _preparePlayerData();
        if (playerDetailViewTypeEnum != PlayerDetailViewTypeEnum.register) {
          updatePlayerDetailAPI();
        } else {
          _signupPlayer();
        }
      }
    } else {
      _checkValidation();
      CommonUtils.showErrorSnackBar(
          message: AppString.invalidFormValidationErrorMessage);
    }
  }

  /// Prepare player data.
  void _preparePlayerData() {
    signUpData?.playerName = _name;
    signUpData?.playerPhoneNumber = _phoneNumber;
    signUpData?.playerEmail = _email;
    signUpData?.playerPassword = _password;
    signUpData?.playerVideo = _video;
    signUpData?.intro = _intro;
    signUpData?.bio = _bio;
    signUpData?.reference = _reference;
    signUpData?.height = _height;
    signUpData?.weight = _weight;
    signUpData?.dob = _dateOfBirth;
    signUpData?.playerGender = gender.value.title ?? "";
    for (var element in playerImages) {
      signUpData?.playerImages?.add(element.path ?? "");
    }
  }

  /// Login user in firebase
  void _loginWithFirebase() async {
    String version = "";
    String buildNumber = "";
    String deviceType = GetPlatform.isAndroid ? "Android" : "iOS";
    String lastLoginDateAndTime = DateTime.now().toIso8601String();

    await PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });

    //Save user and application detail
    FirebaseAuthManager.instance.loginUserWithEmailAndPassword(
      _email.trim(),
      GetIt.I<CommonUtils>().getUserPassword(),
      (uuid) async {
        /// Step2 : Update user detail is firebase user document
        await GetIt.I<FireStoreManager>().saveUserData(
            email: _email.trim(),
            uuid: uuid,
            deviceType: deviceType,
            buildNumber: buildNumber,
            userName: signUpData?.playerName ?? "",
            userId: GetIt.I<PreferenceManager>().userId.toString(),
            isRegisterUser: true,
            phoneNumber: signUpData?.playerPhoneNumber ?? "",
            userType: AppConstants.userTypePlayer,
            lastLoginDateAndTime: lastLoginDateAndTime,
            version: version);

        GetIt.I<PreferenceManager>().setUserName(
          signUpData?.playerName ?? "",
        );
        GetIt.I<PreferenceManager>().setUserEmail(
          signUpData?.playerEmail ?? "",
        );
        GetIt.I<PreferenceManager>().setUserProfile('');

        GetIt.I<PreferenceManager>().setFirebaseChatUserId(uuid);
        GetIt.I<PreferenceManager>().setFirebaseUUID(uuid);
        _navigateToDashboard();
      },
      (error) {
        print("loginUserWithEmailAndPassword $error");
        if (error.contains("firebase_auth/user-not-found")) {
          _registerUserWithFireBase(
            email: _email,
            version: version,
            deviceType: deviceType,
            lastLoginDateAndTime: lastLoginDateAndTime,
            buildNumber: buildNumber,
          );
        } else {
          hideGlobalLoading();
        }
      },
    );
  }

  /// Edit success message.
  void _navigateToScreen() {
    isValidField.value = false;
    if (playerDetailViewTypeEnum == PlayerDetailViewTypeEnum.playerSettings) {
      CommonUtils.showSuccessSnackBar(message: AppString.detailsUpdateSuccess);

      Future.delayed(
          const Duration(seconds: AppValues.successMessageDetailInSec), () {
        Get.until((route) => route.settings.name == Routes.PLAYER_MAIN);
      });
    } else if (playerDetailViewTypeEnum ==
        PlayerDetailViewTypeEnum.editPlayerDetail) {
      CommonUtils.showSuccessSnackBar(message: AppString.profileUpdateSuccess);

      Future.delayed(
          const Duration(seconds: AppValues.successMessageDetailInSec), () {
        Get.until((route) => route.settings.name == Routes.PLAYER_MAIN);
      });
    } else {
      Future.delayed(
          const Duration(seconds: AppValues.successMessageDetailInSec), () {
        Get.offAllNamed(Routes.PLAYER_MAIN);
      });
    }
  }

  /// Check for each field and return with true if all fields are
  /// validate otherwise false.
  void _checkValidation() {
    isValidField.value = _name.isNotEmpty &&
        _phoneNumber.isNotEmpty &&
        _email.isNotEmpty &&
        (playerDetailViewTypeEnum == PlayerDetailViewTypeEnum.register
            ? _password.isNotEmpty
            : true);
  }

  /// Return true if video url entered by the user is valid otherwise false.
  bool get validUrl =>
      _video.trim().isEmpty ? true : Uri.parse(_video.trim()).isAbsolute;

  bool get isValidEmail => _email.trim().isEmail;

  /// Clear all fields.
  void _clearFieldErrors() {
    clubNameError.value = "";
    phoneNumberError.value = "";
    emailError.value = "";
    passwordError.value = "";
    videoError.value = "";
    dobError.value = "";
    weightError.value = "";
    heightError.value = "";
  }

  /// Capture image from internal storage.
  void captureImageFromInternal() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (playerProfileImage.value.imageAvailable) {
      removeProfileConfirmationDialog();
      return;
    }

    final capturedImage =
        await _imageHelper.getImage(onRemoveImage: removeProfile);
    if (capturedImage.isNotEmpty) {
      _cropImage(File(capturedImage));
    }
  }

  ///[OPEN] Image preview and crop
  void _cropImage(File newFile) async {
    final imageCropper = ImageCropper();

    CroppedFile? croppedFile = await imageCropper.cropImage(
      sourcePath: newFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      cropStyle: CropStyle.circle,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: AppColors.appWhiteButtonTextColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
        )
      ],
    );
    if (croppedFile != null) {
      playerProfileImage.value =
          PostImages(image: croppedFile.path, isUrl: false);
      playerProfileImage.refresh();
    }
  }

  ///Remove user profile
  void removeProfile() {
    playerProfileImage.value.image = '';
  }

  /// Set name.
  void setName(String value) {
    _name = value;
    _checkValidation();
  }

  void onNameSubmit(String text) {
    if (dateOfBirth.isEmpty) {
      dobFocusNode.requestFocus();
    }
  }

  /// Set phone number.
  void setPhoneNumber(String value) {
    _phoneNumber = value;
    _checkValidation();
  }

  /// Set email.
  void setEmail(String value) {
    _email = value;
    _checkValidation();
  }

  /// Set password.
  void setPassword(String value) {
    _password = value;
    _checkValidation();
  }

  /// Set video.
  void setVideo(String value) {
    _video = value;
  }

  /// Set intro.
  void setIntro(String value) {
    _intro = value;
  }

  /// Set bio.
  void setBio(String value) {
    _bio = value;
  }

  /// Set other information.
  void setClubOtherInformation(String value) {
    _reference = value;
  }

  /// set [_gender] value
  void setGender(SelectionModel value) {
    gender.value = value;
  }

  /// set [_height] value
  void setHeight(String value) {
    _height = value;
  }

  /// set [_weight] value
  void setWeight(String value) {
    _weight = value;
  }

  /// set [_dateOfBirth] value
  void setDateOfBirth(String value) {
    _dateOfBirth = value;
  }

  /// return [_dateOfBirth] text
  String get dateOfBirth => _dateOfBirth;

  /// capture images.
  void capturePlayerAdditionalImage() async {
    final remainingImageToFill = getRemainingImageToFillCount();
    if (remainingImageToFill == 0) {
      CommonUtils.showInfoSnackBar(message: AppString.imageMaxLengthExceed);
      return;
    }
    final capturedImage = await _imageHelper.getMultipleImage();

    if (capturedImage.isEmpty) {
      return;
    }

    /// Check if user selected images are less or same to remaining size.
    if (remainingImageToFill >= capturedImage.length) {
      showGlobalLoading();
      if (capturedImage.isNotEmpty) {
        for (var element in capturedImage) {
          playerImages.add(ClubProfileImage(element, -1, false));
        }
      }
      hideGlobalLoading();
      _checkForMaxImageAllowed();
    } else {
      CommonUtils.showInfoSnackBar(message: AppString.imageMaxLengthExceed);
      showGlobalLoading();

      /// split selected image list to new list.
      final splitCaptureImages = capturedImage.sublist(0, remainingImageToFill);
      if (splitCaptureImages.isNotEmpty) {
        for (var element in splitCaptureImages) {
          playerImages.add(ClubProfileImage(element, -1, false));
        }
      }
      hideGlobalLoading();
      _checkForMaxImageAllowed();
    }

    _checkForMaxImageAllowed();
  }

  /// add image to list from edit additional image.
  void addImageList(List<ClubProfileImage> splitCaptureImages) {
    for (var element in splitCaptureImages) {
      playerImages.add(element);
    }
    _checkForMaxImageAllowed();
  }

  /// Navigate to additional image view.
  void navigateToAdditionalImage() {
    Get.toNamed(Routes.EDITABLE_ADDITIONAL_PHOTOS,
        arguments: {RouteArguments.images: playerImages});
  }

  /// return remaining images length count.
  int getRemainingImageToFillCount() {
    // MULTI_IMAGE_MAX_SIZE
    final imageLength = playerImages.length;
    return AppConstants.MULTI_IMAGE_MAX_SIZE - imageLength;
  }

  /// Remove captured image from the list.
  void removeImageFromPosition(int index) {
    if (playerImages[index].isURL) {
      deleteUserAdditionalImage(index);
    } else {
      playerImages.removeAt(index);
      _checkForMaxImageAllowed();
    }
  }

  /// Disable add image button if image max limit reached.
  void _checkForMaxImageAllowed() {
    enableAddIcon.value = getRemainingImageToFillCount() > 0;
    enableViewAll.value = playerImages.length >= AppConstants.MAX_IMAGE_TO_SHOW;
    enableAddIcon.refresh();
  }

  /// Update player detail API.
  void updatePlayerDetailAPI() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showGlobalLoading();

      final DeviceInfoModel objDeviceModel =
          Get.find(tag: AppConstants.DEVICE_INFO_KEY);
      String convertedDate = CommonUtils.yyyymmddDate(dateOfBirth);
      dio.Response? response = await _provider.updatePlayerDetail(
          playerName: signUpData?.playerName ?? "",
          phoneNumber: signUpData?.playerPhoneNumber ?? "",
          email: signUpData?.playerEmail ?? "",
          video: signUpData?.playerVideo ?? "",
          bio: signUpData?.bio ?? "",
          dateOfBirth: convertedDate,
          height: signUpData?.height ?? "",
          weight: signUpData?.weight ?? "",
          reference: signUpData?.reference ?? "",
          type: AppConstants.userTypePlayerInWord,
          address: signUpData?.playerAddress ?? "",
          profilePicture: (playerProfileImage.value.imageAvailable &&
                  !playerProfileImage.value.isUrl)
              ? File(playerProfileImage.value.image ?? "")
              : File(''),
          additionalImage: playerImages.value,
          introduction: '',
          sportTypeId: (signUpData?.sportType ?? []).isNotEmpty
              ? (signUpData?.sportType ?? []).first.itemId
              : -1,
          levelDetail: (signUpData?.playerLevel ?? []).isNotEmpty
              ? (signUpData?.playerLevel ?? []).map((e) => e.itemId).toList()
              : [],
          gender: signUpData?.playerGender ?? "",
          uuid: objDeviceModel.uuid ?? "",
          osVersion: objDeviceModel.osVersion ?? "",
          deviceName: objDeviceModel.deviceName ?? '',
          modelName: objDeviceModel.modelName ?? "",
          deviceType: objDeviceModel.deviceType ?? '',
          ip: objDeviceModel.ip ?? '',
          locationDetail: (signUpData?.location ?? []).isNotEmpty
              ? (signUpData?.location ?? []).map((e) => e.itemId).toList()
              : [],
          playerPosition: (signUpData?.playerPosition ?? []).isNotEmpty
              ? (signUpData?.playerPosition ?? []).map((e) => e.itemId).toList()
              : []);

      if (response.statusCode == NetworkConstants.success) {
        /// On success
        _updatePlayerDetailSuccess(response);
      } else {
        /// On Error
        _updatePlayerDetailError(response);
      }
    } else {
      hideGlobalLoading();
      GetIt.I<CommonUtils>().showServerDownError();
    }
  }

  /// Add club detail API.
  void _signupPlayer() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      FocusManager.instance.primaryFocus?.unfocus();
      showGlobalLoading();

      final DeviceInfoModel objDeviceModel =
          Get.find(tag: AppConstants.DEVICE_INFO_KEY);

      String convertedDate = CommonUtils.yyyymmddDate(signUpData?.dob ?? "");

      dio.Response? response = await _provider.registerPlayerDetail(
        playerName: signUpData?.playerName ?? "",
        phoneNumber: signUpData?.playerPhoneNumber ?? "",
        email: signUpData?.playerEmail ?? "",
        password: signUpData?.playerPassword ?? "",
        video: signUpData?.playerVideo ?? "",
        bio: signUpData?.bio ?? "",
        dateOfBirth: convertedDate,
        profilePicture: File(playerProfileImage.value.image ?? ""),
        additionalImage: playerImages.value,
        height: signUpData?.height ?? "",
        weight: signUpData?.weight ?? "",
        reference: signUpData?.reference ?? "",
        type: AppConstants.userTypePlayerInWord,
        address: signUpData?.playerAddress ?? "",
        introduction: '',
        sportTypeId: (signUpData?.sportType ?? []).isNotEmpty
            ? (signUpData?.sportType ?? []).first.itemId
            : -1,
        levelDetail: (signUpData?.playerLevel ?? []).isNotEmpty
            ? (signUpData?.playerLevel ?? []).map((e) => e.itemId).toList()
            : [],
        uuid: objDeviceModel.uuid ?? "",
        osVersion: objDeviceModel.osVersion ?? "",
        deviceName: objDeviceModel.deviceName ?? '',
        modelName: objDeviceModel.modelName ?? "",
        deviceType: objDeviceModel.deviceType ?? '',
        ip: objDeviceModel.ip ?? '',
        locationDetail: _getClubLocations(),
        playerPosition: (signUpData?.playerPosition ?? []).isNotEmpty
            ? (signUpData?.playerPosition ?? []).map((e) => e.itemId).toList()
            : [],
        gender: signUpData?.playerGender ?? "",
      );
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.created) {
          /// On success
          _addPlayerDetailSuccess(response);
        } else {
          /// On Error
          _updatePlayerDetailError(response);
        }
      } else {
        hideGlobalLoading();
        GetIt.I<CommonUtils>().showServerDownError();
      }
    } else {
      hideGlobalLoading();
      GetIt.I<CommonUtils>().showNetworkError();
    }
  }

  /// Remove club profile confirmation.
  void removeProfileConfirmationDialog() {
    Get.dialog(AppDialogWidget(
      onDone: onRemoveApprove,
      dialogText: AppString.removeClubProfileConfirmation,
    ));
  }

  /// Remove club logo profile
  void onRemoveApprove() {
    if (playerProfileImage.value.isUrl) {
      deleteUserProfile();
    } else {
      playerProfileImage.value.image = '';
      playerProfileImage.refresh();
    }
  }

  /// Add user additional images.
  void addUserAdditionalImagesAndProfile() async {
    try {
      if (await NetworkConnectivity.instance.hasNetwork()) {
        showGlobalLoading();

        dio.Response? response = await _provider.addUserImages(
            profilePicture: (playerProfileImage.value.imageAvailable &&
                    !playerProfileImage.value.isUrl)
                ? File(playerProfileImage.value.image ?? "")
                : File(''),
            additionalImage: playerImages.value);

        if (response.statusCode == NetworkConstants.success) {
          /// On success
          hideGlobalLoading();
          if (playerDetailViewTypeEnum != PlayerDetailViewTypeEnum.register) {
            final UserDetailService service =
                Get.find(tag: AppConstants.USER_DETAILS);
            await service.getUserDetails();
            hideGlobalLoading();
          }
          onCompleted();
        } else {
          /// On Error
          _onAPIError(response);
        }
      } else {
        hideGlobalLoading();
        GetIt.I<CommonUtils>().showNetworkError();
      }
    } catch (ex) {
      hideGlobalLoading();
      CommonUtils.showErrorSnackBar(message: ex.toString());
      logger.e(ex);
    }
  }

// Edit success message.
  void onCompleted() {
    isValidField.value = false;
    if (playerDetailViewTypeEnum == PlayerDetailViewTypeEnum.playerSettings ||
        playerDetailViewTypeEnum == PlayerDetailViewTypeEnum.editPlayerDetail) {
      CommonUtils.showSuccessSnackBar(message: AppString.detailsUpdateSuccess);
      Future.delayed(
          const Duration(seconds: AppValues.successMessageDetailInSec), () {
        Get.until((route) => route.settings.name == Routes.PLAYER_MAIN);
      });
    } else {
      Future.delayed(const Duration(milliseconds: 400), () {
        _loginWithFirebase();
      });
    }
  }

  /// Perform login api success
  void _addPlayerDetailSuccess(dio.Response response) {
    SignupResponse signupResponse = SignupResponse.fromJson(response.data);
    if (signupResponse.status == true) {
      if (signupResponse.data?.user != null) {
        GetIt.instance<PreferenceManager>()
            .setUserType(AppConstants.userTypePlayer);
        GetIt.instance<PreferenceManager>()
            .setUserId(signupResponse.data?.user?.id ?? -1);
        GetIt.instance<PreferenceManager>()
            .setUserDetails(signupResponse.data!.user!);
        GetIt.instance<PreferenceManager>()
            .setUserToken(signupResponse.data!.token ?? "");

        addUserAdditionalImagesAndProfile();
      } else {
        GetIt.I<CommonUtils>().showSomethingIssueError();
      }
    } else {
      hideGlobalLoading();
      GetIt.I<CommonUtils>().showSomethingIssueError();
    }
  }

  /// update player api success
  void _updatePlayerDetailSuccess(dio.Response response) async {
    addUserAdditionalImagesAndProfile();
  }

  /// Clear all fields.
  void _clearAllFields() {
    setName('');
    setPhoneNumber('');
    setDateOfBirth('');
    setEmail('');
    setVideo('');
    setIntro('');
    setBio('');

    nameController.clear();
    phoneNumberController.clear();
    dobController.clear();
    emailController.clear();
    videoController.clear();
    introController.clear();
    bioController.clear();
    passwordController.clear();
    heightController.clear();
    weightController.clear();
    referenceController.clear();
  }

  /// Perform api error.
  void _updatePlayerDetailError(dio.Response response) {
    hideGlobalLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
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
        /// Step2 : Update user detail is firebase user document
        await GetIt.I<FireStoreManager>().saveUserData(
            email: email.trim(),
            uuid: uuid,
            isRegisterUser: true,
            userName: signUpData?.playerName ?? "",
            userType: AppConstants.userTypeClub,
            userId: GetIt.I<PreferenceManager>().userId.toString(),
            deviceType: deviceType,
            buildNumber: buildNumber,
            phoneNumber: signUpData?.playerPhoneNumber ?? "",
            lastLoginDateAndTime: lastLoginDateAndTime,
            version: version);

        GetIt.I<PreferenceManager>().setUserName(
          signUpData?.playerName ?? "",
        );
        GetIt.I<PreferenceManager>().setUserEmail(
          signUpData?.playerEmail ?? "",
        );
        GetIt.I<PreferenceManager>().setUserProfile("");
        GetIt.I<PreferenceManager>().setFirebaseUUID(uuid);
        GetIt.I<PreferenceManager>().setFirebaseChatUserId(uuid);

        _navigateToDashboard();
      },
      (error) {
        logger.e(error);
        hideGlobalLoading();
      },
    );
  }

  /// navigate to player dashboard.
  void _navigateToDashboard() async {
    final UserDetailService service = Get.find(tag: AppConstants.USER_DETAILS);
    await service.getUserDetails(
        token: GetIt.I<PreferenceManager>().getUserToken);
    hideGlobalLoading();
    _clearAllFields();
    GetIt.I<PreferenceManager>().setLogin(true);
    Get.offAllNamed(Routes.PLAYER_MAIN);
  }

  /// Open date picker.
  void openDatePicker() async {
    final currentDate = DateTime.now();
    final startDate = DateTime(currentDate.year - 80);
    final endDate = DateTime(currentDate.year - 14);
    final datetime = dateOfBirth.isEmpty
        ? endDate
        : DateTime.parse(CommonUtils.yyyymmddDate(dateOfBirth));
    final DateTime? picked = await showDatePicker(
        context: Get.context!,
        initialDate: datetime,
        firstDate: startDate,
        lastDate: endDate);
    FocusManager.instance.primaryFocus?.unfocus();
    if (picked != null && picked != datetime) {
      final newFormattedDate = CommonUtils.ddmmmyyyyDate(picked.toString());
      dobController.text = newFormattedDate;
      setDateOfBirth(newFormattedDate);

      if (_height.isEmpty) {
        heightFocusNode.requestFocus();
      }
    }
  }

  /// Prepare gender list.
  void _prepareGenderList() {
    genders.addAll([
      SelectionModel.withoutIcon(title: AppString.male, itemId: 0),
      SelectionModel.withoutIcon(title: AppString.female, itemId: 1),
      SelectionModel.withoutIcon(title: AppString.jnrBoy, itemId: 2),
      SelectionModel.withoutIcon(title: AppString.jnrGirl, itemId: 3)
    ]);

    setGender(genders.first);
  }

  /// get player type API.
  Future<void> _getPlayerType() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showGlobalLoading();

      dio.Response? response = await _provider.getPlayerType();

      if (response.statusCode == NetworkConstants.success) {
        /// On success
        _getPlayerTypeSuccess(response);
      } else {
        /// On Error
        _getPlayerTypeError(response);
      }
    } else {
      hideGlobalLoading();
      GetIt.I<CommonUtils>().showNetworkError();
    }
  }

  /// Perform location api success
  void _getPlayerTypeSuccess(dio.Response response) {
    hideGlobalLoading();

    SportTypeListResponseModel model =
        SportTypeListResponseModel.fromJson(response.data);

    /// set items to the list.
    if (model.status == true) {
      for (var element in (model.data ?? [])) {
        genders.add(SelectionModel.withoutIcon(
            title: element.name, itemId: element.id));
      }
      setGender(genders.first);

      if (playerDetailViewTypeEnum != PlayerDetailViewTypeEnum.register) {
        _getUserDetails();
      }
    }
  }

  /// Perform location api error.
  void _getPlayerTypeError(dio.Response response) {
    hideGlobalLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }

  /// Return List<LocationDataModel> to the API.
  List<LocationDataModel> _getClubLocations() {
    List<LocationDataModel> clubLocations = [];
    for (SelectionModel element in (signUpData?.location ?? [])) {
      clubLocations.add(LocationDataModel(element.itemId));
    }
    return clubLocations;
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
          _onAPIError(response);
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

    playerProfileImage.value.image = "";

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
          _onAPIError(response);
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

    playerProfileImage.value.image = "";
    playerProfileImage.refresh();

    final UserDetailService service = Get.find(tag: AppConstants.USER_DETAILS);
    service.getUserDetails();
  }

  /// Perform api error.
  void _onAPIError(dio.Response response) {
    hideGlobalLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response, isFromLogin: true);
  }

  /// Delete user profile API.
  void deleteUserAdditionalImage(int index) async {
    try {
      if (await NetworkConnectivity.instance.hasNetwork()) {
        showGlobalLoading();
        dio.Response? response = await _provider.deleteUserAdditionalImage(
            imageId: playerImages[index].id ?? -1);
        if (response.statusCode == NetworkConstants.deleteSuccess) {
          /// On success
          _deleteUserAdditionalImageSuccess(response, index);
        } else {
          /// On Error
          _onAPIError(response);
        }
      }
    } catch (ex) {
      logger.e(ex);
      hideGlobalLoading();
      CommonUtils.showErrorSnackBar(message: ex.toString());
    }
  }

  /// Delete user additional image success
  void _deleteUserAdditionalImageSuccess(dio.Response response, int index) {
    hideGlobalLoading();
    playerImages.removeAt(index);
    _checkForMaxImageAllowed();
  }
}

enum PlayerDetailViewTypeEnum { register, playerSettings, editPlayerDetail }
