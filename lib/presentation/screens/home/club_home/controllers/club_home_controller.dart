import 'package:collection/collection.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_loading_mixin.dart';
import 'package:game_on_flutter/values/app_constant.dart';
import 'package:game_on_flutter/values/common_utils.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';

import '../../../../../infrastructure/model/advertisement/advertisement_list_model.dart';
import '../../../../../infrastructure/model/club/actiivty_filter_model.dart';
import '../../../../../infrastructure/model/club/home/recent_model.dart';
import '../../../../../infrastructure/model/club/post/player_activity_model.dart';
import '../../../../../infrastructure/navigation/route_config.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../infrastructure/network/api_utils.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../values/app_colors.dart';
import '../../../../../values/app_string.dart';
import '../../../chats/chat_main/controllers/chat_main.controller.dart';
import '../../../club/search_result/controllers/user_filter_menu_controller.dart';
import '../providers/club_home_provider.dart';
import '../view/create_post_bottomsheet.dart';

class ClubHomeController extends GetxController with AppLoadingMixin {
  /// Reference [TextEditingController] for search textfield.
  late TextEditingController searchTextEditingController;

  final ScrollController scrollcontroller = ScrollController();

  /// Reference [FocusNode] for search textfield.
  late FocusNode searchFocusNode;

  /// Stores and return true when search field gets focus.
  RxBool searchFocus = false.obs;

  /// Store search string which is enter by the user to search buyer.
  final RxString _search = "".obs;

  /// Paging controller
  final PagingController<int, RecentModel> pagingController =
      PagingController(firstPageKey: 0);

  /// Store and return true when all the fields are valid.
  RxBool isValidated = false.obs;

  /// filter ids.
  List<int> filterIds = [];

  /// store true if filter is applied otherwise false.
  RxBool isFilterApplied = false.obs;

  RxString get search => _search;

  final logger = Logger();

  /// provider
  final _provider = ClubHomeProvider();

  /// Menu list
  RxList<ClubActivityFilter> filterMenuList = RxList();

  /// Fetched advertisements.
  List<AdvertisementListModelData> advertisements = [];

  @override
  void onInit() {
    searchTextEditingController = TextEditingController(text: "");
    searchFocusNode = FocusNode();

    /// Keeps listen for focus [searchFocusNode] and update [searchFocus] field.
    searchFocusNode.addListener(() {
      searchFocus.value = searchFocusNode.hasFocus;
    });
    _setupPageListener();
    getAdvertisements();
    super.onInit();
  }

  @override
  void onReady() {
    final ChatMainController controller = Get.find(tag: Routes.CHAT_MAIN);
    controller.getUserThreads();
    super.onReady();
  }

  /// Page change listener.
  void _setupPageListener() {
    pagingController.addPageRequestListener((pageKey) {
      _getPostAPI(pageKey);
    });
  }

  /// Open link in platform specific browser.
  void openLinkInPlatformBrowser(String link) {
    CommonUtils.openLinkInBrowser(link);
  }

  Future<void> onRefresh() async {
    pagingController.refresh();
  }

  /// set search mobile value
  void setSearchMobile(String value) {
    setSearch(value);
  }

  void setSearch(String search) {
    _search.value = search;
    checkValidation();
  }

  /// Checks validation if fields are valid or not then store
  /// values to [isValidated].
  void checkValidation() {
    isValidated.value = isValidSearch();
  }

  /// Checks validation if fields are valid or not then store
  /// values to [isValidated].
  bool isValidSearch() {
    return GetUtils.isTxt(search.value);
  }

  /// Verify data then navigate to filter screen.
  void navigateToFilterScreen() async {
    UserFilterMenuController controller =
        Get.find(tag: Routes.CLUB_PLAYER_FILTER);
    controller.navigateToFilterScreen(addSelectedFilter, clearFilters: true);
  }

