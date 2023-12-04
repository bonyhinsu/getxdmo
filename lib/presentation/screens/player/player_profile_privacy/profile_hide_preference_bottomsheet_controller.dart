import 'package:dio/dio.dart' as dio;
import 'package:game_on_flutter/infrastructure/storage/preference_manager.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_loading_mixin.dart';
import 'package:game_on_flutter/presentation/screens/player/player_profile_privacy/provider/player_profile_privacy_provider.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../infrastructure/network/api_utils.dart';
import '../../../../infrastructure/network/network_config.dart';
import '../../../../infrastructure/network/network_connectivity.dart';
import '../../../../values/app_string.dart';
import '../../../../values/common_utils.dart';
import '../../../app_widgets/app_dialog_widget.dart';
import 'controllers/player_profile_privacy.controller.dart';

class ProfileHidePreferenceBottomsheetController extends GetxController
    with AppLoadingMixin {
  RxString result = "".obs;

  late PlayerProfilePrivacyController _controller;

  var isLoading = true.obs;

  final _provider = PlayerProfilePrivacyProvider();

  List<String> results = [
    AppString.forAllClubs,
    AppString.onlyForSelectedClub,
    AppString.none
  ];

  RxList userId = [].obs;

  late ProfilePrivacyEnum initialViewType;

  @override
  void onInit() {
    result.value = AppString.none;
    _controller = Get.find(tag: Routes.PLAYER_PROFILE_PRIVACY);
    super.onInit();
  }

  /// set [_gender] value
  void setResultEnum(ProfilePrivacyEnum profileTypeEnum) {
    initialViewType = profileTypeEnum;
    result.value = _getStringBasedOnEnum(profileTypeEnum);
  }

  /// set [_gender] value
  void setResult(String value) {
    result.value = value;
  }

  /// return string from [ProfilePrivacyEnum].
  String _getStringBasedOnEnum(ProfilePrivacyEnum profileTypeEnum) {
    switch (profileTypeEnum) {
      case ProfilePrivacyEnum.forAllClubs:
        return results[0];
      case ProfilePrivacyEnum.selectedClubs:
        return results[1];
      default:
        return results[2];
    }
  }

  /// click on next button
  void applyNext() {
    final initialType = _getStringBasedOnEnum(initialViewType);
    if (initialType == result.value) {
      Get.back();
      return;
    }

    if (result.value == AppString.forAllClubs) {
      Get.dialog(AppDialogWidget(
        onDone: _onApproveSelectAllClubs,
        dialogText: AppString.hideForAllClubMessage,
        enableCancelWidget: true,
      ));
    } else if (result.value == AppString.onlyForSelectedClub) {
      Get.back();
      _controller.gotoSelectClub();
    }
    if (result.value == AppString.none) {
      Get.back();
      _controller.profilePrivacy(privacy: result.value);
    }
  }

  /// player profile hide from different types.
  void profilePrivacy() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showGlobalLoading();
      dio.Response? response =
          await _provider.profilePrivacy(userId, value: result.value);
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.created) {
          /// On success
          successResponse(response);
        } else {
          /// On Error
          errorResponse(response);
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

  /// api success
  void successResponse(dio.Response response) {
    hideGlobalLoading();
    if (result.value == AppString.none) {
      GetIt.I<PreferenceManager>()
          .setPrivacyType(AppString.profileHidePreferenceDes);
    } else {
      GetIt.I<PreferenceManager>().setPrivacyType(result.value);
    }
    _controller.updateUIOnSelection();
  }

  ///  api error.
  void errorResponse(dio.Response response) {
    hideGlobalLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }

  /// dialog cancel
  void _onApproveSelectAllClubs() {
    Get.back();

    _controller.profilePrivacy(privacy: AppString.forAllClubs);
  }
}
