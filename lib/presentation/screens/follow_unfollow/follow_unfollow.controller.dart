import 'package:dio/dio.dart' as dio;
import 'package:game_on_flutter/presentation/app_widgets/app_loading_mixin.dart';
import 'package:game_on_flutter/presentation/screens/follow_unfollow/provider/follow_unfollow.provider.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../infrastructure/network/api_utils.dart';
import '../../../infrastructure/network/network_config.dart';
import '../../../infrastructure/network/network_connectivity.dart';
import '../../../values/common_utils.dart';

class FollowUnfollowController extends GetxController with AppLoadingMixin {
  /// Provider
  final FollowUnfollowProvider _provider = FollowUnfollowProvider();

  /// Follow/Unfollow user API
  Future<bool> followUnfollowUser(String userId) async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showGlobalLoading();
      dio.Response? response =
          await _provider.followUnfollowUser(userId: userId);
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
