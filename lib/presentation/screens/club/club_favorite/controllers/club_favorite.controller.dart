import 'package:dio/dio.dart' as dio;
import 'package:game_on_flutter/infrastructure/storage/preference_manager.dart';
import 'package:game_on_flutter/values/app_constant.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:group_button/group_button.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';

import '../../../../../infrastructure/model/club/favourite/favourite_player_response_model.dart';
import '../../../../../infrastructure/model/club/home/recent_model.dart';
import '../../../../../infrastructure/model/club/post/post_filter_model.dart';
import '../../../../../infrastructure/model/favourite/favourite_list_response.dart';
import '../../../../../infrastructure/model/player/favourite/favourite_type_model.dart';
import '../../../../../infrastructure/navigation/route_config.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../infrastructure/network/api_utils.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../values/app_colors.dart';
import '../../../../../values/common_utils.dart';
import '../../../../app_widgets/app_loading_mixin.dart';
import '../../../home/club_player_detail/controllers/club_player_detail.controller.dart';
import '../favorite_bottomsheet_controller.dart';
import '../favorite_filter_post_bottomsheet.dart';
import '../providers/club_favorite_provider.dart';

class ClubFavoriteController extends GetxController with AppLoadingMixin {
  /// Favourite user list.
  RxList<RecentModel> favouriteUsers = RxList();

  /// Menu filter list.
  RxList<PostFilterModel> filterOption = RxList();

  /// User applied filter list
  RxList<PostFilterModel> appliedFilter = RxList();

  /// store true if filter is applied otherwise false.
  RxBool isFilterApplied = false.obs;

  /// store true if login user is player otherwise false.
  ///
  /// selected filter are listed.
  RxBool isPlayerLoggedIn = false.obs;

  ClubFavoriteProvider _provider = ClubFavoriteProvider();

  // Rx List.
  RxList<FavouriteTypeModel> favouriteTypeList = RxList();

  /// logger
  final logger = Logger();

  /// Paging controller
  final PagingController<int, RecentModel> pagingController =
      PagingController(firstPageKey: 0);

  /// filter menu item list.
  RxList<PostFilterModel> filterMenuList = RxList();

  /// Button selection controller
  GroupButtonController groupButtonController = GroupButtonController();

  List<int> arrSelectedIndex = [];

  @override
  void onInit() {
    isPlayerLoggedIn.value =
        GetIt.I<PreferenceManager>().getUserType == AppConstants.userTypePlayer;
    _setupPageListener();
    _getUserFavouriteTypeAPI();
    super.onInit();
  }

  /// Page change listener.
  void _setupPageListener() {
    pagingController.addPageRequestListener((pageKey) {
      _getPostAPI(pageKey);
    });
  }

  /// build favorite bottomSheet dialog
  void onFilter() {
    Get.lazyPut<FavoriteBottomsheetController>(
        () => FavoriteBottomsheetController(),
        tag: Routes.FAVORITE_FILTER);
    Get.bottomSheet(
      FavoriteFilterPostBottomSheet(
        index: 0,
        onItemChange: onSelection,
        list: filterOption,
      ),
      barrierColor: AppColors.bottomSheetBgBlurColor,
      isScrollControlled: true,
    ).then((value) {
      Get.delete<FavoriteBottomsheetController>(
          tag: Routes.FAVORITE_FILTER, force: true);
    });
  }

  /// On search click.
  void onSearchClick() {
    Get.toNamed(Routes.CLUB_USER_SEARCH);
  }

  /// on select delete item
  void onDeleteFilter(int index) {
    onTapButton(index, false);
    appliedFilter.removeAt(index);
    filterOnClear();
    isFilterApplied.value = appliedFilter.isNotEmpty;
  }

  /// apply filter on click on the list
  void filterOnClear() {
    final tempList = filterOption;
    isFilterApplied.value = tempList.isNotEmpty;
    arrSelectedIndex.clear();
    appliedFilter.clear();

    if (isFilterApplied.value) {
      List<int> arrSelectedIndex = [];

      for (int i = 0; i < tempList.length; i++) {
        if (tempList[i].isSelected) {
          arrSelectedIndex.add(i);
          appliedFilter.add(tempList[i]);
        }
      }

      if (isPlayerLoggedIn.isTrue) {
        groupButtonController.selectIndexes(arrSelectedIndex);
      }
    } else {
      arrSelectedIndex.clear();
    }

    pagingController.refresh();
  }

  /// on selection click
  void onSelection(int childIndex, bool isSelected) {

  }

  /// On Tap button
  void onTapButton(int index, bool isSelected) {
    final selectedIndex = filterOption
        .indexWhere((element) => element.title == appliedFilter[index].title);
    if (selectedIndex != -1) {
      filterOption[selectedIndex].isSelected = isSelected;
    }
  }

  /// Add selected filter list.
  void addSelectedFilter(RxList<PostFilterModel> tempList) {
    final isFilterSelected = tempList.firstWhereOrNull((element) {
      final result = element.isSelected;
      return result ?? false;
    });
    isFilterApplied.value = isFilterSelected != null;
    appliedFilter.clear();
    arrSelectedIndex.clear();
    if (isFilterApplied.value) {
      for (int i = 0; i < tempList.length; i++) {
        if (tempList[i].isSelected) {
          arrSelectedIndex.add(i);
          appliedFilter.add(tempList[i]);
        }
      }
      groupButtonController.selectIndexes(arrSelectedIndex);
    }
    pagingController.refresh();
  }

