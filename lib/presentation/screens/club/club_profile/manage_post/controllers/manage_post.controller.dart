import 'dart:async';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_loading_mixin.dart';
import 'package:game_on_flutter/presentation/screens/club/club_profile/manage_post/controllers/post_filter_controller.dart';
import 'package:game_on_flutter/values/app_constant.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';

import '../../../../../../infrastructure/model/club/actiivty_filter_model.dart';
import '../../../../../../infrastructure/model/club/post/post_list_model.dart';
import '../../../../../../infrastructure/model/club/post/post_model.dart';
import '../../../../../../infrastructure/navigation/route_config.dart';
import '../../../../../../infrastructure/navigation/routes.dart';
import '../../../../../../infrastructure/network/api_utils.dart';
import '../../../../../../infrastructure/network/network_config.dart';
import '../../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../../values/app_colors.dart';
import '../../../../../../values/app_string.dart';
import '../../../../../../values/app_values.dart';
import '../../../../../../values/common_utils.dart';
import '../../../../../app_widgets/app_dialog_with_title_widget.dart';
import '../../../../player/player_home/controllers/player_home.controller.dart';
import '../provider/manage_post_provider.dart';
import '../view/filter_post_bottomsheet.dart';

class ManagePostController extends GetxController with AppLoadingMixin {
  final PagingController<int, PostModel> pagingController =
      PagingController(firstPageKey: 0);

  late TextEditingController searchController;
  late FocusNode searchFocusNode;

  RxList<PostModel> recentPosts = RxList();

  RxList<PostModel> filterPost = RxList();

  /// filter option list.
  List<FilterItem> filterOptions = RxList();

  /// Store true if user applied search
  RxBool isSearchApplied = false.obs;

  /// Shows filter option when user applied filter.
  RxBool isFilterApplied = false.obs;

  /// bool to handle no data.
  bool showNoData = false;

  /// Logger
  final logger = Logger();

  /// provider
  final _provider = ManagePostProvider();

  /// search value
  String searchText = '';

  /// filter ids.
  List<int> filterIds = [];

  Timer? searchOnStoppedTyping;

  @override
  void onInit() {
    searchController = TextEditingController();
    searchFocusNode = FocusNode();
    _addPostFilterOptions();
    _setupPageListener();
    super.onInit();
  }

  /// Page change listener.
  void _setupPageListener() {
    pagingController.addPageRequestListener((pageKey) {
      _getPostAPI(pageKey);
    });
  }

  /// Add post filter post filter options
  void _addPostFilterOptions() {
    filterOptions.add(FilterItem(
        title: AppString.strEvent, itemId: AppConstants.postTypeIdEvent));
    filterOptions.add(FilterItem(
        title: AppString.strResult, itemId: AppConstants.postTypeIdResult));
    filterOptions.add(FilterItem(
        title: AppString.strPost, itemId: AppConstants.postTypeIdPost));
    filterOptions.add(FilterItem(
        title: AppString.strOpenPositions,
        itemId: AppConstants.postTypeIdOpenPosition));
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
    searchOnStoppedTyping = Timer(duration, () => searchForClub(value));
  }

  /// Apply filter option.
  void onApplyFilterOption(List<FilterItem> updatedFilterList) {
    final selectedFilterList =
        updatedFilterList.where((e) => e.isSelected).toList();
    filterIds = selectedFilterList.map((e) => e.itemId).toList();
    isFilterApplied.value = filterIds.isNotEmpty;
    pagingController.refresh();
  }

  /// On post click
  void onPostClick(PostModel postModel) {
    switch (postModel.viewType) {
      case PostViewType.openPosition:

        /// Navigate to position detail screen.
        Get.toNamed(Routes.OPEN_POSITION_DETAIL,
            arguments: {RouteArguments.itemId: postModel.index});
        return;

      case PostViewType.event:

        /// Navigate to event detail screen.
        Get.toNamed(Routes.EVENT_DETAIL,
            arguments: {RouteArguments.itemId: postModel.index});
        return;

      case PostViewType.result:

        /// Navigate to result detail screen.
        Get.toNamed(Routes.RESULT_DETAIL,
            arguments: {RouteArguments.itemId: postModel.index});
        return;
      default:

        /// Navigate to post detail screen.
        Get.toNamed(Routes.POST_DETAIL,
            arguments: {RouteArguments.itemId: postModel.index});
    }
  }

