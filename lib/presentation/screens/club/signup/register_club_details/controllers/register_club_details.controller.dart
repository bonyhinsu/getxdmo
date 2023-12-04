import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:game_on_flutter/infrastructure/model/common/app_fields.dart';
import 'package:game_on_flutter/infrastructure/model/user_info_model.dart';
import 'package:game_on_flutter/infrastructure/storage/preference_manager.dart';
import 'package:game_on_flutter/values/app_constant.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:game_on_flutter/values/app_values.dart';
import 'package:game_on_flutter/values/common_utils.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:logger/logger.dart';

import '../../../../../../infrastructure/model/club/post/post_list_model.dart';
import '../../../../../../infrastructure/model/club/profile/upload_user_profile_response.dart';
import '../../../../../../infrastructure/model/club/signup/club_signup_data.dart';
import '../../../../../../infrastructure/model/club/signup/selection_model.dart';
import '../../../../../../infrastructure/model/device_info_model.dart';
import '../../../../../../infrastructure/model/signup_response_model.dart';
import '../../../../../../infrastructure/navigation/route_config.dart';
import '../../../../../../infrastructure/navigation/routes.dart';
import '../../../../../../infrastructure/network/api_utils.dart';
import '../../../../../../infrastructure/network/network_config.dart';
import '../../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../../values/app_colors.dart';
import '../../../../../app_widgets/app_dialog_widget.dart';
import '../../../../../app_widgets/app_loading_mixin.dart';
import '../../../../../app_widgets/form_validation_mixin.dart';
import '../../../../../app_widgets/image_capture_helper.dart';
import '../../../../../app_widgets/user_feature_mixin.dart';
import '../../../club_profile/controllers/user_detail_controller.dart';
import '../model/location_data_model.dart';
import '../providers/club_details_provider.dart';

