import 'package:dio/dio.dart' as dio;
import 'package:game_on_flutter/infrastructure/navigation/route_config.dart';
import 'package:game_on_flutter/infrastructure/navigation/routes.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_loading_mixin.dart';
import 'package:game_on_flutter/values/common_utils.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as handler;

import '../../../../../../infrastructure/model/club/signup/club_signup_data.dart';
import '../../../../../../infrastructure/model/club/signup/selection_model.dart';
import '../../../../../../infrastructure/model/common/sportstype_response_model.dart';
import '../../../../../../infrastructure/network/api_utils.dart';
import '../../../../../../infrastructure/network/network_config.dart';
import '../../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../../infrastructure/storage/preference_manager.dart';
import '../../../../../../values/app_constant.dart';
import '../../../../../../values/app_string.dart';
import '../../../../../app_widgets/app_dialog_widget.dart';
import '../../../../../app_widgets/app_dialog_with_title_widget.dart';
import '../../../club_profile/controllers/user_detail_controller.dart';
import '../../sports_selection/controllers/sports_selection.controller.dart';
import '../providers/club_location_provider.dart';

class ClubLocationController extends GetxController with AppLoadingMixin {
  /// Store and update list.
  RxList<SelectionModel> clubLocationList = RxList();

  /// true if any single item is selected.
  RxBool isValid = false.obs;

  ///club signup data.
  SignUpData? signUpData;

  /// Sport type enum
  SportTypeEnum sportTypeEnum = SportTypeEnum.SIGNUP;

  /// Check if currently club has signed up or not.
  RxBool isClubSignup = true.obs;

  Location location = Location();

  bool isSingleSelection = false;

  late bool _serviceEnabled;

  late PermissionStatus _permissionGranted;

  late LocationData _locationData;

  String state = "Victoria";
  String city = "Melbourne";
  String country = "Australia";

  RxBool isLocationAvailabale = false.obs;

  final _provider = ClubLocationProvider();

  @override
  void onReady() {
    _getArguments();
    super.onReady();
  }

  @override
  void onInit() {
    isClubSignup.value =
        GetIt.I<PreferenceManager>().getUserType == AppConstants.userTypeClub;
    super.onInit();
  }

  /// Get argument from previous screen
  void _getArguments() {
    if (Get.arguments != null) {
      signUpData = Get.arguments[RouteArguments.signupData] ?? SignUpData();

      sportTypeEnum =
          Get.arguments[RouteArguments.sportTypeEnum] ?? SportTypeEnum.SIGNUP;
    }
    getLocationAPI();
  }

  /// Load data to the list.
  void _loadData() {
    if (sportTypeEnum == SportTypeEnum.CLUB_SETTINGS ||
        sportTypeEnum == SportTypeEnum.PLAYER_SETTINGS) {
      _setUserSelectedLocations();
    }
  }

  /// Set selection to the list.
  void _setUserSelectedLocations() {
    final UserDetailService service = Get.find(tag: AppConstants.USER_DETAILS);
    if ((service.userDetails.value.userSportsDetails ?? []).isEmpty) {
      return;
    }
    service.userDetails.value.userSportsDetails!.first.userLocationDetails
        ?.forEach((userLocationElement) {
      final selectedSportIndex = clubLocationList.indexWhere(
          (element) => element.itemId == userLocationElement.locationId);
      clubLocationList[selectedSportIndex].isSelected = true;
    });
    clubLocationList.refresh();
    _checkValidation();

    /// TODO. Enable current location if the user already have.
    /*     isLocationAvailabale.value = true;*/
  }

  /// On select field.
  void setSelectedField(SelectionModel model, int index) {
    if (isSingleSelection) {
      final previousObjIndex =
          clubLocationList.indexWhere((element) => element.isSelected);
      if (previousObjIndex != -1) {
        clubLocationList[previousObjIndex].isSelected = false;
      }
    }

    if (!clubLocationList[index].isSelected) {
      clubLocationList[index].isSelected = true;
    } else {
      clubLocationList[index].isSelected = false;
    }
    _checkValidation();
  }

  /// Check validation
  void _checkValidation() {
    final isItemSelected =
        clubLocationList.firstWhereOrNull((element) => element.isSelected);

    isValid.value = isItemSelected != null;
    isValid.refresh();
  }

