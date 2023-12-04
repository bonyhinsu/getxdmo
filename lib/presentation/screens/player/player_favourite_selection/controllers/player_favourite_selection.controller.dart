import 'package:dio/dio.dart' as dio;
import 'package:game_on_flutter/infrastructure/navigation/route_config.dart';
import 'package:game_on_flutter/infrastructure/network/api_utils.dart';
import 'package:game_on_flutter/infrastructure/storage/preference_manager.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_loading_mixin.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:group_button/group_button.dart';
import 'package:logger/logger.dart';

import '../../../../../infrastructure/model/club/post/post_filter_model.dart';
import '../../../../../infrastructure/model/favourite/favourite_list_response.dart';
import '../../../../../infrastructure/model/player/favourite/favourite_type_model.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../values/app_colors.dart';
import '../../../../../values/app_string.dart';
import '../../../../../values/common_utils.dart';
import '../../../../app_widgets/app_dialog_widget.dart';
import '../../../club/club_favorite/controllers/club_favorite.controller.dart';
import '../../player_club_favourite/controllers/player_club_favourite.controller.dart';
import '../provider/player_favourite_selection_provider.dart';
import '../view/add_favourite_item_widget.dart';
import 'add_favourite_item_controller.dart';

class PlayerFavouriteSelectionController extends GetxController
    with AppLoadingMixin {
  // Rx List.
  RxList<FavouriteTypeModel> favouriteTypeList = RxList();

  /// filter menu item list.
  RxList<PostFilterModel> filterMenuList = RxList();

  /// Button selection controller
  GroupButtonController groupButtonController = GroupButtonController();

  /// Menu filter list.
  RxList<PostFilterModel> filterOption = RxList();

  /// User applied filter list
  RxList<PostFilterModel> appliedFilter = RxList();

  /// store true if filter is applied otherwise false.
  RxBool isFilterApplied = false.obs;

  /// Provider
  final _provider = PlayerFavouriteSelectionProvider();

  /// Logger
  final logger = Logger();

  /// True if user already added record to his created list.
  bool isAlreadyLiked = false;

  RxBool validField = false.obs;

  /// Selected user id to be liked
  String userIdToLike = '';

  @override
  void onInit() {
    _getArguments();
    super.onInit();
  }

  /// Receive arguments from previous screen.
  void _getArguments() {
    if (Get.arguments != null) {
      userIdToLike = Get.arguments[RouteArguments.userId] ?? "";
      isAlreadyLiked = Get.arguments[RouteArguments.alreadyLiked] ?? false;
    }
    _getUserCreatedList();
  }

  void _getUserCreatedList() {
    if (favouriteTypeList.isEmpty) {
      _getUserFavouriteTypeAPI();
    }
  }

  /// on delete item click.
  void deleteFavouriteItem(FavouriteTypeModel model, int index) {
    deleteConfirmationDialog(onDelete: () {
      _deleteUserFavouriteTypeAPI(deleteItemId: model.itemId, index: index);
    });
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
      groupButtonController.selectIndexes(arrSelectedIndex);
    }

    filterOption = tempList;
    showLoading();
    Future.delayed(const Duration(seconds: 1), () {
      hideLoading();
    });
  }

  /// on edit item click.
  void editFavouriteItem(FavouriteTypeModel model, int index) {
    openAddFilterBottomSheet(
        editField: true, index: index, updateItemId: model.itemId);
  }

  /// Delete confirmation dialog.
  void deleteConfirmationDialog({required Function() onDelete}) {
    Get.dialog(AppDialogWidget(
      onDone: onDelete,
      dialogText: AppString.deletePlayerFavouriteConfirmation,
    ));
  }

  /// Set selected items.
  void setSelectedItems(FavouriteTypeModel model, int index) {
    final selected = favouriteTypeList[index].isSelected;
    favouriteTypeList[index].isSelected = !selected;
    favouriteTypeList.refresh();
    validField.value = true;
  }

  /// Add Favourite item to the list.
  void _addNewlyCreatedItem(Map<String, dynamic> categoryName) {
    favouriteTypeList.add(
      FavouriteTypeModel(
          title: categoryName['value'],
          isSelected: false,
          itemId: categoryName['id']),
    );
  }

  /// Update favourite item.
  ///
  /// required [categoryName].
  /// required [index].
  void _updateFavouriteItem(Map<String, dynamic> categoryName, int index) {
    favouriteTypeList[index] = FavouriteTypeModel(
        title: categoryName['value'],
        isSelected: favouriteTypeList[index].isSelected,
        itemId: favouriteTypeList[index].itemId);
    favouriteTypeList.refresh();
  }

  /// Return [FavouriteTypeModel] from [FavouriteListResponseData].
  ///
  /// required [favouriteListResponseData].
  FavouriteTypeModel _getFavouriteTypeModel(
      FavouriteListResponseData favouriteListResponseData, bool selected) {
    return FavouriteTypeModel(
        title: favouriteListResponseData.name ?? "",
        isSelected: selected,
        itemId: favouriteListResponseData.id ?? -1);
  }

  /// Add/Edit filter bottomsheet.
  void openAddFilterBottomSheet(
      {bool editField = false, int index = -1, int updateItemId = -1}) {
    Get.lazyPut<AddFavouriteItemController>(() => AddFavouriteItemController(),
        tag: Routes.ADD_PLAYER_FAVOURITE_BOTTOMSHEET);

    Get.bottomSheet(
            AddFavouriteItemWidget(
              existingItem: editField ? favouriteTypeList[index].title : null,
              isEdit: editField,
              itemId: updateItemId,
            ),
            barrierColor: AppColors.bottomSheetBgBlurColor,
            isScrollControlled: true)
        .then((value) {
      if (value != null) {
        if (!editField) {
          _addNewlyCreatedItem(value);
        } else {
          _updateFavouriteItem(value, index);
        }
      }
      Get.delete<AddFavouriteItemController>(
          tag: Routes.ADD_PLAYER_FAVOURITE_BOTTOMSHEET, force: true);
    });
  }

  /// on submit.
  void onSubmit() {
    _addUserFavouriteTypeAPI();
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
      if (!isAlreadyLiked) {
        hideLoading();
      }

      FavouriteListResponse model =
          FavouriteListResponse.fromJson(response.data);

      /// set items to the list.
      if (model.status == true) {
        if (isAlreadyLiked) {
          _getSelectedUserFavouriteTypeAPI((model.data ?? []));
        } else {
          for (var element in (model.data ?? [])) {
            favouriteTypeList.add(_getFavouriteTypeModel(element, false));
          }
        }
      }
    } catch (e) {
      logger.e(e);
      hideLoading();
    }
  }

  /// Perform favorite success response API.
  ///
  /// required [response]
  /// required [index].
  void _deleteFavoriteListSuccessResponse(dio.Response response, int index) {
    try {
      hideGlobalLoading();
      favouriteTypeList.removeAt(index);
    } catch (e) {
      logger.e(e);
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

  /// Delete user favourite list API.
  ///
  /// required [deleteItemId].
  /// required [index].
  void _deleteUserFavouriteTypeAPI({
    required int deleteItemId,
    required int index,
  }) async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showGlobalLoading();
      dio.Response? response = await _provider.deletePlayerFavouriteList(
          id: deleteItemId.toString());

      if (response.statusCode == NetworkConstants.deleteSuccess) {
        /// On success
        _deleteFavoriteListSuccessResponse(response, index);
      } else {
        /// On Error
        _getFavoriteListErrorResponse(response);
      }
    } else {
      hideGlobalLoading();
      GetIt.I<CommonUtils>().showNetworkError();
    }
  }

  /// Refresh screen.
  Future<void> refreshScreen() async {
    favouriteTypeList.clear();
    _getUserFavouriteTypeAPI();
  }

  /// Add user to favourite list.
  ///
  /// required [deleteItemId].
  /// required [index].
  void _addUserFavouriteTypeAPI() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showGlobalLoading();

      /// Selected items
      final selectedItems = favouriteTypeList.where((p0) => p0.isSelected);

      /// Selected item ids.
      final selectedItemIds =
          selectedItems.map((element) => element.itemId).toList();

      dio.Response? response = await _provider.addUserToFavourite(
          favouriteUserId: userIdToLike, selectedList: selectedItemIds);
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.created) {
          /// On success
          _addUserFavouriteSuccess(response);
        } else {
          /// On Error
          _addUserFavouriteError(response);
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

  /// Add user favourite response success
  ///
  /// required [response]
  void _addUserFavouriteSuccess(dio.Response response) {
    if (GetIt.I<PreferenceManager>().isClub) {
      ClubFavoriteController clubFavourites =
          Get.find(tag: Routes.CLUB_FAVORITE);
      clubFavourites.onRefresh();
    } else {
      PlayerClubFavouriteController playerAdvertisement =
          Get.find(tag: Routes.PLAYER_FAVOURITE_CLUB);
      playerAdvertisement.refreshData();
    }
    hideGlobalLoading();
    Get.back(result: favouriteTypeList.value);
  }

  /// Perform favorite error response API.
  ///
  /// required [response].
  void _addUserFavouriteError(dio.Response response) {
    hideGlobalLoading();
    GetIt.I<ApiUtils>().parseErrorResponse(response);
  }

  /// Get user selected favourite list API.
  void _getSelectedUserFavouriteTypeAPI(
      List<FavouriteListResponseData> listResponse) async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showLoading();
      dio.Response? response =
          await _provider.getPlayerSelectedFavouriteList(userId: userIdToLike);
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _getSelectedListSuccessResponse(response, listResponse);
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

  /// Perform user selected favorite success response API.
  ///
  /// required [response]
  void _getSelectedListSuccessResponse(
      dio.Response response, List<FavouriteListResponseData> listResponse) {
    try {
      hideLoading();

      FavouriteListResponse model =
          FavouriteListResponse.fromJson(response.data);

      final selectedItemIds =
          model.data?.map((e) => e.favouriteListId).toList();

      /// set items to the list.
      if (model.status == true) {
        for (var element in listResponse) {
          final isSelected = selectedItemIds?.contains(element.id);
          favouriteTypeList
              .add(_getFavouriteTypeModel(element, isSelected ?? false));
        }
      }
    } catch (e) {
      logger.e(e);
    }
    hideLoading();
  }
}
