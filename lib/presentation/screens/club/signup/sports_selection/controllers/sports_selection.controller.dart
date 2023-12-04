import 'package:collection/collection.dart';
import 'package:dio/dio.dart' as dio;
import 'package:game_on_flutter/infrastructure/model/common/app_fields.dart';
import 'package:game_on_flutter/infrastructure/navigation/route_config.dart';
import 'package:game_on_flutter/infrastructure/storage/preference_manager.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_loading_mixin.dart';
import 'package:game_on_flutter/values/app_constant.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../infrastructure/model/club/signup/club_signup_data.dart';
import '../../../../../../infrastructure/model/club/signup/selection_model.dart';
import '../../../../../../infrastructure/model/common/sportstype_response_model.dart';
import '../../../../../../infrastructure/model/subscription/subscription_sport_model.dart';
import '../../../../../../infrastructure/navigation/routes.dart';
import '../../../../../../infrastructure/network/api_utils.dart';
import '../../../../../../infrastructure/network/network_config.dart';
import '../../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../../values/common_utils.dart';
import '../../../club_profile/controllers/user_detail_controller.dart';
import '../providers/sports_selection_provider.dart';

class SportsSelectionController extends GetxController with AppLoadingMixin {
  /// Store and update list.
  RxList<SelectionModel> sportsTypeList = RxList();

  /// true if any single item is selected.
  RxBool isValid = false.obs;

  /// store and track selected index;
  RxInt selectedIndex = (-1).obs;

  ///club signup data.
  SignUpData signUpData = SignUpData();

  bool isSingleSelection = true;

  /// Stores edit detail bool.
  bool editDetails = false;

  /// Sport type enum
  SportTypeEnum sportTypeEnum = SportTypeEnum.SIGNUP;

  /// Sport type for
  List<SubscriptionSportModel> addedSportType = [];

  /// provider
  final _provider = SportsSelectionProvider();

  /// Check if currently club has signed up or not.
  RxBool isClub = true.obs;

  @override
  void onReady() {
    _getArguments();
    super.onReady();
  }

  /// Get argument from previous screen
  void _getArguments() {
    isClub.value =
        GetIt.I<PreferenceManager>().getUserType == AppConstants.userTypeClub;

    if (Get.arguments != null) {
      editDetails = Get.arguments[RouteArguments.updateDetails] ?? false;
      sportTypeEnum =
          Get.arguments[RouteArguments.sportTypeEnum] ?? SportTypeEnum.SIGNUP;

      addedSportType.addAll(Get.arguments[RouteArguments.addedSportType] ?? []);

      if (editDetails) {
        sportTypeEnum = isClub.value
            ? SportTypeEnum.CLUB_SETTINGS
            : SportTypeEnum.PLAYER_SETTINGS;
      }
    }
    getSportTypeAPI();
  }

  /// Set selection to the list.
  void _setUserSelectedSport() async {
    final UserDetailService service = Get.find(tag: AppConstants.USER_DETAILS);
    if ((service.userDetails.value.userSportsDetails ?? []).isEmpty) {
      await service.getUserDetails();
    }
    List<int> userSelectedSports = service.userDetails.value.userSportsDetails
            ?.map((e) => e.sportTypeId??-1)
            .toList() ??
        [];
    userSelectedSports.forEachIndexed((index, item){
      final selectedSportIndex = sportsTypeList
          .indexWhere((element) => item == element.itemId);
      sportsTypeList[selectedSportIndex].isSelected = true;
    });


    sportsTypeList.refresh();
    _checkValidation();
  }

  /// On select field.
  void setSelectedField(SelectionModel model, int index) {
    if (isSingleSelection) {
      final previousObjIndex =
          sportsTypeList.indexWhere((element) => element.isSelected);
      if (previousObjIndex != -1) {
        sportsTypeList[previousObjIndex].isSelected = false;
      }
    }

    if (!sportsTypeList[index].isSelected) {
      sportsTypeList[index].isSelected = true;
    } else {
      sportsTypeList[index].isSelected = false;
    }

    _checkValidation();
  }

  /// Check validation
  void _checkValidation() {
    final isItemSelected =
        sportsTypeList.firstWhereOrNull((element) => element.isSelected);
    isValid.value = isItemSelected != null;
    isValid.refresh();
  }

  /// Navigate to next screen.
  void navigateToNextScreen() {
    signUpData.sportType = sportsTypeList.where((p0) => p0.isSelected).toList();
    Get.log('signUpData.sportType ${signUpData.sportType?.map((e) => e.itemId).toList()}');
    Get.toNamed(Routes.CLUB_LOCATION, arguments: {
      RouteArguments.signupData: signUpData,
      RouteArguments.sportTypeEnum: sportTypeEnum,
    });
  }

  /// get sport type API.
  void getSportTypeAPI() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showLoading();

      dio.Response? response = await _provider.getSportType();

      if (response.statusCode == NetworkConstants.success) {
        /// On success
        _getSportsSuccess(response);
      } else {
        /// On Error
        _getSportsError(response);
      }
    } else {
      hideGlobalLoading();
      GetIt.I<CommonUtils>().showNetworkError();
    }
  }

  /// Perform login api success
  void _getSportsSuccess(dio.Response response) {
    hideLoading();

    SportTypeListResponseModel model =
        SportTypeListResponseModel.fromJson(response.data);

    /// set items to the list.
    if (model.status == true) {
      for (SportTypeResponseModelData element in (model.data ?? [])) {
        sportsTypeList.add(SelectionModel.withIcon(
            title: element.name,
            icon: (element.logo ?? "").isNotEmpty
                ? '${AppFields.instance.imagePrefix}${element.logo}'
                : '',
            isPng: true,
            isEnabled: sportTypeEnum != SportTypeEnum.PLAYER_SETTINGS && sportTypeEnum != SportTypeEnum.CLUB_SETTINGS,
            itemId: element.id ?? 0));
      }
      // When user navigate from add subscription.
      if (sportTypeEnum == SportTypeEnum.ADD_SUBSCRIPTION) {
        final UserDetailService service =
            Get.find(tag: AppConstants.USER_DETAILS);
        List<int?>? userSubscribedList = service
            .userDetails.value.userSportsDetails
            ?.map((e) => e.sportTypeId)
            .toList();
        Get.log('userSubscribedList ${userSubscribedList}');
        sportsTypeList.removeWhere(
            (element) => (userSubscribedList ?? []).contains(element.itemId));
        sportsTypeList.refresh();
      }
      if (editDetails) {
        _setUserSelectedSport();
      }
    }
  }

  /// Refresh list
  Future<void> onRefresh() async {
    sportsTypeList.clear();
    getSportTypeAPI();
  }

  /// Perform api error.
  void _getSportsError(dio.Response response) {
    hideGlobalLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }
}

enum SportTypeEnum {
  SIGNUP,
  CLUB_SETTINGS,
  PLAYER_SETTINGS,
  ADD_SUBSCRIPTION,
  PENDING_PROFILE
}
