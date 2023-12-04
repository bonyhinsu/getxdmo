import 'package:dio/dio.dart' as dio;
import 'package:game_on_flutter/infrastructure/model/club/home/club_list_model.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:group_button/group_button.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';

import '../../../../../infrastructure/model/club/post/post_filter_model.dart';
import '../../../../../infrastructure/model/favourite/favourite_list_response.dart';
import '../../../../../infrastructure/model/player/favourite/favourite_type_model.dart';
import '../../../../../infrastructure/model/player/favourite/player_favourite_club_list_response.dart';
import '../../../../../infrastructure/navigation/route_config.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../infrastructure/network/api_utils.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../infrastructure/storage/preference_manager.dart';
import '../../../../../values/app_colors.dart';
import '../../../../../values/app_constant.dart';
import '../../../../../values/common_utils.dart';
import '../../../../app_widgets/app_loading_mixin.dart';
import '../../../club/club_favorite/favorite_bottomsheet_controller.dart';
import '../../../club/club_favorite/favorite_filter_post_bottomsheet.dart';
import '../provider/player_favourite.provider.dart';

class PlayerClubFavouriteController extends GetxController
    with AppLoadingMixin {
  /// Favourite user list.
  RxList<ClubListModel> favouriteUsers = RxList();

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

  /// filter menu item list.
  RxList<PostFilterModel> filterMenuList = RxList();

  /// Button selection controller
  GroupButtonController groupButtonController = GroupButtonController();

  final _provider = PlayerFavouriteProvider();

  /// Paging controller
  final PagingController<int, ClubListModel> pagingController =
      PagingController(firstPageKey: 0);

  final logger = Logger();

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
      _getFavouriteAPI(pageKey);
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
    Get.toNamed(Routes.PLAYER_CLUB_SEARCH);
  }

  /// on select delete item
  void onDeleteFilter(int index) {
    onTapButton(index, false);
    appliedFilter.removeAt(index);
    filterOnClear();
    isFilterApplied.value = appliedFilter.isNotEmpty;
    pagingController.refresh();
  }

  /// on selection click
  void onSelection(int childIndex, bool isSelected) {}

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
    }

    filterOption = tempList;
    pagingController.refresh();
  }

  /// apply filter on click on the list
  void filterOnClear() {
    final tempList = filterOption;
    isFilterApplied.value = tempList.isNotEmpty;

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
    }

    filterOption = tempList;
    showLoading();
    Future.delayed(const Duration(seconds: 1), () {
      hideLoading();
    });
  }

  void changeFavouriteStatus(int index) {}

  /// On like changed.
  ///
  /// require[index]
  /// require[postModel]
  void onLikeChange(int index, ClubListModel postModel) {
    Get.toNamed(Routes.PLAYER_FAVOURITE_SELECTION, arguments: {
      RouteArguments.userId: postModel.id.toString(),
      RouteArguments.alreadyLiked: postModel.isLiked
    })?.then((value) {
      if (value != null) {
        favouriteUsers[index].favouriteList = value as List<FavouriteTypeModel>;

        final checkForSelectedElement =
            value.indexWhere((element) => element.isSelected == true);

        favouriteUsers[index].isLiked = checkForSelectedElement != -1;
        favouriteUsers.refresh();
      }
    });
  }

  /// Navigate to player detail screen.
  ///
  /// require[ClubListModel] as postModel.
  /// require[index]
  void playerDetailScreen(ClubListModel postModel, int index) {
    Get.toNamed(Routes.CLUB_DETAIL,
        arguments: {RouteArguments.userId: postModel.id.toString()});
  }

  /// Update player to favourite list.
  ///
  /// required [filterList]  as List<FavouriteTypeModel>
  /// required [index]  as int
  void updatePlayerToFavourite(List<FavouriteTypeModel> filterList, int index) {
    favouriteUsers[index].favouriteList = filterList;

    final checkForSelectedElement =
        filterList.indexWhere((element) => element.isSelected == true);

    favouriteUsers[index].isLiked = checkForSelectedElement != -1;
    favouriteUsers.refresh();
  }

  /// Get user favourite club API.
  void _getFavouriteAPI(int pageKey) async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showLoading();
      List<int> appliedFilterIds =
          appliedFilter.map((element) => element.itemId ?? -1).toList();
      dio.Response? response =
          await _provider.getUserPostAPI(appliedFilterIds, pageKey, search: '');
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _getFavouriteClubSuccess(response, pageKey);
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

  /// Perform api error.
  void _getAPIError(dio.Response response) {
    hideLoading();
    pagingController.error = response.statusMessage;
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }

  /// Perform login api success
  void _getFavouriteClubSuccess(dio.Response response, int pageKey) {
    try {
      PlayerFavouriteClubListResponse playerFavouriteClubListResponse =
          PlayerFavouriteClubListResponse.fromJson(response.data!);
      bool isLastPage = (playerFavouriteClubListResponse.data ?? []).length <
          AppConstants.pageSize;
      List<ClubListModel> newItems = [];
      playerFavouriteClubListResponse.data?.forEach((postElement) {
        newItems.add(_getClubFavouriteModel(postElement));
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

  /// Perform favorite error response API.
  ///
  /// required [response].
  void _getFavoriteListErrorResponse(dio.Response response) {
    hideLoading();
    hideGlobalLoading();
    GetIt.I<ApiUtils>().parseErrorResponse(response);
  }

  /// Refresh data.
  Future<void> refreshData() async {
    pagingController.refresh();
    refreshFavouritesTypes();
  }

  /// Returns [ClubListModel] from [PlayerFavouriteClubListResponseData].
  ClubListModel _getClubFavouriteModel(
      PlayerFavouriteClubListResponseData responseData) {
    final commaSeparatedLocations = _getCommaSeparatedLocations(responseData);
    final commaSeparatedLevels = _getCommaSeparatedLevels(responseData);
    final commaSeparatedSports = _getCommaSeparatedSports(responseData);
    final commaSeparatedGender = _getCommaSeparatedGenders(responseData);
    final sportLogo = responseData.sports?.first.sportTypeDetails?.logo;
    return ClubListModel(
      clubLogo: responseData.favouriteUserDetails?.profileImage,
      clubName: responseData.favouriteUserDetails?.name,
      level: commaSeparatedLevels,
      location: commaSeparatedLocations,
      sports: commaSeparatedSports,
      sportLogo: sportLogo,
      isLiked: true,
      position: commaSeparatedGender,
      id: responseData.favouriteUserId,
    );
  }

  /// Return string with coma separated locations.
  ///
  /// required [UserDetailResponseModel].
  String _getCommaSeparatedLocations(
      PlayerFavouriteClubListResponseData userDetailResponseModel) {
    // Prepare location name arraylist
    List<String?> comaSeparatedLocations =
        (userDetailResponseModel.locations ?? []).isNotEmpty
            ? (userDetailResponseModel.locations ?? []).map((sportElement) {
                return sportElement.locationDetails?.name;
              }).toList()
            : [];

    // Remove empty value from the list.
    comaSeparatedLocations.removeWhere((element) => (element ?? "").isEmpty);

    return comaSeparatedLocations.join(', ');
  }

  /// Return string with coma separated locations.
  ///
  /// required [UserDetailResponseModel].
  String _getCommaSeparatedLevels(
      PlayerFavouriteClubListResponseData userDetailResponseModel) {
    // Prepare location name arraylist
    List<String?> comaSeparatedLocations =
        (userDetailResponseModel.levels ?? []).isNotEmpty
            ? (userDetailResponseModel.levels ?? []).map((sportElement) {
                return sportElement.levelDetails?.name;
              }).toList()
            : [];

    // Remove empty value from the list.
    comaSeparatedLocations.removeWhere((element) => (element ?? "").isEmpty);

    return comaSeparatedLocations.join(', ');
  }

  /// Return string with coma separated locations.
  ///
  /// required [UserDetailResponseModel].
  String _getCommaSeparatedSports(
      PlayerFavouriteClubListResponseData userDetailResponseModel) {
    // Prepare sport name arraylist
    List<String?> comaSeparatedSports = (userDetailResponseModel.sports ?? [])
            .isNotEmpty
        ? (userDetailResponseModel.sports ?? [])
            .map((sportElement) => sportElement.sportTypeDetails?.name ?? "")
            .toList()
        : [];

    // Remove empty value from the list.
    comaSeparatedSports.removeWhere((element) => (element ?? "").isEmpty);

    return comaSeparatedSports.join(', ');
  }

  /// Return string with coma separated locations.
  ///
  /// required [UserDetailResponseModel].
  String _getCommaSeparatedGenders(
      PlayerFavouriteClubListResponseData userDetailResponseModel) {
    // Prepare sport name arraylist
    List<String?> comaSeparatedSports =
        (userDetailResponseModel.genders ?? []).isNotEmpty
            ? (userDetailResponseModel.genders ?? [])
                .map((sportElement) => sportElement.genderDetails?.name ?? "")
                .toList()
            : [];

    // Remove empty value from the list.
    comaSeparatedSports.removeWhere((element) => (element ?? "").isEmpty);

    return comaSeparatedSports.join(', ');
  }

  /// Refresh favourites.
  void refreshFavouritesTypes() {
    _getUserFavouriteTypeAPI();
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
        filterOption.clear();
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
}
