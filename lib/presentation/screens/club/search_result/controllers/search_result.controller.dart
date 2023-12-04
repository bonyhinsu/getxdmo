import 'package:dio/dio.dart' as dio;
import 'package:game_on_flutter/presentation/screens/club/search_result/controllers/user_filter_menu_controller.dart';
import 'package:game_on_flutter/presentation/screens/club/search_result/providers/search_result_provider.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../infrastructure/model/club/actiivty_filter_model.dart';
import '../../../../../infrastructure/model/club/home/recent_model.dart';
import '../../../../../infrastructure/model/club/post/player_activity_model.dart';
import '../../../../../infrastructure/navigation/route_config.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../infrastructure/network/api_utils.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../main.dart';
import '../../../../../values/app_constant.dart';
import '../../../../../values/app_string.dart';
import '../../../../../values/common_utils.dart';
import '../../../../app_widgets/app_loading_mixin.dart';
import '../../club_main/controllers/club_main.controller.dart';

class SearchResultController extends GetxController with AppLoadingMixin {
  /// String that stores search value.
  String _searchUser = "";

  /// Filter user search list
  RxList<RecentModel> filterUserList = RxList();

  /// store true if filter is applied otherwise false.
  RxBool isFilterApplied = false.obs;

  /// Menu list
  RxList<ClubActivityFilter> filterMenuList = RxList();

  bool fromSearchScreen = false;

  /// Paging controller
  final PagingController<int, RecentModel> pagingController =
  PagingController(firstPageKey: 0);

  final _provider = SearchResultProvider();

  /// filter ids.
  List<int> filterIds = [];

  /// stores global users
  List<RecentModel> userFilterList = [];

  /// locations
  List<String> appliedLocations = [];

  /// applied sports
  List<String> appliedSports = [];

  /// applied levels
  List<String> appliedLevels = [];

  /// applied genders
  List<String> appliedGenders = [];

  /// applied position
  List<String> appliedPositions = [];

  @override
  void onInit() {
    _setupPageListener();
    _getArguments();
    super.onInit();
  }

  /// Page change listener.
  void _setupPageListener() {
    pagingController.addPageRequestListener((pageKey) {
      _getPostAPI(pageKey);
    });
  }