  /// Delete post confirmation dialog.
  void onDeletePost(PostModel postModel, int index) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      switch (postModel.viewType) {
        case PostViewType.openPosition:
          _deleteConfirmationDialog(
              type: AppString.strOpenPosition,
              postId: postModel.index ?? 0,
              index: index);
          return;

        case PostViewType.event:
          _deleteConfirmationDialog(
              type: AppString.strEvent,
              postId: postModel.index ?? 0,
              index: index);
          return;

        case PostViewType.result:
          _deleteConfirmationDialog(
              type: AppString.strResult,
              postId: postModel.index ?? 0,
              index: index);
          return;
        default:
          _deleteConfirmationDialog(
              type: AppString.post, postId: postModel.index ?? 0, index: index);
      }
    });
  }

  /// On Edit post.
  void onEditPost(PostModel postModel, int index) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      switch (postModel.viewType) {
        case PostViewType.openPosition:

          /// Navigate to position detail screen.
          Get.toNamed(Routes.ADD_OPEN_POSITION, arguments: {
            RouteArguments.postDetail: postModel,
            RouteArguments.listItemIndex: index,
            RouteArguments.itemId: postModel.index.toString()
          });
          return;

        case PostViewType.event:

          /// Navigate to event detail screen.
          Get.toNamed(Routes.ADD_EVENT, arguments: {
            RouteArguments.postDetail: postModel,
            RouteArguments.listItemIndex: index,
            RouteArguments.itemId: postModel.index.toString()
          });
          return;

        case PostViewType.result:

          /// Navigate to result detail screen.
          Get.toNamed(Routes.ADD_RESULT, arguments: {
            RouteArguments.postDetail: postModel,
            RouteArguments.listItemIndex: index,
            RouteArguments.itemId: postModel.index.toString()
          });
          return;
        default:

          /// Navigate to post detail screen.
          Get.toNamed(Routes.ADD_POST, arguments: {
            RouteArguments.postDetail: postModel,
            RouteArguments.listItemIndex: index,
            RouteArguments.itemId: postModel.index.toString()
          });
      }
    });
  }

  /// Update item to list.
  void updateItemToList(int index, PostModel postModel) {
    pagingController.refresh();
  }

  /// Delete confirmation dialog.
  void _deleteConfirmationDialog(
      {required String type, required int postId, required int index}) {
    Get.dialog(AppDialogWithTitleWidget(
      onDone: () => _deletePostAPI(index),
      dialogText: "Are you sure you want to delete this ${type.toLowerCase()}?",
      dialogTitle: 'Delete $type?',
    ));
  }

  /// remove post at index.
  void removePostAtIndex(int index) {
    pagingController.refresh();
  }

  /// on filter list.
  void onFilter() {
    Get.lazyPut<PostFilterController>(() => PostFilterController(),
        tag: Routes.POST_FILTER_BOTTOMSHEET);
    Get.bottomSheet(
            FilterPostBottomSheet(
              filterMenuList: filterOptions,
              onApplyFilter: onApplyFilterOption,
            ),
            barrierColor: AppColors.bottomSheetBgBlurColor,
            isScrollControlled: true)
        .then((value) => Get.delete<PostFilterController>(
            tag: Routes.POST_FILTER_BOTTOMSHEET, force: true));
  }

  /// delete post api
  void _deletePostAPI(int index) async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showGlobalLoading();
      dio.Response? response = await _provider.deletePostAPI(
          postId: (pagingController.itemList?[index].index ?? -1).toString());
      if (response.statusCode == NetworkConstants.deleteSuccess) {
        /// On success
        _deletePostSuccess(response, index);
      } else {
        /// On Error
        _deletePostError(response);
      }
    } else {
      hideGlobalLoading();
      GetIt.I<CommonUtils>().showNetworkError();
    }
  }

  /// Get user posts API.
  void _getPostAPI(int pageKey) async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showLoading();
      dio.Response? response = await _provider
          .getUserPostAPI(filterIds, pageKey, search: searchText);
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

  /// Get post type API.
  void getPostTypeAPI() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      dio.Response? response = await _provider.getUserPostTypeAPI();
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _getPostTypeAPISuccess(response);
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

  /// Perform post type api success
  void _getPostTypeAPISuccess(dio.Response response) {
    // filterOptions.add();
  }

  /// Perform login api success
  void _deletePostSuccess(dio.Response response, int index) {
    hideGlobalLoading();
    removePostAtIndex(index);
  }

  /// Perform login api success
  void _getPostSuccess(dio.Response response, int pageKey) {
    try {
      PostListResponse postResponse = PostListResponse.fromJson(response.data!);
      bool isLastPage =
          (postResponse.data ?? []).length < AppConstants.pageSize;
      List<PostModel> newItems = [];
      postResponse.data?.forEach((postElement) {
        newItems.add(_addDataToPostList(postElement));
      });
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + AppConstants.pageSize;
        pagingController.appendPage(newItems, nextPageKey);
      }
      postResponse.data?.forEach((postElement) {
        _addDataToPostList(postElement);
      });
    } catch (e) {
      logger.e(e);
    }
    hideLoading();
  }

  /// Add data to list.
  ///
  /// required [PostListResponseData].
  PostModel _addDataToPostList(PostListResponseData postElement) {
    switch (postElement.postTypeId) {
      case AppConstants.postTypeIdResult:
        // Prepare result model.
        return GetIt.I<CommonUtils>().getPostModelForResult(postElement);
        break;
      case AppConstants.postTypeIdEvent:
        // Prepare event model.
        return GetIt.I<CommonUtils>().getPostModelForEvent(postElement);

      case AppConstants.postTypeIdOpenPosition:
        // Prepare open position model.
        return GetIt.I<CommonUtils>().getPostModelForOpenPosition(postElement);

      default:
        // Prepare post model.
        return GetIt.I<CommonUtils>().getPostModelForPost(postElement);
    }
  }

  /// Perform api error.
  void _deletePostError(dio.Response response) {
    hideGlobalLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }

  void clearSearch() {
    searchController.clear();
    isSearchApplied.value = false;
    searchFocusNode.unfocus();
    searchText = '';
    refreshScreen();
  }

  /// Search field
  void searchForClub(String newValue) {
    searchText = newValue;
    isSearchApplied.value = newValue.isNotEmpty;
    refreshScreen();
  }

  /// Refresh screen.
  Future<void> refreshScreen() async {
    pagingController.refresh();
  }
}
