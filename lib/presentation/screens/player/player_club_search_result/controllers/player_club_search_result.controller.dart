import 'package:collection/collection.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:game_on_flutter/presentation/screens/player/player_main/controllers/player_main.controller.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';

import '../../../../../infrastructure/model/advertisement/advertisement_list_model.dart';
import '../../../../../infrastructure/model/club/actiivty_filter_model.dart';
import '../../../../../infrastructure/model/club/home/club_list_model.dart';
import '../../../../../infrastructure/model/club/post/post_model.dart';
import '../../../../../infrastructure/model/player/favourite/favourite_result_response.dart';
import '../../../../../infrastructure/model/player/search_club/search_club_response_model.dart';
import '../../../../../infrastructure/navigation/route_config.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../infrastructure/network/api_utils.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../values/app_constant.dart';
import '../../../../../values/app_string.dart';
import '../../../../../values/common_utils.dart';
import '../../../../app_widgets/app_loading_mixin.dart';
import '../../../club/search_result/controllers/user_filter_menu_controller.dart';
import '../../player_home/controllers/player_favourite_filter_controller.dart';
import '../provider/player_club_search_result_provider.dart';

class PlayerClubSearchResultController extends GetxController
    with AppLoadingMixin {
  /// String that stores search value.
  String _searchUser = "";

  /// Filter user search list
  RxList<ClubListModel> filterUserList = RxList();

  String get searchUser => _searchUser;

  RxList<PostModel> recentPosts = RxList();

  final ScrollController scrollcontroller = new ScrollController();

  /// Menu list
  RxList<ClubActivityFilter> filterMenuList = RxList();

  /// Shows filter option when user applied filter.
  RxBool isFilterApplied = false.obs;

  bool fromSearchScreen = false;

  int pageKey = 0;

  bool isLastPage = false;

  final logger = Logger();

  /// provider
  PlayerSearchResultProvider provider = PlayerSearchResultProvider();

  final _provider = PlayerSearchResultProvider();

  /// Fetched advertisements.
  List<AdvertisementListModelData> advertisements = [];

  /// Paging controller
  final PagingController<int, ClubListModel> pagingController =
      PagingController(firstPageKey: 0);

  /// locations
  List<String> appliedLocations = [];

  /// applied sports
  List<String> appliedSports = [];

  /// applied levels
  List<String> appliedLevels = [];

  @override
  void onInit() {
    _getArguments();
    super.onInit();
  }


  /// On filter click
  void onFilter() {
    UserFilterMenuController controller =
        Get.find(tag: Routes.CLUB_PLAYER_FILTER);
    controller.navigateToFilterScreen(addSelectedFilter);
  }

  /// Add selected filter list.
  ///
  /// require[tempList]
  void addSelectedFilter(List<ClubActivityFilter> tempList) {
    final isFilterSelected = tempList.firstWhereOrNull((element) {
      final result = element.filterSubItems
          .firstWhereOrNull((childElement) => childElement.isSelected);
      return result == null ? false : result.isSelected;
    });
    isFilterApplied.value = isFilterSelected != null;
    filterMenuList.value = tempList;

    appliedLocations.clear();
    appliedSports.clear();
    appliedLevels.clear();

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
    }
    pagingController.refresh();
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
      }
      _setupPageListener();
      getAdvertisements();
      getClubListAPI(0);
    }
  }

  /// Page change listener.
  void _setupPageListener() {
    pagingController.addPageRequestListener((pageKey) {
      getClubListAPI(pageKey);
    });
  }

  /// Open link in platform specific browser.
  void openLinkInPlatformBrowser(String link) {
    CommonUtils.openLinkInBrowser(link);
  }

  Future<void> onRefresh() async {
    pagingController.refresh();
  }

  /// Navigate to club detail screen on click
  void navigateToUserDetailScreen(SearchClubResponseModelData clubDetail) {
    Get.toNamed(Routes.CLUB_DETAIL,
        arguments: {RouteArguments.userId: clubDetail.id.toString()});
  }

  /// On like changed.
  void onLikeChange(int index, ClubListModel postModel) {
    Get.toNamed(Routes.PLAYER_FAVOURITE_SELECTION, arguments: {
      RouteArguments.userId: postModel.id.toString(),
      RouteArguments.alreadyLiked: postModel.isLiked
    })?.then((value) {
      if (value != null) {
        final checkForSelectedElement =
            value.indexWhere((element) => element.isSelected == true);

        pagingController.itemList![index].isLiked =
            checkForSelectedElement != -1;
        pagingController.notifyPageRequestListeners(index);
      }
    });
  }

  /// Get club list API.
  void getClubListAPI(int pageKey) async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      String filterLocation = appliedLocations.join(', ');
      String filterLevels = appliedLevels.join(', ');
      String filterSports = appliedSports.join(', ');
      showLoading();
      dio.Response? response = await _provider.getClubList(
          [], filterLocation, filterLevels, filterSports, pageKey,
          search: _searchUser);
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _getPostSuccess(response, pageKey);
        } else {
          /// On Error
          _deletePostError(response);
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
      FavouriteResultResponse postResponse =
          FavouriteResultResponse.fromJson(response.data!);

      bool isLastPage =
          (postResponse.data ?? []).length < AppConstants.pageSize;

      List<ClubListModel> newItems = [];

      postResponse.data?.forEachIndexed((index, postElement) {
        final clubFavouriteModel = _getClubFavouriteModel(postElement);
        newItems.add(clubFavouriteModel);
      });
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + AppConstants.pageSize;
        pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (e) {
      logger.e(e);
    }
    hideLoading();
  }

  /// Returns [ClubListModel] from [PlayerFavouriteClubListResponseData].
  ClubListModel _getClubFavouriteModel(
      FavouriteResultResponseData responseData) {
    String sportLogoImage = responseData.allSportImage ?? "";
    if (sportLogoImage.contains(',')) {
      sportLogoImage = (responseData.allSportImage ?? "").split(',')[0];
    }

    return ClubListModel(
      clubLogo: responseData.profileImage,
      clubName: responseData.name,
      isLiked: responseData.isFavourite == 1,
      level: responseData.allLevels,
      location: responseData.allLocation,
      sports: responseData.allSport,
      sportLogo: sportLogoImage,
      position: responseData.allGenders,
      id: responseData.id,
    );
  }

  /// On player detail screen
  ///
  /// require[postModel]
  /// require[index]
  void playerDetailScreen(ClubListModel postModel, int index) {
    Get.toNamed(Routes.CLUB_DETAIL,
        arguments: {RouteArguments.userId: postModel.id.toString()});
  }

  /// Perform api error.
  void _deletePostError(dio.Response response) {
    hideGlobalLoading();
    pagingController.error = response.statusMessage;
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }

  /// On search click.
  void onSearchClick() {
    if (fromSearchScreen) {
      Get.back();
    } else {
      Get.offAllNamed(Routes.PLAYER_CLUB_SEARCH);
    }
  }

  /// Get advertisement API.
  void getAdvertisements() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showLoading();
      dio.Response? response = await _provider.getAdvertisement();
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _getAdvertisementSuccessAPI(response);
        } else {
          /// On Error
          hideLoading();
          GetIt.instance<ApiUtils>().parseErrorResponse(response);
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

  /// Perform api error.
  void _getAdvertisementSuccessAPI(dio.Response response) {
    hideLoading();
    AdvertisementListModel advertisementListModel =
        AdvertisementListModel.fromJson(response.data);
    advertisements = advertisementListModel.data ?? [];
  }

  /// On change tab
  void onChangeTab(int index) {
    final PlayerMainController _playerMainController =
        Get.find(tag: Routes.PLAYER_MAIN);
    _playerMainController.changeTabIndex(index);
    Get.until((route) => route.settings.name == Routes.PLAYER_MAIN);
  }
}
