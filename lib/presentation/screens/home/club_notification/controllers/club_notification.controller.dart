import 'package:dio/dio.dart' as dio;
import 'package:game_on_flutter/infrastructure/model/club/home/notification_model.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../infrastructure/network/api_utils.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../main.dart';
import '../../../../../values/app_constant.dart';
import '../../../../../values/common_utils.dart';
import '../../../../app_widgets/app_loading_mixin.dart';
import '../providers/club_notification_provider.dart';

class ClubNotificationController extends GetxController with AppLoadingMixin {
  RxList<NotificationModel> notificationList = RxList();

  /// Paging controller
  final PagingController<int, NotificationData> pagingController =
      PagingController(firstPageKey: 0);

  /// provider
  final _provider = ClubNotificationProvider();

  List<int> filterIds = [];

  RxBool enableReadAll = false.obs;

  @override
  void onInit() {
    _setupPageListener();
    super.onInit();
  }

  /// Page change listener.
  void _setupPageListener() {
    pagingController.addPageRequestListener((pageKey) {
      _getNotificationAPI(pageKey);
    });
  }

  /// Get Notification API.
  void _getNotificationAPI(int pageKey) async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showLoading();
      dio.Response? response =
          await _provider.getNotificationPostAPI(filterIds, pageKey);
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

  /// readAll notification API.
  void readNotification() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showLoading();
      dio.Response? response = await _provider.readNotification();
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          onSuccessResponse();
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

  /// readAll notification API.
  void readOneNotification(int id, int index) async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showLoading();
      dio.Response? response = await _provider.readOneNotification(id);
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          singleNotificationSuccess(index);
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

  /// Perform Notification api success
  void _getPostSuccess(dio.Response response, int pageKey) {
    try {
      NotificationModel postResponse =
          NotificationModel.fromJson(response.data!);
      bool isLastPage =
          (postResponse.data ?? []).length < AppConstants.pageSize;
      List<NotificationData> newItems = [];
      postResponse.data?.forEach((postElement) {
        newItems.add(_addDataToPostList(postElement));
      });
      if (pageKey == 0) {
        enableReadAll.value = newItems.isNotEmpty;
      }
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
  /// required [NotificationData].
  NotificationData _addDataToPostList(NotificationData notificationElement) {
    return NotificationData(
        fromUserDetails: notificationElement.fromUserDetails,
        description: notificationElement.description,
        id: notificationElement.id,
        fromUserId: notificationElement.fromUserId,
        updatedAt: notificationElement.updatedAt,
        userId: notificationElement.userId,
        createdAt: notificationElement.createdAt,
        isRead: notificationElement.isRead);
  }

  ///read one notification success response
  void onReadChanged(int index, NotificationData postModel) {
    if (postModel.isRead != "y") {
      readOneNotification(postModel.id ?? -1, index);
    }
  }

  /// readAll notification success response
  void onSuccessResponse() {
    Future.delayed(const Duration(milliseconds: 800), () {
      onRefresh();
      hideLoading();
    });
  }

  /// readAll notification success response
  void singleNotificationSuccess(int index) {
    pagingController.itemList![index].isRead = "y";
    pagingController.notifyPageRequestListeners(index);
  }

  /// refresh list of notification
  Future<void> onRefresh() async {
    pagingController.refresh();
  }
}
