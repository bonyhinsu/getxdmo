import 'package:dio/dio.dart' as dio;
import 'package:game_on_flutter/infrastructure/model/club/home/club_list_model.dart';
import 'package:game_on_flutter/infrastructure/storage/preference_manager.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_loading_mixin.dart';
import 'package:game_on_flutter/presentation/screens/player/player_profile_privacy/profile_hide_preference_bottomsheet.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../infrastructure/model/club/post/player_activity_model.dart';
import '../../../../../infrastructure/model/player/profile_privacy/user_privacy_response.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../infrastructure/network/api_utils.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../main.dart';
import '../../../../../values/app_constant.dart';
import '../../../../../values/common_utils.dart';
import '../profile_hide_preference_bottomsheet_controller.dart';
import '../provider/player_profile_privacy_provider.dart';
import '../select_club/provider/select_club_provider.dart';

class PlayerProfilePrivacyController extends GetxController
    with AppLoadingMixin {
  RxString privacyMessage = AppString.profileHidePreferenceDes.obs;

  /// Flag to handle if the selected club list visible or not.
  RxBool isVisibleList = false.obs;

  /// Enable save button
  RxBool enableSaveButton = false.obs;

  /// Flag handle if editable list visible or not.
  RxBool showSelectedClubList = false.obs;

  String clubPrivacyResultType = "";

  final _provider = PlayerProfilePrivacyProvider();

  final provider = SelectClubProvider();

  // final SelectClubController selectClub = Get.find(tag: Routes.SELECT_CLUB);

  RxList<ClubListModel> clubList = RxList();

  List<int> filterIds = [];

  RxList selectedClubIDs = [].obs;

  final PagingController<int, ClubListModel> pagingController =
      PagingController(firstPageKey: 0);

  final PagingController<int, ClubListModel>
      selectedClubListPaginationController = PagingController(firstPageKey: 0);

  int pageKey = 0;

  Rx<ProfilePrivacyEnum> profilePrivacyTypeEnum = ProfilePrivacyEnum.none.obs;

  @override
  void onInit() {
    _setupPageListener();
    updateUIOnSelection();
    super.onInit();
    _getUserPreference();
  }

  /// Set initial message for the screen.
  void updateUIOnSelection() {
    final userProfilePrivacy = GetIt.I<PreferenceManager>().privacyType;

    if (userProfilePrivacy == AppString.profileHidePreferenceDes) {
      // For user haven't selected any clubs.
      privacyMessage.value = AppString.profileHidePreferenceDes;
      profilePrivacyTypeEnum.value = ProfilePrivacyEnum.none;
    } else if (userProfilePrivacy == AppString.onlyForSelectedClub) {
      // For user chosen some clubs from they wants to hide.
      privacyMessage.value = AppString.selectedClubHidden;
      profilePrivacyTypeEnum.value = ProfilePrivacyEnum.selectedClubs;

      isVisibleList.value = false;
      showSelectedClubList.value = true;
    } else {
      // For user who chosen all the clubs he need to hide.
      privacyMessage.value = AppString.allClubHiddenMessage;
      profilePrivacyTypeEnum.value = ProfilePrivacyEnum.forAllClubs;
    }
  }

  /// Page change listener.
  void _setupPageListener() {
    pagingController.addPageRequestListener((pageKey) {
      _getAllClubs(pageKey);
    });

    selectedClubListPaginationController.addPageRequestListener((pageKey) {
      _getSelectedClub(pageKey);
    });
  }

  /// Get user posts API.
  void _getAllClubs(int pageKey) async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showLoading();
      dio.Response? response = await provider
          .getAllUserSelectedClubs(filterIds, pageKey, search: "");
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _getPostSuccess(response, pageKey);
        } else {
          /// On Error
          _getAPIError(response);
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

  /// Get user selected club API.
  void _getSelectedClub(int pageKey) async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showLoading();
      dio.Response? response = await provider.getOnlySelectedClub(pageKey);
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _getSelectedClubSuccessResponse(response, pageKey);
        } else {
          /// On Error
          _getAPIError(response);
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

  /// Get user preference.
  void _getUserPreference() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showLoading();
      dio.Response? response = await provider.getUserSelectedPreference();
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _getUserPreferenceSuccess(response);
        } else {
          /// On Error
          _getAPIError(response);
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

  /// add checked data in temp array
  void addToSelectedClubList(int index, bool isChecked) {
    pagingController.itemList![index].isSelected = isChecked;

    if (pagingController.itemList![index].isSelected) {
      selectedClubIDs.add(pagingController.itemList![index].id);
    } else {
      selectedClubIDs.remove(pagingController.itemList![index].id);
    }
    pagingController.notifyListeners();

    enableSaveButton.value = selectedClubIDs.isNotEmpty;
    enableSaveButton.refresh();
  }

  /// Get user preference
  void _getUserPreferenceSuccess(dio.Response response) {
    try {
      UserPrivacyResponse postResponse =
          UserPrivacyResponse.fromJson(response.data!);
      final clubResponseList = (postResponse.data ?? []);
      if (clubResponseList.isNotEmpty) {
        GetIt.I<PreferenceManager>().setPrivacyType(
            (clubResponseList.first.type ?? "") == AppConstants.PRIVACY_ALL_CLUB
                ? AppString.allClubHiddenMessage
                : AppString.onlyForSelectedClub);
      } else {
        GetIt.I<PreferenceManager>()
            .setPrivacyType(AppString.profileHidePreferenceDes);
      }
      updateUIOnSelection();
    } catch (ex) {
      logger.e(ex);
    }
  }

  /// Perform selected club success response
  void _getSelectedClubSuccessResponse(dio.Response response, int pageKey) {
    try {
      UserPrivacyResponse postResponse =
          UserPrivacyResponse.fromJson(response.data!);
      bool isLastPage =
          (postResponse.data ?? []).length < AppConstants.pageSize;

      clubList.clear();
      postResponse.data?.forEach((postElement) {
        postElement.isSelected = true;
        clubList.add(_prepareSelectedClubList(postElement));
      });
      if (isLastPage) {
        selectedClubListPaginationController.appendLastPage(clubList);
      } else {
        final nextPageKey = pageKey + AppConstants.pageSize;
        selectedClubListPaginationController.appendPage(clubList, nextPageKey);
      }
    } catch (e) {
      logger.e(e);
    }
    hideLoading();
  }

  /// Perform login api success
  void _getPostSuccess(dio.Response response, int pageKey) {
    try {
      ClubActivityListModel postResponse =
          ClubActivityListModel.fromJson(response.data!);
      bool isLastPage =
          (postResponse.data ?? []).length < AppConstants.pageSize;

      clubList.clear();
      postResponse.data?.forEach((postElement) {
        clubList.add(_addDataToSelectedClubs(postElement));
      });
      if (isLastPage) {
        pagingController.appendLastPage(clubList);
      } else {
        final nextPageKey = pageKey + AppConstants.pageSize;
        pagingController.appendPage(clubList, nextPageKey);
      }
    } catch (e) {
      logger.e(e);
    }
    hideLoading();
  }

  void profilePrivacy({required String privacy}) async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showGlobalLoading();
      dio.Response? response =
          await _provider.profilePrivacy(selectedClubIDs, value: privacy);
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.created) {
          /// On success
          successResponse(response, privacy);
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

  void gotoSelectClub() async {
    final selectedValue = await Get.toNamed(Routes.SELECT_CLUB);
    selectedClubIDs.value = selectedValue;
    profilePrivacy(privacy: AppString.onlyForSelectedClub);
  }

  ///  api error.
  void errorResponse(dio.Response response) {
    hideGlobalLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }

  /// api success
  void successResponse(dio.Response response, String privacyValue) {
    hideGlobalLoading();
    _storeSelectedPrivacy(privacyValue);
    selectedClubListPaginationController.refresh();
    updateUIOnSelection();
  }

  /// Strore newly selected privacy profile.
  void _storeSelectedPrivacy(String privacyValue) {
    if (privacyValue == AppString.none) {
      privacyValue = AppString.profileHidePreferenceDes;
    }
    GetIt.I<PreferenceManager>().setPrivacyType(privacyValue);
  }

  /// Perform api error.
  void _getAPIError(dio.Response response) {
    hideGlobalLoading();
    pagingController.error = response.statusMessage;
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }

  /// return [ClubListModel] from [ClubActivityListModelData].
  ClubListModel _addDataToSelectedClubs(ClubActivityListModelData postElement) {
    return ClubListModel(
        clubName: postElement.name,
        isSelected: postElement.isSelected ?? false,
        clubLogo: postElement.profileImage,
        id: postElement.id);
  }

  /// return [ClubListModel] from [UserPrivacyResponseData].
  ClubListModel _prepareSelectedClubList(UserPrivacyResponseData postElement) {
    return ClubListModel(
        clubName: postElement.clubDetails?.name,
        isSelected: postElement.isSelected ?? false,
        clubLogo: postElement.clubDetails?.profileImage,
        id: postElement.id);
  }

  /// build more option for hidden profile bottom sheet dialog
  void moreDialog() {
    Get.lazyPut<ProfileHidePreferenceBottomsheetController>(
      tag: Routes.PROFILE_HIDE_PREFERENCE_BOTTOMSHEET,
      () => ProfileHidePreferenceBottomsheetController(),
    );
    Get.bottomSheet(
      ProfileHidePreferenceBottomsheet(
          selectedValue: profilePrivacyTypeEnum.value),
    ).then((value) {
      Future.delayed(const Duration(seconds: 1), () {
        Get.delete<ProfileHidePreferenceBottomsheetController>(
            tag: Routes.PROFILE_HIDE_PREFERENCE_BOTTOMSHEET, force: true);
      });
    });
  }

  void onNextButton() {
    profilePrivacy(privacy: AppString.onlyForSelectedClub);
  }

  /// on hide from club apply.
  void onHideFromClubSelect(String selectedValue) {
    clubPrivacyResultType = selectedValue;
    isVisibleList.value = false;
    showSelectedClubList.value = true;
    profilePrivacyTypeEnum.value = ProfilePrivacyEnum.selectedClubs;
    updateUIOnSelection();

    if (clubList.isEmpty) {
      onSelectNoneClubHidden(AppString.profileHidePreferenceDes);
    }
  }

  /// click on more will enable list of all clubs which the user can
  /// update their selection.
  void onClickMore() {
    isVisibleList.value = true;
    pagingController.refresh();
  }

  /// when user select hide from all club.
  void onSelectAllClubHidden(String selectedValue) {
    isVisibleList.value = false;
    showSelectedClubList.value = false;
    profilePrivacyTypeEnum.value = ProfilePrivacyEnum.forAllClubs;
    updateUIOnSelection();
  }

  /// when user select hide from none club.
  void onSelectNoneClubHidden(String selectedValue) {
    isVisibleList.value = false;
    showSelectedClubList.value = false;
    clubPrivacyResultType = selectedValue;
    privacyMessage.value = AppString.profileHidePreferenceDes;
  }
}

enum ProfilePrivacyEnum {
  forAllClubs,
  selectedClubs,
  none;
}
