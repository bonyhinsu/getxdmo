import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../infrastructure/network/api_utils.dart';
import '../../../../infrastructure/network/network_config.dart';
import '../../../../infrastructure/network/network_connectivity.dart';
import '../../../../values/common_utils.dart';
import '../../../app_widgets/app_loading_mixin.dart';
import '../provider/report_app_user_provider.dart';

class ReportAppUserController extends GetxController with AppLoadingMixin {
  /// Provider
  final ReportAppUserProvider _provider = ReportAppUserProvider();

  /// Block user API
  Future<bool> reportUser(
      String userId, int reportId, String reportDescription) async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showGlobalLoading();
      dio.Response? response = await _provider.reportAppUser(
          reportUserId: userId,
          reportId: reportId,
          reportDescription: reportDescription);
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          hideGlobalLoading();
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
}
