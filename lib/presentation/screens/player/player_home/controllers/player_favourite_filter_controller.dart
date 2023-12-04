import 'package:get/get.dart';

import '../../../../../infrastructure/model/club/actiivty_filter_model.dart';
import '../../../../../infrastructure/model/club/post/post_filter_model.dart';
import '../../../../../infrastructure/model/club/signup/selection_model.dart';
import '../../../../../values/app_string.dart';

class PlayerFavouriteFilterController extends GetxController {
  /// Menu list
  RxList<ClubActivityFilter> filterMenuList = RxList();

  @override
  void onInit() {
    prepareMenuItems();
    super.onInit();
  }

  /// Prepare menu items.
  void prepareMenuItems() {
    if (filterMenuList.isEmpty) {
      filterMenuList.addAll([
        getSportMenu(),
        getLevelMenu(),
        getLocationMenu(),
      ]);
    }
  }

  /// return list of [ClubActivityFilter] for sport menu.
  ClubActivityFilter getSportMenu() {
    final sportList = DataProvider().getSportList().sublist(0,2);
    List<PostFilterModel> menuItems = [];
    for (var element in sportList) {
      menuItems.add(PostFilterModel(title: element.sportName));
    }
    return ClubActivityFilter(
        title: AppString.sports, filterSubItems: menuItems);
  }

  /// return list of [ClubActivityFilter] for level.
  ClubActivityFilter getLevelMenu() {
    final levelList = DataProvider().getPlayerLevel();
    List<PostFilterModel> menuItems = [];
    for (var element in levelList) {
      menuItems.add(PostFilterModel(title: element.title ?? ""));
    }
    return ClubActivityFilter(
        title: AppString.levels, filterSubItems: menuItems);
  }

  /// return list of [ClubActivityFilter] for location.
  ClubActivityFilter getLocationMenu() {
    final levelList = DataProvider().getLocation();
    List<PostFilterModel> menuItems = [];
    for (var element in levelList) {
      menuItems.add(PostFilterModel(title: element.title ?? ""));
    }
    return ClubActivityFilter(
        title: AppString.locations, filterSubItems: menuItems);
  }

  /// Add selected filter list.
  void addSelectedFilter(List<ClubActivityFilter> tempList) {
    filterMenuList.value = tempList;
  }
}