  /// Add selected filter list.
  void addSelectedFilter(List<ClubActivityFilter> tempList) {
    final isFilterSelected = tempList.firstWhereOrNull((element) {
      final result = element.filterSubItems
          .firstWhereOrNull((childElement) => childElement.isSelected);
      return result == null ? false : result.isSelected;
    });

    setFilterListToSelectedItems(isFilterSelected != null, tempList);

    List<String> appliedLocations = [];
    List<String> appliedSports = [];
    List<String> appliedLevels = [];
    List<String> appliedGender = [];
    List<String> appliedPositions = [];

    if (isFilterApplied.value) {
      // Locations
      final locations = (tempList
          .firstWhere((element) => element.title == AppString.locations));
      appliedLocations =
          (locations.filterSubItems.where((element) => element.isSelected))
              .map((e) => '\'${e.title ?? ""}\'')
              .toList();

      // Sports
      final sports =
          (tempList.firstWhere((element) => element.title == AppString.sports));
      appliedSports =
          (sports.filterSubItems.where((element) => element.isSelected))
              .map((e) => '\'${e.title ?? ""}\'')
              .toList();

      // Levels
      final levels =
          (tempList.firstWhere((element) => element.title == AppString.levels));
      appliedLevels =
          (levels.filterSubItems.where((element) => element.isSelected))
              .map((e) => '\'${e.title ?? ""}\'')
              .toList();

      // Genders
      final genders =
          (tempList.firstWhere((element) => element.title == AppString.gender));
      appliedGender =
          (genders.filterSubItems.where((element) => element.isSelected))
              .map((e) => '\'${e.title ?? ""}\'')
              .toList();

      // Positions
      final positions = (tempList.firstWhere(
          (element) => element.title == AppString.preferredPositions));
      appliedPositions =
          (positions.filterSubItems.where((element) => element.isSelected))
              .map((e) => '\'${e.title ?? ""}\'')
              .toList();
    }

    // Navigate to search result with filtered values.
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Get.toNamed(Routes.SEARCH_RESULT, arguments: {
        RouteArguments.searchValue: '',
        RouteArguments.appliedFilterMenuList: tempList,
        RouteArguments.filterApplied: isFilterApplied.isTrue,
        RouteArguments.filterSport: appliedSports,
        RouteArguments.filterLocation: appliedLocations,
        RouteArguments.filterLevel: appliedLevels,
        RouteArguments.filterGender: appliedGender,
        RouteArguments.filterPositions: appliedPositions,
      });
    });
  }

  /// set filter list to items
  void setFilterListToSelectedItems(
      bool filterApplied, List<ClubActivityFilter> tempList) {
    isFilterApplied.value = filterApplied;
    filterMenuList.value = tempList;
  }

  /// On search click
  void onSearchClick() {
    Get.toNamed(Routes.CLUB_USER_SEARCH);
  }

  /// On like changed.
  void onLikeChange(int index, RecentModel postModel) {
    Get.toNamed(Routes.PLAYER_FAVOURITE_SELECTION, arguments: {
      RouteArguments.userId: postModel.userId.toString(),
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

  /// On player detail screen
  void playerDetailScreen(RecentModel postModel, int index) {
    Get.toNamed(Routes.CLUB_PLAYER_DETAIL, arguments: {
      RouteArguments.userId: postModel.userId.toString(),
      RouteArguments.listItemIndex: index
    });
  }

  /// add post click event.
  void onAddPostClick() {
    Get.bottomSheet(
      CreatePostBottomsheet(),
      isScrollControlled: true,
      barrierColor: AppColors.bottomSheetBgBlurColor,
    );
  }

  /// update like icon.
  void updateLikeButton(bool isLike, int index) {
    pagingController.itemList![index].isLiked = isLike;
    pagingController.refresh();
  }

  /// Get user posts API.
  void _getPostAPI(int pageKey) async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showLoading();
      dio.Response? response =
          await _provider.getUserPostAPI(filterIds, pageKey, search: '');
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _getPostSuccess(response, pageKey);
        } else {
          /// On Error
          _getAPIError(response);
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
  void _getAPIError(dio.Response response) {
    hideLoading();
    pagingController.error = response.statusMessage;
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }

  /// Perform login api success
  void _getPostSuccess(dio.Response response, int pageKey) {
    try {
      ClubActivityListModel postResponse =
          ClubActivityListModel.fromJson(response.data!);
      bool isLastPage =
          (postResponse.data ?? []).length < AppConstants.pageSize;
      List<RecentModel> newItems = [];

      /// Get advertisement random Id.
      final postIndex = CommonUtils.getRandom(
          min: (pageKey * AppConstants.pageSize),
          max: (pageKey * AppConstants.pageSize) + AppConstants.pageSize);

      postResponse.data?.forEachIndexed((index, postElement) {
        if (advertisements.isNotEmpty) {
          if (postIndex == index) {
            // Get advertisement random Id. Collect random id from 0 to max advertisement length-1
            final advertisementRandomId =
                CommonUtils.getRandom(min: 0, max: advertisements.length - 1);
            newItems.add(RecentModel.advertisement(
                advertisementBanner:
                    advertisements[advertisementRandomId].image,
                advertisementLink: advertisements[advertisementRandomId].link));
          }
        }
        newItems.add(_addDataToPostList(postElement));
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

  /// update like change to the player list.
  void updateLikeChangeToList(int index, bool isLiked) {
    pagingController.itemList![index].isLiked = isLiked;
    pagingController.notifyPageRequestListeners(index);
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
          _getAPIError(response);
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
}
