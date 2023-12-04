import 'package:dio/dio.dart' as dio;
import 'package:flutter/scheduler.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_loading_mixin.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';

import '../../../../../infrastructure/model/club/home/club_list_model.dart';
import '../../../../../infrastructure/model/common/block_unblock_response.dart';
import '../../../../../infrastructure/network/api_utils.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../values/app_constant.dart';
import '../../../../../values/common_utils.dart';
import '../../../../app_widgets/app_dialog_widget.dart';
import '../../../block_unblock/controller/block_unblock.controller.dart';
import '../provider/blocked_users.provider.dart';

class BlockedUsersController extends GetxController with AppLoadingMixin {
  /// Provider
  final BlockedUsersProvider _provider = BlockedUsersProvider();

  /// Paging controller
  final PagingController<int, BlockUnblockUserResponseData> pagingController =
      PagingController(firstPageKey: 0);

  final logger = Logger();

  @override
  void onInit() {
    _setupPageListener();
    super.onInit();
  }

  /// Page change listener.
  void _setupPageListener() {
    pagingController.addPageRequestListener((pageKey) {
      getBlockedUsers(pageKey);
    });
  }

  /// Get blocked users
  Future<bool> getBlockedUsers(int page) async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showGlobalLoading();
      dio.Response? response =
          await _provider.getBlockedUserList( pageKey: page);
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _getPostSuccess(response, page);
          return true;
        } else {
          /// On Error
          hideGlobalLoading();
          GetIt.instance<ApiUtils>().parseErrorResponse(response);
          return false;
        }
      } else {
        hideGlobalLoading();
        GetIt.I<CommonUtils>().showServerDownError();
        return false;
      }
    } else {
      hideGlobalLoading();
      GetIt.I<CommonUtils>().showNetworkError();
      return false;
    }
  }

  /// Perform login api success
  void _getPostSuccess(dio.Response response, int pageKey) {
    hideGlobalLoading();
    try {
      BlockUnblockUserResponse postResponse =
      BlockUnblockUserResponse.fromJson(response.data!);
      bool isLastPage =
          (postResponse.data ?? []).length < AppConstants.pageSize;

      if (isLastPage) {
        pagingController.appendLastPage(postResponse.data!);
      } else {
        final nextPageKey = pageKey + AppConstants.pageSize;
        pagingController.appendPage(postResponse.data!, nextPageKey);
      }
    } catch (e) {
      logger.e(e);
    }
    hideLoading();
  }

  void onUnblockUser(String userId, String userName){
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Get.dialog(AppDialogWidget(
          dialogText: "Are you sure you want to block $userName?",
          onDone: () {
            _onUnblock(userId);
          }));
    });
  }
  void _onUnblock(String userId){
    BlockUnblockController blockUnblockController = Get.find();
    blockUnblockController.blockUnblockUser(userId).then((value) {
     pagingController.refresh();
    });
  }
}
