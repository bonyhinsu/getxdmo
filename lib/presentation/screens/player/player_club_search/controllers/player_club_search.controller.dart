import 'dart:async';

import 'package:dio/dio.dart' as dio;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_loading_mixin.dart';
import 'package:game_on_flutter/values/app_values.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../infrastructure/model/advertisement/advertisement_list_model.dart';
import '../../../../../infrastructure/model/club/actiivty_filter_model.dart';
import '../../../../../infrastructure/model/club/home/club_list_model.dart';
import '../../../../../infrastructure/model/club/post/post_filter_model.dart';
import '../../../../../infrastructure/model/club/post/post_list_model.dart';
import '../../../../../infrastructure/model/club/post/post_model.dart';
import '../../../../../infrastructure/model/player/search_club/search_club_response_model.dart';
import '../../../../../infrastructure/navigation/route_config.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../infrastructure/network/api_utils.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../main.dart';
import '../../../../../values/app_constant.dart';
import '../../../../../values/common_utils.dart';
import '../provider/player_club_search_provider.dart';

class PlayerClubSearchController extends GetxController with AppLoadingMixin {
  /// stores global users.
  RxList<SearchClubResponseModelData> userFilterList = RxList();

  /// text editing controller.
  TextEditingController searchController = TextEditingController();

  List<SearchClubResponseModelData> filterOptions = RxList();

  /// focus node
  FocusNode searchFocusNode = FocusNode();

  /// Menu list
  RxList<ClubActivityFilter> filterMenuList = RxList();

  /// show no data widget.
  bool showNoData = false;

  /// Shows filter option when user applied filter.
  RxBool isFilterApplied = false.obs;

  /// Filter user search list
  List<ClubListModel> filterUserList = RxList();

  /// Provider
  final PlayerClubSearchProvider _provider = PlayerClubSearchProvider();

  /// String that stores search value.
  String _searchUser = "";

  String get getSearchValue => _searchUser;

  /// Timer to track when user stops type and start to search for filter.
  Timer? searchOnStoppedTyping;


  /// Paging controller
  final PagingController<int, SearchClubResponseModelData> pagingController =
  PagingController(firstPageKey: 0);

  @override
  void onInit() {
    // userFilterList = DataProvider().getClubListForSearch();
    _clearFilter();
    searchFocusNode.requestFocus();
    super.onInit();
  }
  /// Page change listener.
  void _setupPageListener() {
    pagingController.addPageRequestListener((pageKey) {
      _getUserSearch(pageKey);
    });
  }

  /// Open link in platform specific browser.
  void openLinkInPlatformBrowser(String link) {
    CommonUtils.openLinkInBrowser(link);
  }

  Future<void> onRefresh() async {
    pagingController.refresh();
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

  /// clear filter list.
  void _clearFilter() {
    userFilterList.clear();
  }

  /// Search for user by filter available list.
  void searchForUser(String value) {
    _searchUser = value;
    userFilterList.clear();
    _getUserSearch(0);
  }

  /// Get user posts API.
  void _getUserSearch(int pageKey) async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showLoading();
      dio.Response? response =
          await _provider.getClubList([], pageKey, search: _searchUser);
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

  /// Perform api error.
  void _getAPIError(dio.Response response) {
    hideGlobalLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }

  /// Perform login api success
  void _getPostSuccess(dio.Response response, int pageKey) {
    try {
      SearchClubResponseModel postResponse =
      SearchClubResponseModel.fromJson(response.data!);
      userFilterList.value = postResponse.data ?? [];
      userFilterList.refresh();
    } catch (e) {
      logger.e(e);
    }
    hideLoading();
  }

  /// Navigate to view all screen
  void navigateToViewAllScreen() {
    Get.toNamed(Routes.PLAYER_SEARCH_RESULT, arguments: {
      RouteArguments.searchValue: _searchUser,
      RouteArguments.fromSearchScreen: true
    });
  }

  /// Navigate to club detail screen on click
  void navigateToUserDetailScreen(SearchClubResponseModelData clubDetail) {
    Get.toNamed(Routes.CLUB_DETAIL,
        arguments: {RouteArguments.userId: clubDetail.id});
  }

  /// on Back click
  void onBackPressed() => Get.back();

  /// filter user list API.
  void getFilterUserList() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showLoading();
      dio.Response? response = await _provider.getSearchUsers();
      if (response != null) {
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _playerClubSearchSuccess(response);
        } else {
          /// On Error
          _playerClubError(response);
        }
      } else {
        hideLoading();
        GetIt.I<CommonUtils>().showServerDownError();
      }
    } else {
      hideLoading();
      GetIt.I<CommonUtils>().showNetworkError();
    }
  }

  /// Perform club search api success
  void _playerClubSearchSuccess(dio.Response response) {
    hideLoading();
  }

  /// Perform api error.
  void _playerClubError(dio.Response response) {
    hideLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }


}
