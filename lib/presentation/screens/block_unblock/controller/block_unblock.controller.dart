import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../infrastructure/model/common/block_unblock_response.dart';
import '../../../../infrastructure/model/common/block_unblock_user_response.dart';
import '../../../../infrastructure/network/api_utils.dart';
import '../../../../infrastructure/network/network_config.dart';
import '../../../../infrastructure/network/network_connectivity.dart';
import '../../../../values/common_utils.dart';
import '../../../app_widgets/app_loading_mixin.dart';
import '../provider/block_unblock.provider.dart';

class BlockUnblockController extends GetxController with AppLoadingMixin {

  /// Provider
  final BlockUnblockProvider _provider = BlockUnblockProvider();

  /// Block user API
  Future<bool> blockUnblockUser(String userId) async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showGlobalLoading();
      dio.Response? response = await _provider.blockUser(userId: userId);
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.deleteSuccess || response.statusCode == NetworkConstants.success) {
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

  /// get user detail API.
  Future<BlockUserResponseData> getBlockStatus(String userId) async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showLoading();
      dio.Response? response = await _provider.checkForBlockStatus(userId: userId);
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          BlockUserResponse unblockUserResponse = BlockUserResponse.fromJson(response.data!);
          return unblockUserResponse.data!;
        } else {
          /// On Error
          hideLoading();
          GetIt.instance<ApiUtils>().parseErrorResponse(response);
          return BlockUserResponseData(isUserBlockByMe: false, isUserBlockMe: false);
        }
      } else {
        hideLoading();
        GetIt.I<CommonUtils>().showServerDownError();
        return BlockUserResponseData(isUserBlockByMe: false, isUserBlockMe: false);
      }
    } else {
      hideLoading();
      GetIt.I<CommonUtils>().showNetworkError();
      return BlockUserResponseData(isUserBlockByMe: false, isUserBlockMe: false);
    }
  }

}
