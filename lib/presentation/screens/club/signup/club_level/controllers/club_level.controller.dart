import 'package:dio/dio.dart' as dio;
import 'package:game_on_flutter/presentation/app_widgets/app_loading_mixin.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../infrastructure/model/club/signup/club_signup_data.dart';
import '../../../../../../infrastructure/model/club/signup/selection_model.dart';
import '../../../../../../infrastructure/model/common/sportstype_response_model.dart';
import '../../../../../../infrastructure/navigation/route_config.dart';
import '../../../../../../infrastructure/navigation/routes.dart';
import '../../../../../../infrastructure/network/api_utils.dart';
import '../../../../../../infrastructure/network/network_config.dart';
import '../../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../../infrastructure/storage/preference_manager.dart';
import '../../../../../../values/app_constant.dart';
import '../../../../../../values/app_string.dart';
import '../../../../../../values/app_values.dart';
import '../../../../../../values/common_utils.dart';
import '../../../../subscription/subscription_plan/controllers/subscription_plan.controller.dart';
import '../../../club_profile/controllers/user_detail_controller.dart';
import '../../register_club_details/controllers/register_club_details.controller.dart';
import '../../sports_selection/controllers/sports_selection.controller.dart';
import '../providers/club_level_provider.dart';

class ClubLevelController extends GetxController with AppLoadingMixin {
  /// Store and update list.
  RxList<SelectionModel> clubLevel = RxList();

  /// true if any single item is selected.
  RxBool isValid = false.obs;

  /// store and track selected index;
  RxInt selectedIndex = (-1).obs;

  RxList<SelectionModel> selectedItem = RxList();

  ///club signup data.
  SignUpData? signUpData;

  /// Sport type enum
  SportTypeEnum sportTypeEnum = SportTypeEnum.SIGNUP;

  /// Check if currently club has signed up or not.
  RxBool isClubSignup = true.obs;

  /// Provider
  final _provider = ClubLevelProvider();

  @override
  void onReady() {
    _getArguments();
    super.onReady();
  }

  /// Get argument from previous screen
  void _getArguments() {
    if (Get.arguments != null) {
      signUpData = Get.arguments[RouteArguments.signupData] ?? SignUpData();

      sportTypeEnum =
          Get.arguments[RouteArguments.sportTypeEnum] ?? SportTypeEnum.SIGNUP;
    }

    getLevelAPI();
  }

  /// Load data to the list.
  void _loadData() {
    if (sportTypeEnum == SportTypeEnum.CLUB_SETTINGS ||
        sportTypeEnum == SportTypeEnum.PLAYER_SETTINGS) {
      _setUserSelectedSport();
    }
  }

  /// Set selection to the list.
  void _setUserSelectedSport() {
    final UserDetailService service = Get.find(tag: AppConstants.USER_DETAILS);
    service.userDetails.value.userSportsDetails!.first.userLevelDetails
        ?.forEach((userLocationElement) {
      final selectedSportIndex = clubLevel.indexWhere(
          (element) => element.itemId == userLocationElement.levelId);
      clubLevel[selectedSportIndex].isSelected = true;
    });
    clubLevel.refresh();
    _checkValidation();
  }

  /// On select field.
  void setSelectedField(SelectionModel model, int index) {
    selectedIndex.value = index;

    if (!clubLevel[index].isSelected) {
      clubLevel[index].isSelected = true;
    } else {
      clubLevel[index].isSelected = false;
    }
    _checkValidation();
  }

  /// Check validation
  void _checkValidation() {
    final isItemSelected =
        clubLevel.firstWhereOrNull((element) => element.isSelected);
    isValid.value = isItemSelected != null;
    isValid.refresh();
  }

  /// Navigate to next screen.
  void navigateToNextScreen() {
    signUpData?.playerLevel = clubLevel.where((p0) => p0.isSelected).toList();

    if (sportTypeEnum == SportTypeEnum.ADD_SUBSCRIPTION) {
      final sportTypeId = (signUpData?.sportType ?? []).isNotEmpty
          ? (signUpData?.sportType ?? []).first.itemId
          : -1;

      Get.toNamed(Routes.SUBSCRIPTION_PLAN, arguments: {
        RouteArguments.signupData: signUpData,
        RouteArguments.sportTypeId: sportTypeId.toString(),
        RouteArguments.sportTypeEnum: sportTypeEnum,
        RouteArguments.subscriptionEnum: SubscriptionEnum.ADD_NEW_SUBSCRIPTION,
      });
    } else {
      signUpData?.playerLevel = clubLevel.where((p0) => p0.isSelected).toList();
      if (GetIt.I<PreferenceManager>().isClub) {
        Get.toNamed(Routes.REGISTER_CLUB_DETAILS, arguments: {
          RouteArguments.signupData: signUpData,
          RouteArguments.sportTypeEnum: sportTypeEnum,
          RouteArguments.clubViewType:
              sportTypeEnum == SportTypeEnum.CLUB_SETTINGS
                  ? ClubDetailViewTypeEnum.clubSettings
                  : ClubDetailViewTypeEnum.register
        });
      } else {
        Get.toNamed(Routes.PREFFERED_POSITION, arguments: {
          RouteArguments.signupData: signUpData,
          RouteArguments.sportTypeEnum: sportTypeEnum,
        });
      }
    }
  }

  /// Edit success message.
  void editSuccessMessage() {
    CommonUtils.showSuccessSnackBar(message: AppString.detailsUpdateSuccess);

    Future.delayed(const Duration(seconds: AppValues.successMessageDetailInSec),
        () {
      Get.until((route) => route.settings.name == Routes.CLUB_MAIN);
    });
  }

  /// get level type API.
  void getLevelAPI() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showLoading();

      dio.Response? response = await _provider.getLevel();

      if (response.statusCode == NetworkConstants.success) {
        /// On success
        _getLevelSuccess(response);
      } else {
        /// On Error
        _getLevelError(response);
      }
    } else {
      hideGlobalLoading();
      GetIt.I<CommonUtils>().showNetworkError();
    }
  }

  /// Perform level api success
  void _getLevelSuccess(dio.Response response) {
    hideLoading();

    SportTypeListResponseModel model =
        SportTypeListResponseModel.fromJson(response.data);

    /// set items to the list.
    if (model.status == true) {
      for (var element in (model.data ?? [])) {
        clubLevel.add(SelectionModel.withoutIcon(
            title: element.name, itemId: element.id));
      }

      /// Check if user does not selected jnr boys or girls then remove
      /// junior from the levels.
      final selectedJunior = (signUpData?.playerType ?? []).isNotEmpty
          ? signUpData?.playerType?.firstWhereOrNull(
              (element) => (element.title ?? "").toLowerCase().contains('jnr.'),
            )
          : null;

      if (selectedJunior == null) {
        clubLevel.removeWhere((element) =>
            (element.title ?? "").toLowerCase().contains("junior"));
      }
      clubLevel.refresh();

      if (sportTypeEnum != SportTypeEnum.SIGNUP) {
        _loadData();
      }
    }
  }

  /// Refresh list
  Future<void> onRefresh() async {
    clubLevel.clear();
    getLevelAPI();
  }

  /// Perform level api error.
  void _getLevelError(dio.Response response) {
    hideGlobalLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }
}
