import 'package:collection/collection.dart';
import 'package:dio/dio.dart' as dio;
import 'package:game_on_flutter/presentation/app_widgets/base_bottomsheet.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../../../../../infrastructure/model/club/signup/club_signup_data.dart';
import '../../../../../../infrastructure/model/club/signup/selection_model.dart';
import '../../../../../../infrastructure/model/common/sportstype_response_model.dart';
import '../../../../../../infrastructure/navigation/route_config.dart';
import '../../../../../../infrastructure/navigation/routes.dart';
import '../../../../../../infrastructure/network/api_utils.dart';
import '../../../../../../infrastructure/network/network_config.dart';
import '../../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../../infrastructure/storage/preference_manager.dart';
import '../../../../../../values/app_colors.dart';
import '../../../../../../values/app_constant.dart';
import '../../../../../../values/app_string.dart';
import '../../../../../../values/app_values.dart';
import '../../../../../../values/common_utils.dart';
import '../../../../../app_widgets/app_loading_mixin.dart';
import '../../../../club/club_profile/controllers/user_detail_controller.dart';
import '../../../../club/signup/sports_selection/controllers/sports_selection.controller.dart';
import '../../../register_player_detail/controllers/register_player_detail.controller.dart';
import '../provider/preferred_position_provider.dart';
import '../view/position_info_bottomsheeet_widget.dart';

class PrefferedPositionController extends GetxController with AppLoadingMixin {
  /// Store and update list.
  RxList<SelectionModel> playerPositionList = RxList();

  /// true if any single item is selected.
  RxBool isValid = false.obs;

  ///club signup data.
  SignUpData? signUpData;

  /// Sport type enum
  SportTypeEnum sportTypeEnum = SportTypeEnum.SIGNUP;

  /// Check if currently club has signed up or not.
  RxBool isClubSignup = true.obs;

  bool isSingleSelection = true;

  final _provider = PreferredPositionProvider();

  /// Logger
  final logger = Logger();

  @override
  void onReady() {
    _getArguments();
    super.onReady();
  }

  /// Get argument from previous screen
  void _getArguments() {
    isClubSignup.value =
        GetIt.I<PreferenceManager>().getUserType == AppConstants.userTypeClub;

    if (Get.arguments != null) {
      signUpData = Get.arguments[RouteArguments.signupData] ?? SignUpData();

      sportTypeEnum =
          Get.arguments[RouteArguments.sportTypeEnum] ?? SportTypeEnum.SIGNUP;
    }
    getPreferredPosition();
  }

  /// On select field.
  void setSelectedField(SelectionModel model, int index) {
    if (isSingleSelection) {
      final previousObjIndex =
          playerPositionList.indexWhere((element) => element.isSelected);
      if (previousObjIndex != -1) {
        playerPositionList[previousObjIndex].isSelected = false;
      }
    }

    if (!playerPositionList[index].isSelected) {
      playerPositionList[index].isSelected = true;
    } else {
      playerPositionList[index].isSelected = false;
    }

    _checkValidation();
  }

  /// Navigate to next screen.
  void navigateToNextScreen() {
    if (sportTypeEnum == SportTypeEnum.PLAYER_SETTINGS) {
      // editSuccessMessage();

      signUpData?.playerPosition =
          playerPositionList.where((p0) => p0.isSelected).toList();

      Get.toNamed(Routes.REGISTER_PLAYER_DETAIL, arguments: {
        RouteArguments.signupData: signUpData,
        RouteArguments.sportTypeEnum: sportTypeEnum,
        RouteArguments.playerViewType: PlayerDetailViewTypeEnum.playerSettings,
      });
    } else {
      signUpData?.playerPosition =
          playerPositionList.where((p0) => p0.isSelected).toList();

      Get.toNamed(Routes.REGISTER_PLAYER_DETAIL, arguments: {
        RouteArguments.signupData: signUpData,
        RouteArguments.sportTypeEnum: sportTypeEnum,
      });
    }
  }

  /// Edit success message.
  void editSuccessMessage() {
    CommonUtils.showSuccessSnackBar(message: AppString.detailsUpdateSuccess);

    Future.delayed(const Duration(seconds: AppValues.successMessageDetailInSec),
        () {
      Get.until((route) => route.settings.name == Routes.PLAYER_MAIN);
    });
  }

  /// On information click icon.
  void onInfoClick(SelectionModel model, int index) {
    /// Return when description is empty.
    if ((model.description ?? "").isEmpty) {
      return;
    }

    /// Open bottomSheet.
    Get.bottomSheet(
      BaseBottomsheet(
          title: model.title ?? "", child: PositionInfoBottomsheetWidget(  description: model.description,)),
      barrierColor: AppColors.bottomSheetBgBlurColor,
      isScrollControlled: true,
      ignoreSafeArea: false,
      isDismissible: true,
    );
  }

  /// get preferred position API.
  void getPreferredPosition() async {
    try {
      if (await NetworkConnectivity.instance.hasNetwork()) {
        showLoading();

        dio.Response? response = await _provider.getPreferredPositionFromSports(
            sportsType: (signUpData?.sportType?.first.itemId ?? -1).toString());

        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _getPreferredPositionSuccess(response);
        } else {
          /// On Error
          _getLevelError(response);
        }
      } else {
        hideLoading();
        GetIt.I<CommonUtils>().showNetworkError();
      }
    } catch (ex) {
      logger.e(ex);
    }
  }

  /// Perform level api success
  void _getPreferredPositionSuccess(dio.Response response) {
    hideLoading();

    SportTypeListResponseModel model =
        SportTypeListResponseModel.fromJson(response.data);

    /// set items to the list.
    if (model.status == true) {
      for (var element in (model.data ?? [])) {
        playerPositionList.add(SelectionModel.withDescription(
            description: element.description,
            title: element.name,
            itemId: element.id));
      }
    }
    if (sportTypeEnum != SportTypeEnum.SIGNUP) {
      _setUserSelectedSport();
    }

  }
  /// Set selection to the list.
  void _setUserSelectedSport() async {
    final UserDetailService service = Get.find(tag: AppConstants.USER_DETAILS);
    if ((service.userDetails.value.userSportsDetails ?? []).isEmpty) {
      await service.getUserDetails();
    }
    List<int> userSelectedSports = service.userDetails.value.playerPositionDetails
        ?.map((e) => e.positionId??-1)
        .toList() ??
        [];
    userSelectedSports.forEachIndexed((index, item){
      final selectedSportIndex = playerPositionList
          .indexWhere((element) => item == element.itemId);
      playerPositionList[selectedSportIndex].isSelected = true;
    });

    playerPositionList.refresh();
    _checkValidation();
  }

  /// Check validation
  void _checkValidation() {
    final isItemSelected =
    playerPositionList.firstWhereOrNull((element) => element.isSelected);
    isValid.value = isItemSelected != null;
    isValid.refresh();
  }

  /// Refresh list
  Future<void> onRefresh() async {
    playerPositionList.clear();
    getPreferredPosition();
  }

  /// Perform level api error.
  void _getLevelError(dio.Response response) {
    hideLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }
}
