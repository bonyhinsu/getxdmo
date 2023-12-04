import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:game_on_flutter/infrastructure/model/club/home/club_list_model.dart';
import 'package:game_on_flutter/infrastructure/model/club/post/player_activity_model.dart';
import 'package:game_on_flutter/infrastructure/storage/preference_manager.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_dialog_with_title_widget.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_loading_mixin.dart';
import 'package:game_on_flutter/presentation/screens/player/player_profile_privacy/select_club/provider/select_club_provider.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get_it/get_it.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../../infrastructure/navigation/routes.dart';
import '../../../../../../infrastructure/network/api_utils.dart';
import '../../../../../../infrastructure/network/network_config.dart';
import '../../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../../main.dart';
import '../../../../../../values/app_constant.dart';
import '../../../../../../values/app_string.dart';
import '../../../../../../values/app_values.dart';
import '../../../../../../values/common_utils.dart';
import '../../controllers/player_profile_privacy.controller.dart';
import '../../provider/player_profile_privacy_provider.dart';

class SelectClubController extends GetxController with AppLoadingMixin {
  /// club list which clubs are selected by the user.
  RxList<ClubListModel> clubList = <ClubListModel>[].obs;

  /// True if the user select at least one club.
  RxBool validateField = false.obs;

  /// text editing controller.
  TextEditingController searchController = TextEditingController();

  /// focus node
  FocusNode searchFocusNode = FocusNode();

  Timer? searchOnStoppedTyping;

  /// Filter user search list
  RxList<ClubListModel> filterUserList = RxList();

  /// String that stores search value.
  String _searchUser = "";

  final _provider = SelectClubProvider();
  final _providerProfile = PlayerProfilePrivacyProvider();

  String get getSearchValue => _searchUser;

  RxList selectedClubIds = [].obs;

  List<int> filterIds = [];

  final PagingController<int, ClubListModel> pagingController =
      PagingController(firstPageKey: 0);

  @override
  void onInit() {
    _getUserSelectedClubForProfilePrivacy(0);
    _setupPageListener();
    super.onInit();
  }

  /// Page change listener.
  void _setupPageListener() {
    pagingController.addPageRequestListener((pageKey) {
      _getUserSelectedClubForProfilePrivacy(pageKey);
    });
  }

  /// add checked data in temp array
  void addToTempList(int index, bool isChecked) {
    pagingController.itemList![index].isSelected = isChecked;

    if (pagingController.itemList![index].isSelected) {
      selectedClubIds.add(pagingController.itemList![index].id);
    } else {
      selectedClubIds.remove(pagingController.itemList![index].id);
    }
    clubList.refresh();
    validateField.value =
        pagingController.itemList!.where((element) => element.isSelected).toList().isNotEmpty;
    validateField.refresh();
  }

  void onSave() {
    Get.dialog(AppDialogWithTitleWidget(
      onDone: _onDone,
      dialogText: AppString.hideFromSelectedClubMessage,
      dialogTitle: AppString.hideFromClubTitle,
    ));
  }

  _onDone() {
    Get.back(result: selectedClubIds.value);
  }


  /// Add change handler delay when user search for club.
  void onChangeHandler(value) {
    showLoading();
    const duration = Duration(
        milliseconds: AppValues
            .userSearchTypeDelay); // set the duration that you want call search() after that.
    if (searchOnStoppedTyping != null) {
      searchOnStoppedTyping?.cancel(); // clear timer
    }
    searchOnStoppedTyping = Timer(duration, () => searchForUser(value));
  }

  /// Search for user by filter available list.
  void searchForUser(String value) {
    _searchUser = value;
    clubList.clear();
    _getUserSelectedClubForProfilePrivacy(0);
  }

  /// Get user posts API.
  void _getUserSelectedClubForProfilePrivacy(int pageKey) async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showLoading();
      dio.Response? response = await _provider
          .getAllUserSelectedClubs(filterIds, pageKey, search: _searchUser);
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

  /// Perform login api success
  void _getPostSuccess(dio.Response response, int pageKey) {
    try {
      ClubActivityListModel postResponse =
          ClubActivityListModel.fromJson(response.data!);
      bool isLastPage =
          (postResponse.data ?? []).length < AppConstants.pageSize;
      clubList.clear();
      postResponse.data?.forEach((postElement) {
        clubList.add(_addDataToPostList(postElement));
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

  /// Perform api error.
  void _getAPIError(dio.Response response) {
    hideGlobalLoading();
    pagingController.error = response.statusMessage;
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }

  ClubListModel _addDataToPostList(ClubActivityListModelData postElement) {
    return ClubListModel(
        clubName: postElement.name,
        isSelected: postElement.isSelected ?? false,
        clubLogo: postElement.profileImage,
        id: postElement.id);
  }
}
