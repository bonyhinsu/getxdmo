import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_loading_mixin.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../../infrastructure/model/common/report_user_list_response.dart';
import '../../../../../infrastructure/network/api_utils.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../values/common_utils.dart';
import '../provider/report_user.provider.dart';

class ReportUserController extends GetxController with AppLoadingMixin {
  late TextEditingController reportReason;

  late FocusNode reportFocusNode;

  final ReportUserProvider _provider = ReportUserProvider();

  RxList<ReportUserListResponseData> reportUserList = RxList();

  /// Holds current selected item index
  RxInt selectedIndex = (0).obs;

  /// Custom description
  String customDescription = "";

  @override
  void onInit() {
    reportReason = TextEditingController();
    reportFocusNode = FocusNode();
    _getReportMasterUserData();
    super.onInit();
  }

  /// get report user master data.
  void _getReportMasterUserData() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showLoading();
      dio.Response? response = await _provider.getMasterData();
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _getReportUserMasterDataSuccess(response);
        } else {
          /// On Error
          _getReportUserMasterDataResponseError(response);
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

  /// Get user detail success API response
  void _getReportUserMasterDataSuccess(dio.Response response) {
    hideLoading();
    ReportUserListResponse userDetailResponseModel =
        ReportUserListResponse.fromJson(response.data);

    reportUserList.value = userDetailResponseModel.data ?? [];
    reportUserList
        .add(ReportUserListResponseData(id: -1, name: AppString.other));
    reportUserList.refresh();
  }

  /// Get user detail api error.
  void _getReportUserMasterDataResponseError(dio.Response response) {
    hideLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }

  /// Set description to the local field.
  void setDescription(String value) {
    customDescription = value;
  }

  /// On selection update.
  void onSelectionUpdate(int index) {
    selectedIndex.value = index;

    customDescription = "";
    reportReason.clear();
  }

  /// ON submit report.
  bool validFields() {
    if (selectedIndex.value == -1) {
      if (customDescription.trim().isEmpty) {
        CommonUtils.showErrorSnackBar(
            message: AppString.pleaseWriteYourReasonToReport);
        return false;
      }
    }
    return true;
  }
}
