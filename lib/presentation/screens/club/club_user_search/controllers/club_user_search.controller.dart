import 'dart:async';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_loading_mixin.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../infrastructure/model/club/home/recent_model.dart';
import '../../../../../infrastructure/model/club/post/player_activity_model.dart';
import '../../../../../infrastructure/navigation/route_config.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../infrastructure/network/api_utils.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../main.dart';
import '../../../../../values/app_constant.dart';
import '../../../../../values/app_values.dart';
import '../../../../../values/common_utils.dart';
import '../providers/club_user_search_provider.dart';

class ClubUserSearchController extends GetxController with AppLoadingMixin {
  /// stores global users
  RxList<RecentModel> userFilterList = RxList();

  TextEditingController searchController = TextEditingController();

  FocusNode searchFocusNode = FocusNode();

  /// Filter user search list
  List<RecentModel> filterUserList = RxList();

  /// String that stores search value.
  String _searchUser = "";

  String get getSearchValue => _searchUser;

  Timer? searchOnStoppedTyping;

  final _provider = ClubUserSearchProvider();

  /// filter ids.
  List<int> filterIds = [];

  /// Paging controller
  final PagingController<int, RecentModel> pagingController =
      PagingController(firstPageKey: 0);

  @override
  void onInit() {
    _clearFilter();
    searchFocusNode.requestFocus();
    super.onInit();
  }

  /// Get user posts API.
  void _getUserSearch(int pageKey) async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showLoading();
      dio.Response? response =
          await _provider.getUserPostAPI([], pageKey, search: _searchUser);
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
      ClubActivityListModel postResponse =
          ClubActivityListModel.fromJson(response.data!);
      postResponse.data?.forEach((postElement) {
        final element = _addDataToPostList(postElement);
        userFilterList.add(element);
      });
      userFilterList.refresh();
    } catch (e) {
      logger.e(e);
    }
    hideLoading();
  }

  /// clear filter list.
  void _clearFilter() {
    userFilterList.clear();
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
    userFilterList.clear();
    _getUserSearch(0);
  }

  /// on Back click
  void onBackPressed() => Get.back();

  /// Navigate to view all screen
  void navigateToViewAllScreen() {
    FocusManager.instance.primaryFocus?.unfocus();
    Get.toNamed(Routes.SEARCH_RESULT, arguments: {
      RouteArguments.searchValue: _searchUser,
      RouteArguments.fromSearchScreen: true
    });
  }

  /// Navigate to user detail screen on click
  void navigateToUserDetailScreen(RecentModel userDetail) {
    Get.toNamed(Routes.CLUB_PLAYER_DETAIL,
        arguments: {RouteArguments.userId: userDetail.userId.toString()});
  }

  /// Add data to list.
  ///
  /// required [PostListResponseData].
  RecentModel _addDataToPostList(ClubActivityListModelData postElement) {
    return RecentModel(
      userId: postElement.id,
      playerDescription: postElement.bio,
      playerAge: postElement.age.toString(),
      playerHeight: null,
      playerImage: postElement.profileImage,
      playerPhoneNumber: null,
      playerPosition: postElement.positionsName,
      playerWeight: null,
      totalFollowers: null,
      uuid: null,
      videos: null,
      clubPictures: null,
      isMale: (postElement.gender ?? "male").toLowerCase() == 'male' ||
          (postElement.gender ?? "male").toLowerCase() == 'men\'s',
      gender: postElement.gender,
      isAdvertisement: false,
      isFromAsset: false,
      isLiked: postElement.isFavourite == 1,
      playerBio: postElement.bio,
      playerDistance: postElement.allLocation,
      playerEmail: null,
      date: null,
      playerName: postElement.name,
    );
  }
}