  /// Get user posts API.
  void _getPostAPI(int pageKey) async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showLoading();
      String filterLocation = appliedLocations.join(', ');
      String filterLevels = appliedLevels.join(', ');
      String filterSports = appliedSports.join(', ');
      String filterGenders = appliedGenders.join(', ');
      String filterPositions = appliedPositions.join(', ');
      dio.Response? response = await _provider.getUserPostAPI(
          filterIds,
          pageKey,
          filterLocation,
          filterLevels,
          filterSports,
          filterGenders,
          filterPositions,
          search: _searchUser);
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
      userFilterList.clear();
      postResponse.data?.forEach((postElement) {
        userFilterList.add(_addDataToPostList(postElement));
      });
      if (isLastPage) {
        pagingController.appendLastPage(userFilterList);
      } else {
        final nextPageKey = pageKey + AppConstants.pageSize;
        pagingController.appendPage(userFilterList, nextPageKey);
      }
    } catch (e) {
      logger.e(e);
    }
    hideLoading();
  }

  /// get arguments from previous screen.
  void _getArguments() {
    if (Get.arguments != null) {
      _searchUser = Get.arguments[RouteArguments.searchValue] ?? "";
      isFilterApplied.value =
          Get.arguments[RouteArguments.filterApplied] ?? false;
      fromSearchScreen =
          Get.arguments[RouteArguments.fromSearchScreen] ?? false;

      if (isFilterApplied.value) {
        appliedSports = Get.arguments[RouteArguments.filterSport] ?? [];
        appliedLocations = Get.arguments[RouteArguments.filterLocation] ?? [];
        appliedLevels = Get.arguments[RouteArguments.filterLevel] ?? [];
        appliedGenders = Get.arguments[RouteArguments.filterGender] ?? [];
        appliedPositions = Get.arguments[RouteArguments.filterPositions] ?? [];
      }
    }
  }

  /// Add selected filter list.
  void _addSelectedFilter(List<ClubActivityFilter> tempList) {
    final isFilterSelected = tempList.firstWhereOrNull((element) {
      final result = element.filterSubItems
          .firstWhereOrNull((childElement) => childElement.isSelected);
      return result == null ? false : result.isSelected;
    });

    setFilterListToSelectedItems(isFilterSelected != null, tempList);

    appliedLocations.clear();
    appliedSports.clear();
    appliedLevels.clear();
    appliedGenders.clear();
    appliedPositions.clear();

    if (isFilterApplied.value) {
      final locations = (tempList
          .firstWhere((element) => element.title == AppString.locations));
      appliedLocations =
          (locations.filterSubItems.where((element) => element.isSelected))
              .map((e) => '\'${e.title ?? ""}\'')
              .toList();

      final sports =
      (tempList.firstWhere((element) => element.title == AppString.sports));
      appliedSports =
          (sports.filterSubItems.where((element) => element.isSelected))
              .map((e) => '\'${e.title ?? ""}\'')
              .toList();

      final levels =
      (tempList.firstWhere((element) => element.title == AppString.levels));
      appliedLevels =
          (levels.filterSubItems.where((element) => element.isSelected))
              .map((e) => '\'${e.title ?? ""}\'')
              .toList();

      final genders =
      (tempList.firstWhere((element) => element.title == AppString.gender));
      appliedGenders =
          (genders.filterSubItems.where((element) => element.isSelected))
              .map((e) => '\'${(e.title ?? "").replaceAll('\'', '0x27')}\'')
              .toList();

      final positions = (tempList.firstWhere(
              (element) => element.title == AppString.preferredPositions));
      appliedPositions =
          (positions.filterSubItems.where((element) => element.isSelected))
              .map((e) => '\'${e.title ?? ""}\'')
              .toList();
    }
    pagingController.refresh();
  }

  /// On like changed.
  void onLikeChange(int index, RecentModel postModel) {
    Get.toNamed(Routes.PLAYER_FAVOURITE_SELECTION, arguments: {
      RouteArguments.userId: postModel.userId.toString(),
      RouteArguments.alreadyLiked: postModel.isLiked
    })?.then((value) {
      if (value != null) {
        pagingController.refresh();
      }
    });
  }

  /// On player detail screen
  void playerDetailScreen(RecentModel postModel, int index) {
    Get.toNamed(Routes.CLUB_PLAYER_DETAIL,
        arguments: {RouteArguments.userId: postModel.userId.toString()});
  }

  /// open filter menu
  void openFilterMenu() {
    UserFilterMenuController controller =
    Get.find(tag: Routes.CLUB_PLAYER_FILTER);
    controller.navigateToFilterScreen(_addSelectedFilter);
  }

  /// set filter list to items
  void setFilterListToSelectedItems(bool filterApplied,
      List<ClubActivityFilter> tempList) {
    isFilterApplied.value = filterApplied;
    filterMenuList.value = tempList;
  }

  /// On search click.
  void onSearchClick() {
    if (fromSearchScreen) {
      Get.back();
    } else {
      Get.offAllNamed(Routes.CLUB_USER_SEARCH);
    }
  }

  /// Perform api error.
  void _getAPIError(dio.Response response) {
    hideGlobalLoading();
    pagingController.error = response.statusMessage;
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
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

  /// On change tab
  void onChangeTab(int index) {
    final ClubMainController _clubMainController =
    Get.find(tag: Routes.CLUB_MAIN);
    _clubMainController.changeTabIndex(index);
    Get.until((route) => route.settings.name == Routes.CLUB_MAIN);
  }
}
