import 'package:collection/collection.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../infrastructure/model/advertisement/advertisement_list_model.dart';
import '../../../../../infrastructure/model/club/actiivty_filter_model.dart';
import '../../../../../infrastructure/model/club/post/post_filter_model.dart';
import '../../../../../infrastructure/model/club/post/post_list_model.dart';
import '../../../../../infrastructure/model/club/post/post_model.dart';
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
import '../../../chats/chat_main/controllers/chat_main.controller.dart';
import '../../../club/search_result/controllers/user_filter_menu_controller.dart';
import '../providers/player_home_provider.dart';

class PlayerHomeController extends GetxController with AppLoadingMixin {
  late TextEditingController searchController;
  late FocusNode searchFocusNode;

  RxList<PostModel> recentPosts = RxList();

  RxList<PostModel> filterPost = RxList();

  List<PostFilterModel> filterOptions = RxList();

  /// Store true if user applied search.
  RxBool isSearchApplied = false.obs;

  /// Shows filter option when user applied filter.
  RxBool isFilterApplied = false.obs;

  /// show no data widget.
  bool showNoData = false;

  /// Fetched advertisements.
  List<AdvertisementListModelData> advertisements = [];

  /// Provider class.
  final _provider = PlayerHomeProvider();

  final ScrollController scrollcontroller = new ScrollController();

  final PagingController<int, PostModel> pagingController =
      PagingController(firstPageKey: 0);

  int pageKey = 0;

  bool isLastPage = false;

  /// filter ids.
  List<int> filterIds = [];

  @override
  void onInit() {
    searchController = TextEditingController();
    searchFocusNode = FocusNode();

    getAdvertisements();
    _setupPageListener();
    super.onInit();
  }

  /// Page change listener.
  void _setupPageListener() {
    pagingController.addPageRequestListener((pageKey) {
      getPostAPI(pageKey);
    });
  }

  /// Get user posts API.
  void getPostAPI(int pageKey) async {
    this.pageKey = pageKey;
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showLoading();
      dio.Response? response =
          await _provider.getUserPostAPI(filterIds, pageKey, search: "");
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
      PostListResponse postResponse = PostListResponse.fromJson(response.data!);

      isLastPage = (postResponse.data ?? []).length < AppConstants.pageSize;

      List<PostModel> newItems = [];

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
            newItems.add(PostModel.forAdvertisement(
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

  Future<void> onRefresh() async {
    pageKey = 0;
    pagingController.refresh();
  }

  @override
  void onReady() {
    final ChatMainController controller = Get.find(tag: Routes.CHAT_MAIN);
    controller.getUserThreads();
    super.onReady();
  }

  /// Open link in platform specific browser.
  void openLinkInPlatformBrowser(String link) {
    CommonUtils.openLinkInBrowser(link);
  }

  /// on delete post.
  void onDeletePost(PostModel postModel, int index) {}

  /// On edit post
  void onEditPost(PostModel postModel, int index) {}

  /// On Club click
  void onClubClick(PostModel postModel, int index) {
    /// Navigate to club detail screen.
    Get.toNamed(Routes.CLUB_DETAIL, arguments: {
      RouteArguments.userId: postModel.clubId.toString(),
      RouteArguments.listItemIndex: index
    });
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

  /// Add selected filter list.
  void addSelectedFilter(List<ClubActivityFilter> tempList) {
    final isFilterSelected = tempList.firstWhereOrNull((element) {
      final result = element.filterSubItems
          .firstWhereOrNull((childElement) => childElement.isSelected);
      return result == null ? false : result.isSelected;
    });
    isFilterApplied.value = isFilterSelected != null;
    Get.back();

    List<String> appliedLocations = [];
    List<String> appliedSports = [];
    List<String> appliedLevels = [];

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
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Get.toNamed(Routes.PLAYER_SEARCH_RESULT, arguments: {
        RouteArguments.searchValue: '',
        RouteArguments.filterApplied: isFilterApplied.isTrue,
        RouteArguments.filterSport: appliedSports,
        RouteArguments.filterLocation: appliedLocations,
        RouteArguments.filterLevel: appliedLevels,
      });
    });
  }

  /// Perform login api success
  void _deletePostSuccess(dio.Response response) {
    hideGlobalLoading();
  }

  /// Perform api error.
  void _deletePostError(dio.Response response) {
    hideGlobalLoading();
    pagingController.error = response.statusMessage??"";
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }

  /// On search click
  void onSearchClick() {
    Get.toNamed(Routes.PLAYER_CLUB_SEARCH);
  }

  /// clear search field.
  void clearSearch() {
    searchController.clear();
    isSearchApplied.value = false;
    filterPost.clear();
    searchFocusNode.unfocus();
    pageKey = 0;
    pagingController.refresh();
  }

  /// Search field.
  void searchForClub(String newValue) {
    showLoading();
    Future.delayed(const Duration(seconds: 1), () {
      hideLoading();
      if (newValue.isEmpty) {
        filterPost.clear();
        isSearchApplied.value = false;
        searchFocusNode.unfocus();
      } else {
        isSearchApplied.value = true;
        filterPost.clear();
        for (var post in recentPosts) {
          if ((post.postDescription ?? "").contains(newValue) ||
              (post.clubName ?? "").contains(newValue)) {
            filterPost.add(post);
          }
        }
      }
    });
  }

  /// On post share.
  void onPostShare(PostModel postModel) {
    CommonUtils.sharePostToOtherApps(postModel);
  }

  /// Verify data then navigate to filter screen.
  void navigateToFilterScreen() async {
    UserFilterMenuController controller =
        Get.find(tag: Routes.CLUB_PLAYER_FILTER);
    controller.navigateToFilterScreen(addSelectedFilter, clearFilters: true);
  }

  /// Add data to list.
  ///
  /// required [PostListResponseData].
  PostModel _addDataToPostList(PostListResponseData postElement) {
    switch (postElement.postTypeId) {
      case AppConstants.postTypeIdResult:
        // Prepare result model.
        return GetIt.I<CommonUtils>().getPostModelForResult(postElement);

      case AppConstants.postTypeIdEvent:
        // Prepare event model.
        return GetIt.I<CommonUtils>().getPostModelForEvent(postElement);

      case AppConstants.postTypeIdOpenPosition:
        // Prepare open position model.
        return GetIt.I<CommonUtils>().getPostModelForOpenPosition(postElement);

      default:
        if ((postElement.allPostImages ?? "").isNotEmpty) {
          List<String> allPostImageArray =
              (postElement.allPostImages ?? "").split(',');
          List<PostImages> postImages = [];
          for (var element in allPostImageArray) {
            postImages.add(PostImages(isUrl: true, image: element));
          }
          postElement.postImages = postImages;
        }

        // Prepare post model.
        return GetIt.I<CommonUtils>().getPostModelForPost(postElement);
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

  /// Perform api error.
  void _getAPIError(dio.Response response) {
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }
}

enum PostViewType { event, openPosition, post, result, adv, loading }
