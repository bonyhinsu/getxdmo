import 'package:dio/dio.dart' as dio;
import 'package:game_on_flutter/presentation/app_widgets/app_loading_mixin.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../../../../infrastructure/model/club/signup/selection_model.dart';
import '../../../../../infrastructure/model/common/sportstype_response_model.dart';
import '../../../../../infrastructure/network/api_utils.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../infrastructure/storage/preference_manager.dart';
import '../../../../../values/app_constant.dart';
import '../../../../../values/app_icons.dart';
import '../../../../../values/app_string.dart';
import '../../../../../values/common_utils.dart';
import '../../../club/club_profile/controllers/user_detail_controller.dart';
import '../provider/master_data.provider.dart';

class MasterDataController extends GetxController with AppLoadingMixin {
  /// Store and update list.
  List<SelectionModel> sportsTypeList = [];

  /// Store and update list.
  List<SelectionModel> clubLevel = [];

  List<SelectionModel> clubLocationList = [];

  /// Store and update list.
  List<SelectionModel> playerTypeList = [];

  List<SelectionModel> playerPositionList = [];

  /// provider
  final MasterDataProvider _provider = MasterDataProvider();

  /// Logger
  final logger = Logger();

  Future<void> getPrepareData() async {
    sportsTypeList.clear();
    clubLevel.clear();
    clubLocationList.clear();
    playerTypeList.clear();
    playerPositionList.clear();
    showGlobalLoading();
    if (GetIt.I<PreferenceManager>().isClub) {
      _prepareGenderList();
      await Future.wait([
        getSportTypeAPI(),
        getLocationAPI(),
        getLevelAPI(),
        // getPlayerType(),
      ]).then((value) async {
        hideGlobalLoading();
      });
    } else {
      await Future.wait([
        getSportTypeAPI(),
        getLocationAPI(),
        getLevelAPI(),
      ]).then((value) async {
        hideGlobalLoading();
      });
    }
  }

  /// Prepare gender list.
  void _prepareGenderList() {
    playerTypeList.addAll([
      SelectionModel.withoutIcon(title: AppString.male, itemId: 0),
      SelectionModel.withoutIcon(title: AppString.female, itemId: 1),
      SelectionModel.withoutIcon(title: AppString.jnrBoy, itemId: 2),
      SelectionModel.withoutIcon(title: AppString.jnrGirl, itemId: 3)
    ]);
  }

  /// get sport type API.
  Future<void> getSportTypeAPI() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      dio.Response? response = await _provider.getSportType();

      if (response.statusCode == NetworkConstants.success) {
        /// On success
        SportTypeListResponseModel model =
            SportTypeListResponseModel.fromJson(response.data);

        /// set items to the list.
        if (model.status == true) {
          final UserDetailService service =
              Get.find(tag: AppConstants.USER_DETAILS);

          List<int> sportId = service.userDetails.value.userSportsDetails
                  ?.map((e) => e.sportTypeId ?? -1)
                  .toList() ??
              [];

          for (var element in (model.data ?? [])) {
            sportsTypeList.add(SelectionModel.withIcon(
                title: element.name,
                icon: AppIcons.iconAFL,
                isPng: true,
                isEnabled: GetIt.I<PreferenceManager>().isClub
                    ? sportId.contains(element.id)
                    : true,
                itemId: element.id));
          }

          if (GetIt.I<PreferenceManager>().isClub) {
            sportId.forEach((element) async {
              await getPreferredPosition(element.toString());
            });
          }
          await Future.delayed(Duration(milliseconds: (sportId.length * 400)));
        }
      } else {
        /// On Error
        _getSportsError(response);
      }
    } else {
      GetIt.I<CommonUtils>().showNetworkError();
    }
  }

  /// Perform api error.
  void _getSportsError(dio.Response response) {
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }

  /// get level type API.
  Future<void> getLevelAPI() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      dio.Response? response = await _provider.getLevel();

      if (response.statusCode == NetworkConstants.success) {
        /// On success
        SportTypeListResponseModel model =
            SportTypeListResponseModel.fromJson(response.data);

        /// set items to the list.
        if (model.status == true) {
          for (var element in (model.data ?? [])) {
            clubLevel.add(SelectionModel.withoutIcon(
                title: element.name, itemId: element.id));
          }
        }
      } else {
        /// On Error
        _getSportsError(response);
      }
    } else {
      GetIt.I<CommonUtils>().showNetworkError();
    }
  }

  /// get location type API.
  Future<void> getLocationAPI() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      dio.Response? response = await _provider.getLocations();

      if (response.statusCode == NetworkConstants.success) {
        /// On success
        SportTypeListResponseModel model =
            SportTypeListResponseModel.fromJson(response.data);

        /// set items to the list.
        if (model.status == true) {
          for (var element in (model.data ?? [])) {
            clubLocationList.add(SelectionModel.withoutIcon(
                title: element.name, itemId: element.id));
          }
        }
      } else {
        /// On Error
        _getSportsError(response);
      }
    } else {
      GetIt.I<CommonUtils>().showNetworkError();
    }
  }

  /// get player type API.
  Future<void> getPlayerType() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      dio.Response? response = await _provider.getPlayerType();

      if (response.statusCode == NetworkConstants.success) {
        /// On success
        SportTypeListResponseModel model =
            SportTypeListResponseModel.fromJson(response.data);

        /// set items to the list.
        if (model.status == true) {
          for (var element in (model.data ?? [])) {
            playerTypeList.add(SelectionModel.withoutIcon(
                title: element.name, itemId: element.id));
          }
        }
      } else {
        /// On Error
        _getSportsError(response);
      }
    } else {
      GetIt.I<CommonUtils>().showNetworkError();
    }
  }

  /// get preferred position API.
  Future<void> getPreferredPosition(String sportId) async {
    try {
      if (await NetworkConnectivity.instance.hasNetwork()) {
        dio.Response? response =
            await _provider.getPreferredPositionFromSports(sportsType: sportId);

        if (response.statusCode == NetworkConstants.success) {
          /// On success
          SportTypeListResponseModel model =
              SportTypeListResponseModel.fromJson(response.data);

          /// set items to the list.
          if (model.status == true) {
            for (var element in (model.data ?? [])) {
              playerPositionList.add(SelectionModel.withDescription(
                  description: element.description,
                  parentSportId: int.parse(sportId),
                  title: element.name,
                  itemId: element.id));
            }
          }
        } else {
          /// On Error
          _getSportsError(response);
        }
      } else {
        GetIt.I<CommonUtils>().showNetworkError();
      }
    } catch (ex) {
      logger.e(ex);
    }
  }
}