class RegisterClubDetailsController extends GetxController
    with FormValidationMixin, UserFeatureMixin, AppLoadingMixin {
  late TextEditingController clubNameController;
  late TextEditingController clubPhoneNumberController;
  late TextEditingController clubAddressController;
  late TextEditingController clubEmailController;
  late TextEditingController passwordController;
  late TextEditingController clubVideoController;
  late TextEditingController clubIntroController;
  late TextEditingController clubBioController;
  late TextEditingController clubOtherInformationController;

  late FocusNode clubNameFocusNode;
  late FocusNode clubPhoneNumberFocusNode;
  late FocusNode clubAddressFocusNode;
  late FocusNode clubEmailFocusNode;
  late FocusNode passwordFocusNode;
  late FocusNode clubVideoFocusNode;
  late FocusNode clubIntroFocusNode;
  late FocusNode clubBioFocusNode;
  late FocusNode clubOtherInformationFocusNode;

  RxString clubNameError = "".obs;
  RxString phoneNumberError = "".obs;
  RxString emailError = "".obs;
  RxString passwordError = "".obs;
  RxString videoError = "".obs;
  RxString addressError = "".obs;
  RxString introError = "".obs;
  RxString bioError = "".obs;
  RxString infoError = "".obs;

  /// Club profile image
  Rx<PostImages> clubProfileImage = PostImages().obs;

  /// Initialise image capture helper
  final _imageHelper = ImageCaptureHelper();

  /// bool to check field are valid or not.
  ///
  /// if true then enable button.
  RxBool isValidField = RxBool(false);

  /// Store and retrieve enable add icon.
  RxBool enableAddIcon = RxBool(true);

  /// Stores form key
  final formKey = GlobalKey<FormState>();

  /// Stores edit detail bool
  bool editDetails = false;

  /// Club detail provides
  final _provider = RegisterClubDetailsProvider();

  /// Store how club detail fields will react on each view type.
  ClubDetailViewTypeEnum clubDetailViewTypeEnum =
      ClubDetailViewTypeEnum.register;

  String _clubName = "";
  String _clubPhoneNumber = "";
  String _clubAddress = "";
  String _clubEmail = "";
  String _clubPassword = "";
  String _clubVideo = "";
  String _clubIntro = "";
  String _clubBio = "";
  String _clubOtherInformation = "";

  ///club signup data.
  SignUpData? signUpData;

  ///list of club images.
  RxList<ClubProfileImage> clubImages = RxList();

  ///Value is true when club images are exceed the max limit.
  RxBool enableViewAll = RxBool(false);

  ///logger.
  final logger = Logger();

  @override
  void onInit() {
    _initialiseFields();
    _getArguments();
    super.onInit();
  }

  /// Setup initial fields.
  void _initialiseFields() {
    clubNameController = TextEditingController(text: "");
    clubPhoneNumberController = TextEditingController(text: "");
    clubAddressController = TextEditingController(text: "");
    clubEmailController = TextEditingController(text: "");
    passwordController = TextEditingController(text: "");
    clubVideoController = TextEditingController(text: "");
    clubIntroController = TextEditingController(text: "");
    clubBioController = TextEditingController(text: "");
    clubOtherInformationController = TextEditingController(text: "");

    clubNameFocusNode = FocusNode();
    clubPhoneNumberFocusNode = FocusNode();
    clubAddressFocusNode = FocusNode();
    clubEmailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    clubVideoFocusNode = FocusNode();
    clubIntroFocusNode = FocusNode();
    clubBioFocusNode = FocusNode();
    clubOtherInformationFocusNode = FocusNode();

    clubAddressFocusNode.addListener(() {
      if (clubAddressFocusNode.hasFocus) {
        enableGooglePlaces();
      }
    });
  }

  /// Get argument from previous screen
  void _getArguments() {
    if (Get.arguments != null) {
      signUpData = Get.arguments[RouteArguments.signupData] ?? SignUpData();

      clubDetailViewTypeEnum = Get.arguments[RouteArguments.clubViewType] ??
          ClubDetailViewTypeEnum.register;

      if (clubDetailViewTypeEnum != ClubDetailViewTypeEnum.register) {
        getUserDetails();
      }
    }
  }

  /// get user details API.
  void getUserDetails() async {
    final UserDetailService service = Get.find(tag: AppConstants.USER_DETAILS);
    if ((service.userDetails.value.email ?? "").isEmpty) {
      await service.getUserDetails();
    }
    _setClubDetail(service.userDetails.value);
  }

  /// on Submit called.
  void onSubmit() {
    if (formKey.currentState!.validate()) {
      _clearFieldErrors();
      if (_checkForAdditionalValidation()) {
        FocusManager.instance.primaryFocus?.unfocus();
        _prepareData();
        if (clubDetailViewTypeEnum != ClubDetailViewTypeEnum.register) {
          updateClubDetailAPI();
        } else {
          signupClub();
        }
      }
    } else {
      isValidField.value = false;
      CommonUtils.showErrorSnackBar(
          message: AppString.invalidFormValidationErrorMessage);
    }
  }

  /// Set club details
  void _setClubDetail(UserDetails userDetails) {
    clubNameController.text = userDetails.name ?? "";
    clubPhoneNumberController.text = userDetails.phoneNumber ?? "";
    clubAddressController.text = userDetails.address ?? "";
    clubEmailController.text = userDetails.email ?? "";
    clubVideoController.text = userDetails.video ?? "";
    clubIntroController.text = userDetails.introduction ?? "";
    clubBioController.text = userDetails.bio ?? "";
    clubOtherInformationController.text = userDetails.referenceAndInfo ?? "";

    _clubName = userDetails.name ?? "";
    _clubPhoneNumber = userDetails.phoneNumber ?? "";
    _clubAddress = userDetails.address ?? "";
    _clubEmail = userDetails.email ?? "";
    setClubBio(userDetails.bio ?? "");
    setClubIntro(userDetails.introduction ?? "");
    setClubVideo(userDetails.video ?? "");
    setClubOtherInformation(userDetails.referenceAndInfo ?? "");
    if((userDetails.profileImage ?? "").isNotEmpty){
      clubProfileImage.value = PostImages(image: userDetails.profileImage ?? "",isUrl: true);
    }

    userDetails.userPhotos?.forEach((element) {
      clubImages.add(ClubProfileImage(
        '${AppFields.instance.imagePrefix}${element.image}',
        element.id,
        true,
      ));
    });

    _checkValidation();
  }

  /// navigate to club member
  void _navigateToClubMember() {
    _clearAllFields();
    Get.toNamed(Routes.CLUB_BOARD_MEMBERS,
        arguments: {RouteArguments.signupData: signUpData});
  }

  /// Prepare signup model to store data in signUpData.
  void _prepareData() {
    signUpData?.clubName = _clubName.trim();
    signUpData?.clubPhoneNumber = _clubPhoneNumber.trim();
    signUpData?.clubAddress = _clubAddress.trim();
    signUpData?.clubEmail = _clubEmail.trim();
    signUpData?.clubPassword = _clubPassword.trim();
    signUpData?.clubVideo = _clubVideo.trim();
    signUpData?.clubIntro = _clubIntro.trim();
    signUpData?.clubBio = _clubBio.trim();
    signUpData?.clubOtherInformation = _clubOtherInformation.trim();
    // for (var element in clubImages) {
    //   signUpData?.clubImages?.add(element.path ?? "");
    // }
  }

  /// Return true if video url entered by the user is valid otherwise false.
  bool get validUrl => _clubVideo.trim().isEmpty
      ? true
      : Uri.parse(_clubVideo.trim()).isAbsolute;

  /// Return true if all the validation completed otherwise
  /// false and show error to the UI.
  bool _checkForAdditionalValidation() {
    final validVideoURL = validUrl;
    if (!validVideoURL) {
      videoError.value = AppString.videoURLErrorMessage;
      CommonUtils.showErrorSnackBar(message: AppString.videoURLErrorMessage);
      return false;
    }
    return true;
  }

  /// Navigate to additional image view.
  void navigateToAdditionalImage() {
    Get.toNamed(Routes.EDITABLE_ADDITIONAL_PHOTOS,
        arguments: {RouteArguments.images: clubImages});
  }

  /// Edit success message.
  void onCompleted() {
    isValidField.value = false;
    if (clubDetailViewTypeEnum == ClubDetailViewTypeEnum.clubSettings) {
      final UserDetailService service = Get.find(tag: AppConstants.USER_DETAILS);
      service.getUserDetails();
      CommonUtils.showSuccessSnackBar(message: AppString.detailsUpdateSuccess);
      Future.delayed(
          const Duration(seconds: AppValues.successMessageDetailInSec), () {
        Get.until((route) => route.settings.name == Routes.CLUB_MAIN);
      });
    } else if (clubDetailViewTypeEnum ==
        ClubDetailViewTypeEnum.editClubDetail) {
      final UserDetailService service = Get.find(tag: AppConstants.USER_DETAILS);
      service.getUserDetails();
      CommonUtils.showSuccessSnackBar(message: AppString.profileUpdateSuccess);

      Future.delayed(
          const Duration(seconds: AppValues.successMessageDetailInSec), () {
        Get.until((route) => route.settings.name == Routes.CLUB_MAIN);
      });
    } else {
      _navigateToClubMember();
    }
  }

  /// Check for each field and return with true if all fields are
  /// validate otherwise false.
  void _checkValidation() {
    isValidField.value = _clubName.isNotEmpty &&
        _clubPhoneNumber.isNotEmpty &&
        _clubEmail.isNotEmpty &&
        (clubDetailViewTypeEnum == ClubDetailViewTypeEnum.register
            ? _clubPassword.isNotEmpty
            : true);
  }

  /// Clear all fields.
  void _clearFieldErrors() {
    clubNameError.value = "";
    phoneNumberError.value = "";
    emailError.value = "";
    passwordError.value = "";
    videoError.value = "";
  }

  /// Capture image from internal storage.
  void captureImageFromInternal() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (clubProfileImage.value.imageAvailable) {
      removeProfileConfirmationDialog();
      return;
    }

    final capturedImage =
        await _imageHelper.getImage(onRemoveImage: removeProfile);
    if (capturedImage.isNotEmpty) {
      _cropImage(File(capturedImage));
    }
  }

  ///Remove user profile
  void removeProfile() {
    clubProfileImage.value.image = '';
  }

  /// Set club name.
  setClubName(String value) {
    _clubName = value;
    _checkValidation();
  }

  /// Set club phone number.
  setClubPhoneNumber(String value) {
    _clubPhoneNumber = value;
    _checkValidation();
  }

  /// Set club address.
  setClubAddress(String value) {
    _clubAddress = value;
    _checkValidation();
  }

  /// Set club email.
  setClubEmail(String value) {
    _clubEmail = value;
    _checkValidation();
  }

  /// Set club password.
  setClubPassword(String value) {
    _clubPassword = value;
    _checkValidation();
  }

  /// Set club video.
  setClubVideo(String value) {
    _clubVideo = value;
  }

  /// Set club intro.
  setClubIntro(String value) {
    _clubIntro = value;
  }

  /// Set club bio.
  setClubBio(String value) {
    _clubBio = value;
  }

  /// Set club other information.
  setClubOtherInformation(String value) {
    _clubOtherInformation = value;
  }

  /// Remove club captured image from the list.
  void removeImageFromPosition(int index) {
    if (clubImages[index].isURL) {
      deleteUserAdditionalImage(index);
    } else {
      clubImages.removeAt(index);
      _checkForMaxImageAllowed();
    }
  }

  /// Disable add image button if image max limit reached.
  void _checkForMaxImageAllowed() {
    enableAddIcon.value = getRemainingImageToFillCount() > 0;
    enableViewAll.value = clubImages.length >= AppConstants.MAX_IMAGE_TO_SHOW;
    enableAddIcon.refresh();
  }

  /// Clear all fields.
  void _clearAllFields() {
    _clearFieldErrors();
    setClubName('');
    setClubPhoneNumber('');
    setClubAddress('');
    setClubEmail('');
    setClubVideo('');
    setClubIntro('');
    setClubBio('');

    clubNameController.clear();
    clubPhoneNumberController.clear();
    clubAddressController.clear();
    clubEmailController.clear();
    passwordController.clear();
    clubBioController.clear();
    clubIntroController.clear();
    clubOtherInformationController.clear();
    clubVideoController.clear();
  }

  /// capture images.
  void captureClubImage() async {
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
          clubImages.add(ClubProfileImage(element, -1, false));
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
          clubImages.add(ClubProfileImage(element, -1, false));
        }
      }
      hideGlobalLoading();
      _checkForMaxImageAllowed();
    }

    _checkForMaxImageAllowed();
  }

  /// return remaining images length count.
  int getRemainingImageToFillCount() {
    // MULTI_IMAGE_MAX_SIZE
    final imageLength = clubImages.length;
    return AppConstants.MULTI_IMAGE_MAX_SIZE - imageLength;
  }

  /// add image to list from edit additional image.
  void addImageList(List<ClubProfileImage> splitCaptureImages) {
    for (var element in splitCaptureImages) {
      clubImages.add(element);
    }
    _checkForMaxImageAllowed();
  }

  /// Update club detail API.
  void updateClubDetailAPI() async {
    try {
      if (await NetworkConnectivity.instance.hasNetwork()) {
        showGlobalLoading();
        final DeviceInfoModel objDeviceModel =
            Get.find(tag: AppConstants.DEVICE_INFO_KEY);

        dio.Response? response = await _provider.updateClubDetail(
          clubName: signUpData?.clubName ?? "",
          address: signUpData?.clubAddress ?? "",
          clubPhoneNumber: signUpData?.clubPhoneNumber ?? "",
          clubAddress: signUpData?.clubAddress ?? "",
          clubEmail: signUpData?.clubEmail ?? "",
          clubPassword: signUpData?.clubPassword ?? "",
          clubVideo: signUpData?.clubVideo ?? "",
          phoneNumber: signUpData?.clubPhoneNumber ?? "",
          type: AppConstants.userTypeClubInWord,
          introduction: signUpData?.clubIntro ?? "",
          bio: signUpData?.clubBio ?? "",
          referenceAndInfo: signUpData?.clubOtherInformation ?? "",
          sportTypeId: (signUpData?.sportType ?? []).isNotEmpty
              ? (signUpData?.sportType ?? []).first.itemId
              : -1,
          playerCategoryDetail: (signUpData?.playerType ?? []).isNotEmpty
              ? (signUpData?.playerType ?? []).map((e) => e.itemId).toList()
              : [],
          levelDetail: (signUpData?.playerLevel ?? []).isNotEmpty
              ? (signUpData?.playerLevel ?? []).map((e) => e.itemId).toList()
              : [],
          uuid: objDeviceModel.uuid ?? "",
          osVersion: objDeviceModel.osVersion ?? "",
          deviceName: objDeviceModel.deviceName ?? '',
          modelName: objDeviceModel.modelName ?? "",
          deviceType: objDeviceModel.deviceType ?? '',
          ip: objDeviceModel.ip ?? '',
          locationDetail: (signUpData?.location ?? []).isNotEmpty
              ? (signUpData?.location ?? []).map((e) => e.itemId).toList()
              : [],
          updateAllDetails:
              clubDetailViewTypeEnum == ClubDetailViewTypeEnum.clubSettings,
        );

        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _updateClubSuccess(response);
        } else {
          /// On Error
          _userClubError(response);
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

  /// Remove club profile confirmation.
  void removeProfileConfirmationDialog() {
    Get.dialog(AppDialogWidget(
      onDone: onRemoveApprove,
      dialogText: AppString.removeClubProfileConfirmation,
    ));
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
      clubProfileImage.value =
          PostImages(image: croppedFile.path, isUrl: false);
      clubProfileImage.refresh();
      if (editDetails) {
        uploadUserProfile();
      }
    }
  }

  /// Remove club logo profile
  void onRemoveApprove() {
    if (clubProfileImage.value.isUrl) {
      deleteUserProfile();
    } else {
      clubProfileImage.value.image = '';
      clubProfileImage.refresh();
    }
  }

  /// Enable google places API.
  Future<void> enableGooglePlaces() async {
    clubAddressFocusNode.unfocus();
    Prediction? p = await PlacesAutocomplete.show(
      context: Get.context!,
      apiKey: AppConstants.kGoogleApiKey,
      mode: Mode.overlay,
      hint: AppString.searchAddress,
    );

    displayPrediction(p);
  }

  /// Display prediction
  Future<Null> displayPrediction(
    Prediction? p,
  ) async {
    if (p != null) {
      GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: AppConstants.kGoogleApiKey,
      );
      PlacesDetailsResponse detail =
          await places.getDetailsByPlaceId(p.placeId ?? "");
      signUpData?.latitude = detail.result.geometry?.location.lat;
      signUpData?.longitude = detail.result.geometry?.location.lng;

      clubAddressController.text = p.description ?? "";
    }
  }

  /// get signup club API.
  void signupClub() async {
    try {
      if (await NetworkConnectivity.instance.hasNetwork()) {
        showGlobalLoading();

        final DeviceInfoModel objDeviceModel =
            Get.find(tag: AppConstants.DEVICE_INFO_KEY);

        dio.Response? response = await _provider.registerClubDetail(
          clubName: signUpData?.clubName ?? "",
          address: signUpData?.clubAddress ?? "",
          clubPhoneNumber: signUpData?.clubPhoneNumber ?? "",
          clubAddress: signUpData?.clubAddress ?? "",
          clubEmail: signUpData?.clubEmail ?? "",
          clubPassword: signUpData?.clubPassword ?? "",
          clubVideo: signUpData?.clubVideo ?? "",
          phoneNumber: signUpData?.clubPhoneNumber ?? "",
          type: AppConstants.userTypeClubInWord,
          introduction: signUpData?.clubIntro ?? "",
          bio: signUpData?.clubBio ?? "",
          referenceAndInfo: signUpData?.clubOtherInformation ?? "",
          sportTypeId: (signUpData?.sportType ?? []).isNotEmpty
              ? (signUpData?.sportType ?? []).first.itemId
              : -1,
          playerCategoryDetail: (signUpData?.playerType ?? []).isNotEmpty
              ? (signUpData?.playerType ?? []).map((e) => e.itemId).toList()
              : [],
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
        );

        if (response.statusCode == NetworkConstants.created) {
          /// On success
          _registerClubSuccess(response);
        } else {
          /// On Error
          _userClubError(response);
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

  /// Perform location api success
  void _registerClubSuccess(dio.Response response) {
    SignupResponse signupResponse = SignupResponse.fromJson(response.data);
    if (signupResponse.status == true) {
      if (signupResponse.data?.user != null) {
        GetIt.instance<PreferenceManager>()
            .setUserType(AppConstants.userTypeClub);
        GetIt.instance<PreferenceManager>()
            .setUserId(signupResponse.data?.user?.id ?? -1);
        GetIt.instance<PreferenceManager>()
            .setUserDetails(signupResponse.data!.user!);
        GetIt.instance<PreferenceManager>()
            .setUserToken(signupResponse.data!.token ?? "");

        addUserAdditionalImagesAndProfile();
      }
    }
  }

  /// Add user additional images.
  void addUserAdditionalImagesAndProfile() async {
    try {
      if (await NetworkConnectivity.instance.hasNetwork()) {
        showGlobalLoading();

        dio.Response? response = await _provider.addUserImages(
            profilePicture: (clubProfileImage.value.imageAvailable &&
                    !clubProfileImage.value.isUrl)
                ? File(clubProfileImage.value.image ?? "")
                : File(''),
            additionalImage: clubImages.value);

        if (response.statusCode == NetworkConstants.success) {
          /// On success
          hideGlobalLoading();
          if (clubDetailViewTypeEnum != ClubDetailViewTypeEnum.register) {
            final UserDetailService service =
                Get.find(tag: AppConstants.USER_DETAILS);
            service.getUserDetails();
            hideGlobalLoading();
            onCompleted();
          } else {
            _navigateToClubMember();
          }
        } else {
          /// On Error
          _userClubError(response);
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

  /// Perform location api error.
  void _userClubError(dio.Response response) {
    hideGlobalLoading();
    try {
      if (response.statusCode == AppConstants.fieldErrorStatus) {
        Map<String, dynamic> errorDataMap = response.data[NetworkParams.data];

        // Email error
        if (errorDataMap.containsKey(NetworkParams.email)) {
          _setErrorToField(emailError, errorDataMap[NetworkParams.email]);
          clubEmailFocusNode.requestFocus();
        }

        // Password error
        if (errorDataMap.containsKey(NetworkParams.password)) {
          _setErrorToField(passwordError, errorDataMap[NetworkParams.password]);
          passwordFocusNode.requestFocus();
        }

        // Phone Number error
        if (errorDataMap.containsKey(NetworkParams.phoneNumber)) {
          _setErrorToField(
              phoneNumberError, errorDataMap[NetworkParams.phoneNumber]);
          clubPhoneNumberFocusNode.requestFocus();
        }

        // Video error
        if (errorDataMap.containsKey(NetworkParams.video)) {
          _setErrorToField(videoError, errorDataMap[NetworkParams.video]);
          clubVideoFocusNode.requestFocus();
        }

        // Address error
        if (errorDataMap.containsKey(NetworkParams.address)) {
          _setErrorToField(addressError, errorDataMap[NetworkParams.address]);
          clubAddressFocusNode.requestFocus();
        }
      } else {
        // General error
        GetIt.instance<ApiUtils>()
            .parseErrorResponse(response, isFromLogin: true);
      }
    } catch (ex) {
      logger.e(ex);
      GetIt.instance<ApiUtils>().parseErrorResponse(response);
    }
  }

  /// Update club details api success
  void _updateClubSuccess(dio.Response response) {
    addUserAdditionalImagesAndProfile();
  }

  /// Set errors
  void _setErrorToField(RxString errorString, errorName) {
    errorString.value =
        GetIt.instance<CommonUtils>().returnErrorListFromObj(errorName);
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
            .updateUserProfile(File(clubProfileImage.value.image ?? ""));
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

    clubProfileImage.value.image = "";

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
    clubProfileImage.value = PostImages();
    clubProfileImage.refresh();
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
            imageId: clubImages[index].id ?? -1);
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
    clubImages.removeAt(index);
    _checkForMaxImageAllowed();
  }
}

class ClubProfileImage {
  String? path;
  int? id;
  bool isURL = false;

  ClubProfileImage(this.path, this.id, this.isURL);
}

enum ClubDetailViewTypeEnum { register, clubSettings, editClubDetail }
