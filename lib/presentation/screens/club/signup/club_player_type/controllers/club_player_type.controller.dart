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
import '../../../../../../values/app_constant.dart';
import '../../../../../../values/common_utils.dart';
import '../../../club_profile/controllers/user_detail_controller.dart';
import '../../sports_selection/controllers/sports_selection.controller.dart';
import '../providers/club_player_type_provider.dart';

class ClubPlayerTypeController extends GetxController with AppLoadingMixin {
  /// Store and update list.
  RxList<SelectionModel> playerTypeList = RxList();

  /// true if any single item is selected.
  RxBool isValid = false.obs;

  /// store and track selected index;
  RxInt selectedIndex = (-1).obs;

  ///club signup data.
  SignUpData? signUpData;

  /// Sport type enum
  SportTypeEnum sportTypeEnum = SportTypeEnum.SIGNUP;

  /// provider.
  final _provider = ClubPlayerTypeProvider();

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
    getPlayerType();
  }

  /// Load data to the list.
  void _loadData() {
    if (sportTypeEnum == SportTypeEnum.CLUB_SETTINGS) {
      _setUserSelectedSport();
    }
  }

  /// Set selection to the list.
  void _setUserSelectedSport() {
    final UserDetailService service = Get.find(tag: AppConstants.USER_DETAILS);
    if ((service.userDetails.value.userSportsDetails ?? []).isEmpty) {
      return;
    }
    service.userDetails.value.userSportsDetails!.first.userPlayerCategory
        ?.forEach((userLocationElement) {
      final selectedSportIndex = playerTypeList.indexWhere(
          (element) => element.itemId == userLocationElement.genderId);
      playerTypeList[selectedSportIndex].isSelected = true;
    });
    playerTypeList.refresh();
    _checkValidation();
  }

  /// On select field.
  void setSelectedField(SelectionModel model, int index) {
    if (!playerTypeList[index].isSelected) {
      playerTypeList[index].isSelected = true;
    } else {
      playerTypeList[index].isSelected = false;
    }

    _checkValidation();
  }

  /// Check validation
  void _checkValidation() {
    final isItemSelected =
        playerTypeList.firstWhereOrNull((element) => element.isSelected);
    isValid.value = isItemSelected != null;
    isValid.refresh();
  }

  /// Navigate to next screen.
  void navigateToNextScreen() {
    signUpData?.playerType =
        playerTypeList.where((p0) => p0.isSelected).toList();

    Get.toNamed(Routes.CLUB_LEVEL, arguments: {
      RouteArguments.signupData: signUpData,
      RouteArguments.sportTypeEnum: sportTypeEnum,
    });
  }

  /// get player type API.
  void getPlayerType() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showLoading();

      dio.Response? response = await _provider.getPlayerType();

      if (response.statusCode == NetworkConstants.success) {
        /// On success
        _getPlayerTypeSuccess(response);
      } else {
        /// On Error
        _getPlayerTypeError(response);
      }
    } else {
      hideLoading();
      GetIt.I<CommonUtils>().showNetworkError();
    }
  }

  /// Perform location api success
  void _getPlayerTypeSuccess(dio.Response response) {
    hideLoading();

    SportTypeListResponseModel model =
        SportTypeListResponseModel.fromJson(response.data);

    /// set items to the list.
    if (model.status == true) {
      for (var element in (model.data ?? [])) {
        playerTypeList.add(SelectionModel.withoutIcon(
            title: element.name, itemId: element.id));
      }

      if (sportTypeEnum != SportTypeEnum.SIGNUP) {
        _loadData();
      }
    }
  }

  /// Refresh list
  Future<void> onRefresh() async {
    playerTypeList.clear();
    getPlayerType();
  }

  /// Perform location api error.
  void _getPlayerTypeError(dio.Response response) {
    hideLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }
}
