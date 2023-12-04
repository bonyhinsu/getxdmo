import 'package:dio/dio.dart' as dio;
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../../infrastructure/model/club/post/post_detail_response_model.dart';
import '../../../../../infrastructure/model/club/post/post_model.dart';
import '../../../../../infrastructure/navigation/route_config.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../infrastructure/network/api_utils.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../infrastructure/storage/preference_manager.dart';
import '../../../../../values/app_string.dart';
import '../../../../../values/common_utils.dart';
import '../../../../app_widgets/app_dialog_with_title_widget.dart';
import '../../../../app_widgets/app_loading_mixin.dart';
import '../../../club/club_profile/manage_post/controllers/manage_post.controller.dart';
import '../../post_detail/provider/post_detail_provider.dart';

class EventDetailController extends GetxController with AppLoadingMixin {
  /// Reference of post model.
  Rx<PostModel> postModel = PostModel.forShimmer('').obs;

  /// index of post which is edit from previous screen.
  int postIndex = -1;

  /// Post id
  int postId = -1;

  /// True if logged in user type is club.
  bool enableEdit = false;

  /// Provider
  final PostDetailProvider _provider = PostDetailProvider();

  @override
  void onInit() {
    enableEdit = GetIt.I<PreferenceManager>().isClub;
    _getArguments();
    super.onInit();
  }

  /// get arguments.
  void _getArguments() {
    if (Get.arguments != null) {
      postId = Get.arguments[RouteArguments.itemId];
      postIndex = Get.arguments[RouteArguments.listItemIndex] ?? -1;

      _getPostDetail();
    }
  }

  /// on back pressed.
  void onBackPressed() {
    Get.back();
  }

  /// share application text to other app.
  void onShare() {
    if (postModel != null) {
      CommonUtils.sharePostToOtherApps(postModel.value);
    }
  }

  /// On Edit post.
  void onEditPost() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      /// Navigate to result detail screen.
      Get.toNamed(Routes.ADD_EVENT, arguments: {
        RouteArguments.postDetail: postModel.value,
        RouteArguments.itemId: postModel.value.index.toString(),
        RouteArguments.listItemIndex: postIndex
      });
    });
  }

  /// Update item to list.
  void updateItemToList(int index, PostModel model) {
    postModel.value = model;
    ManagePostController managePostController =
        Get.find(tag: Routes.MANAGE_POST);
    managePostController.updateItemToList(postIndex, postModel.value);
  }

  /// Delete post confirmation dialog.
  void onDeletePost() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _deleteConfirmationDialog();
    });
  }

  /// Delete confirmation dialog.
  void _deleteConfirmationDialog({String type = AppString.strEvent}) {
    Get.dialog(AppDialogWithTitleWidget(
      cancelButtonText: AppString.cancel,
      doneButtonText: AppString.strDelete,
      onDone: () => _deletePostAPI(postIndex),
      dialogText: "Are you sure you want to delete this ${type.toLowerCase()}?",
      dialogTitle: 'Delete $type?',
    ));
  }

  /// on header click
  void onHeaderClick() {
    /// Navigate to club detail screen.
    Get.toNamed(Routes.CLUB_DETAIL,
        arguments: {RouteArguments.userId: postModel.value.clubId});
  }

  /// remove post at index.
  void removePostAtIndex(int index) {
    ManagePostController managePostController =
        Get.find(tag: Routes.MANAGE_POST);
    managePostController.removePostAtIndex(postIndex);
    Get.until((route) => route.settings.name == Routes.MANAGE_POST);
  }

  /// get post detail API.
  void _getPostDetail() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showLoading();
      dio.Response? response = await _provider.getPostDetail(postId: postId);
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _getPostDetailSuccess(response);
        } else {
          /// On Error
          _getUserDetailError(response);
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

  /// Get user detail api error.
  void _getUserDetailError(dio.Response response) {
    hideLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }

  /// Get user detail success API response
  void _getPostDetailSuccess(dio.Response response) {
    Future.delayed(const Duration(seconds: 1),(){
      hideLoading();
      PostDetailResponseModel userDetailResponseModel =
      PostDetailResponseModel.fromJson(response.data);

      postModel.value = GetIt.I<CommonUtils>()
          .getPostModelForEvent(userDetailResponseModel.data!);
    });

  }

  /// delete post api
  void _deletePostAPI(int index) async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showGlobalLoading();
      dio.Response? response = await _provider.deletePostAPI(
          postId: postModel.value.index.toString());
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

  /// Perform login api success
  void _deletePostSuccess(dio.Response response, int index) {
    hideGlobalLoading();
    removePostAtIndex(index);
  }

  /// Perform api error.
  void _deletePostError(dio.Response response) {
    hideGlobalLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }
}