  void changeFavouriteStatus(int index) {}

  /// On like changed.
  void onLikeChange(int index, RecentModel postModel) {
    Get.toNamed(Routes.PLAYER_FAVOURITE_SELECTION, arguments: {
      RouteArguments.userId: postModel.userId.toString(),
      RouteArguments.alreadyLiked: postModel.isLiked
    })?.then((value) {
      if (value != null) {
        final checkForSelectedElement =
            value.indexWhere((element) => element.isSelected == true);

        updateLikeChangeToList(index, checkForSelectedElement != -1);
      }
    });
  }

  /// On player detail screen
  void playerDetailScreen(RecentModel postModel, int index) {
    Get.toNamed(Routes.CLUB_PLAYER_DETAIL, arguments: {
      RouteArguments.userId: postModel.userId.toString(),
      RouteArguments.listItemIndex: index,
      RouteArguments.playerDetailViewTypeEnum:
          PlayerDetailViewTypeEnum.clubFavourite
    });
  }

  void updatePlayerToFavourite(List<FavouriteTypeModel> filterList, int index) {
    // favouriteUsers[index].favouriteList = filterList;

    final checkForSelectedElement =
        filterList.indexWhere((element) => element.isSelected == true);

    favouriteUsers[index].isLiked = checkForSelectedElement != -1;
    favouriteUsers.refresh();
  }

  /// update like change to the player list.
  void updateLikeChangeToList(int index, bool isLiked) {
    if (!isLiked) {
      pagingController.refresh();
    }
  }

  /// Get user posts API.
  void _getPostAPI(int pageKey) async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showLoading();
      List<int> appliedFilterIds =
          appliedFilter.map((element) => element.itemId ?? -1).toList();
      dio.Response? response =
          await _provider.getUserPostAPI(appliedFilterIds, pageKey, search: '');
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
      FavouritePlayerResponsePlayer postResponse =
          FavouritePlayerResponsePlayer.fromJson(response.data!);
      bool isLastPage =
          (postResponse.data ?? []).length < AppConstants.pageSize;
      List<RecentModel> newItems = [];
      postResponse.data?.forEach((postElement) {
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
  RecentModel _addDataToPostList(
      FavouritePlayerResponsePlayerData postElement) {
    // Prepare location name arraylist
    List<String> comaSeparatedLocations =
        (postElement.locations ?? []).isNotEmpty
            ? (postElement.locations ?? [])
                .map((e) => e.locationDetails?.name ?? "")
                .toList()
            : [];

    // Remove empty value from the list.
    comaSeparatedLocations.removeWhere((element) => element.isEmpty);

    // Prepare location name arraylist
    List<String> comaSeparatedPositions =
        (postElement.positions ?? []).isNotEmpty
            ? (postElement.positions ?? [])
                .map((e) => e.positionData?.name ?? "")
                .toList()
            : [];
    // Remove empty value from the list.
    comaSeparatedPositions.removeWhere((element) => element.isEmpty);

    return RecentModel(
      userId: postElement.favouriteUserId,
      playerName: postElement.favouriteUserDetails?.name,
      playerAge: postElement.favouriteUserDetails?.age.toString(),
      playerDescription: postElement.favouriteUserDetails?.bio,
      playerHeight: null,
      playerImage: postElement.favouriteUserDetails?.profileImage,
      playerPhoneNumber: null,
      playerWeight: null,
      totalFollowers: null,
      uuid: null,
      videos: null,
      clubPictures: null,
      isMale:
          (postElement.favouriteUserDetails?.gender ?? "male").toLowerCase() ==
              'male',
      isAdvertisement: false,
      isFromAsset: false,
      isLiked: true,
      playerBio: postElement.favouriteUserDetails?.bio,
      playerEmail: null,
      date: null,
      playerDistance: comaSeparatedLocations.join(', '),
      playerPosition: comaSeparatedPositions.join(', '),
    );
  }

  /// Get user favourite list API.
  void _getUserFavouriteTypeAPI() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showLoading();
      dio.Response? response = await _provider.getPlayerFavouriteList();
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _getFavoriteListSuccessResponse(response);
        } else {
          /// On Error
          _getFavoriteListErrorResponse(response);
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

  /// Perform favorite success response API.
  ///
  /// required [response]
  void _getFavoriteListSuccessResponse(dio.Response response) {
    try {
      FavouriteListResponse model =
          FavouriteListResponse.fromJson(response.data);

      /// set items to the list.
      if (model.status == true) {
        for (FavouriteListResponseData element in (model.data ?? [])) {
          filterOption
              .add(PostFilterModel(title: element.name, itemId: element.id));
        }
      }
    } catch (e) {
      logger.e(e);
      hideLoading();
    }
  }

  /// Perform favorite error response API.
  ///
  /// required [response].
  void _getFavoriteListErrorResponse(dio.Response response) {
    hideLoading();
    hideGlobalLoading();
    GetIt.I<ApiUtils>().parseErrorResponse(response);
  }

  Future<void> onRefresh() async {
    pagingController.refresh();
    filterOption.clear();
    _getUserFavouriteTypeAPI();
  }
}
