import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../presentation/screens/settings/app_setting_provider.dart';
import '../../../values/common_utils.dart';
import '../../model/common/app_fields.dart';
import '../../model/common/app_settings_response_model.dart';
import '../api_utils.dart';
import '../network_config.dart';
import '../network_connectivity.dart';

class AppSettingsService extends GetxController {
  /// provider
  final _provider = AppSettingsProvider();

  /// get sport type API.
  Future<AppSettingsResponseModel> getAppSettings() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      dio.Response? response = await _provider.getSettings();

      if (response.statusCode == NetworkConstants.success) {
        /// On success
        return _getAppSettingsSuccess(response);
      } else {
        /// On Error
        _getSportsError(response);
        return AppSettingsResponseModel();
      }
    } else {
      GetIt.I<CommonUtils>().showNetworkError();
      return AppSettingsResponseModel();
    }
  }

  /// Perform login api success
  AppSettingsResponseModel _getAppSettingsSuccess(dio.Response response) {
    AppSettingsResponseModel model =
        AppSettingsResponseModel.fromJson(response.data);

    /// set items to the list.
    if (model.status == true) {
      for (AppSettingsResponseModelData element in (model.data ?? [])) {
        GetIt.instance<AppFields>().setFieldsData(element);
      }
    }

    return model;
  }

  /// Perform api error.
  void _getSportsError(dio.Response response) {
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }
}