  /// Navigate to next screen.
  void navigateToNextScreen() {
    signUpData?.location =
        clubLocationList.where((p0) => p0.isSelected).toList();

    if (isClubSignup.isTrue) {
      Get.toNamed(Routes.CLUB_PLAYER_TYPE, arguments: {
        RouteArguments.signupData: signUpData,
        RouteArguments.sportTypeEnum: sportTypeEnum,
      });
    } else {
      Get.toNamed(Routes.CLUB_LEVEL, arguments: {
        RouteArguments.signupData: signUpData,
        RouteArguments.sportTypeEnum: sportTypeEnum,
      });
    }
  }

  /// Fetch current location.
  void fetchCurrentLocation() async {
    showGlobalLoading();
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        hideGlobalLoading();
        return;
      }
    }

    _permissionGranted = await location.hasPermission();

    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();

      if (_permissionGranted != PermissionStatus.granted) {
        hideGlobalLoading();
        _showAllowPermissionDialog();
      } else {
        _fetchLocation();
      }
    } else {
      _fetchLocation();
    }
  }

  /// Show allow permission dialog.
  void _fetchLocation() async {
    _locationData = await location.getLocation();

    try {
      final latitude = _locationData.latitude ?? 0;
      final longitude = _locationData.longitude ?? 0;
      GeoData data = await Geocoder2.getDataFromCoordinates(
          latitude: latitude,
          longitude: longitude,
          googleMapApiKey: AppConstants.kGoogleApiKey);
      hideGlobalLoading();
      addUserLocationToView(data.state);
    } catch (ex) {
      hideGlobalLoading();
      print(ex.toString());
      isLocationAvailabale.value = true;
      final addressIndex =
          clubLocationList.indexWhere((element) => element.isSelected);
      if (addressIndex == -1) {
        CommonUtils.showInfoSnackBar(
            message: AppString.locationSelectionMessage);
      }
    }
  }

  /// Show allow permission dialog.
  void _showAllowPermissionDialog() {
    Get.dialog(AppDialogWithTitleWidget(
      onDone: _navigateToSystemSettings,
      dialogText: AppString.allowLocationPermissionFromSettings,
      dialogTitle: AppString.locationPermissionRequired,
      cancelButtonText: AppString.cancel,
      doneButtonText: AppString.settings,
    ));
  }

  /// Navigate to system settings.
  void _navigateToSystemSettings() async {
    await handler.openAppSettings();
  }

  /// Add user current location to view.
  void addUserLocationToView(String address) {
    final addressIndex = clubLocationList.indexWhere(
        (element) => element.title?.toLowerCase() == address.toLowerCase());
    if (addressIndex == -1) {
      final model = SelectionModel.withoutIcon(title: address);
      model.isSelected = true;
      clubLocationList.insert(0, model);
    } else {
      clubLocationList[addressIndex].isSelected = true;
    }
  }

  /// delete current location.
  void deleteCurrentLocation() {
    Get.dialog(AppDialogWidget(
        dialogText: AppString.discardLocationText,
        onDone: onDeleteCurrentLocation));
  }

  /// on done.
  void onDeleteCurrentLocation() {
    ///TODO: Remove user current location on delete
    isLocationAvailabale.value = false;
  }

  /// get location type API.
  void getLocationAPI() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showLoading();

      dio.Response? response = await _provider.getLocations();

      if (response.statusCode == NetworkConstants.success) {
        /// On success
        _getLocationSuccess(response);
      } else {
        /// On Error
        _getSportsError(response);
      }
    } else {
      hideGlobalLoading();
      GetIt.I<CommonUtils>().showNetworkError();
    }
  }

  /// Perform location api success
  void _getLocationSuccess(dio.Response response) {
    hideLoading();

    SportTypeListResponseModel model =
        SportTypeListResponseModel.fromJson(response.data);

    /// set items to the list.
    if (model.status == true) {
      for (var element in (model.data ?? [])) {
        clubLocationList.add(SelectionModel.withoutIcon(
            title: element.name, itemId: element.id));
      }
      if (sportTypeEnum != SportTypeEnum.SIGNUP) {
        _loadData();
      }
    }
  }

  /// Refresh list
  Future<void> onRefresh() async {
    clubLocationList.clear();
    getLocationAPI();
  }

  /// Perform location api error.
  void _getSportsError(dio.Response response) {
    hideGlobalLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }
}
