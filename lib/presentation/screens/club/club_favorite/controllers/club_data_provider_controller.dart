import 'dart:async';

import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../../infrastructure/model/club/actiivty_filter_model.dart';
import '../../../../../infrastructure/model/club/post/post_filter_model.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../infrastructure/storage/preference_manager.dart';
import '../../../../../values/app_constant.dart';
import '../../../../../values/app_string.dart';
import '../../../authentication/general_data/controllers/app_master_data.controller.dart';
import '../../club_profile/controllers/user_detail_controller.dart';

class ClubDataProviderController extends GetxController {
  /// Menu list
  List<ClubActivityFilter> filterMenuList = RxList();

  late MasterDataController masterDataController;

  @override
  void onInit() {
    masterDataController = Get.find(tag: Routes.MASTER_DATA_PROVIDER);
    super.onInit();
  }

  /// Prepare menu items.
  void prepareMenuItems() {
    filterMenuList.clear();

    filterMenuList.addAll([
      getSportMenu(),
      getLevelMenu(),
      getLocationMenu(),
      getPlayerTypeMenu(),
      getPreferredPositionMenu()
    ]);
  }

  /// Prepare menu items.
  void prepareMenuItemsForPlayer() {
    filterMenuList.clear();

    filterMenuList.addAll([
      getSportMenu(),
      getLocationMenu(),
      getLevelMenu(),
    ]);
  }

  /// return list of [ClubActivityFilter] for sport menu.
  ClubActivityFilter getSportMenu() {
    final sportList = masterDataController.sportsTypeList;
    List<PostFilterModel> menuItems = [];
    final UserDetailService service = Get.find(tag: AppConstants.USER_DETAILS);
    List<int> sportId = service.userDetails.value.userSportsDetails
            ?.map((e) => e.sportTypeId ?? -1)
            .toList() ??
        [];
    for (var element in sportList) {
      menuItems.add(PostFilterModel(
          itemId: element.itemId,
          title: element.title,
          enable: GetIt.I<PreferenceManager>().isClub
              ? sportId.contains(element.itemId)
              : true));
    }

    runZoned(
      () {
        /// For club, move enabled sports to the
        if (GetIt.I<PreferenceManager>().isClub) {
          final selectedList =
              menuItems.where((element) => element.enable).toList();
          final unselectedList =
              menuItems.where((element) => !element.enable).toList();
          menuItems.clear();
          menuItems.addAll(selectedList);
          menuItems.addAll(unselectedList);
        }
      },
    );
    return ClubActivityFilter(
        title: AppString.sports,
        filterSubItems: menuItems,
        canBeDisabled: true);
  }

  /// return list of [ClubActivityFilter] for level.
  ClubActivityFilter getLevelMenu() {
    final levelList = masterDataController.clubLevel;
    List<PostFilterModel> menuItems = [];
    for (var element in levelList) {
      menuItems.add(
          PostFilterModel(itemId: element.itemId, title: element.title ?? ""));
    }
    return ClubActivityFilter(
        title: AppString.levels, filterSubItems: menuItems);
  }

  /// return list of [ClubActivityFilter] for location.
  ClubActivityFilter getLocationMenu() {
    final levelList = masterDataController.clubLocationList;
    List<PostFilterModel> menuItems = [];
    for (var element in levelList) {
      menuItems.add(
          PostFilterModel(itemId: element.itemId, title: element.title ?? ""));
    }
    return ClubActivityFilter(
        title: AppString.locations, filterSubItems: menuItems);
  }

  /// return list of [ClubActivityFilter] for player type.
  ClubActivityFilter getPlayerTypeMenu() {
    final levelList = masterDataController.playerTypeList;
    List<PostFilterModel> menuItems = [];
    for (var element in levelList) {
      menuItems.add(
          PostFilterModel(itemId: element.itemId, title: element.title ?? ""));
    }
    return ClubActivityFilter(
        title: AppString.gender, filterSubItems: menuItems);
  }

  /// return list of [ClubActivityFilter] for preferred position.
  ClubActivityFilter getPreferredPositionMenu() {
    final levelList = masterDataController.playerPositionList;
    List<PostFilterModel> menuItems = [];
    for (var element in levelList) {
      menuItems.add(PostFilterModel(
          itemId: element.itemId,
          parentSportId: element.parentSportId,
          title: element.title ?? ""));
    }
    return ClubActivityFilter(
        title: AppString.preferredPositions, filterSubItems: menuItems);
  }
}
