import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../../infrastructure/model/club/actiivty_filter_model.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../infrastructure/storage/preference_manager.dart';
import '../../../../../values/app_string.dart';
import '../../../club/club_favorite/controllers/club_data_provider_controller.dart';
import 'activity_filter_sublist_controller.dart';

class ClubActivityFilterOptionController extends GetxController {
  /// Menu list
  RxList<ClubActivityFilter> filterMenuList = RxList();

  /// Original list
  List<ClubActivityFilter> originalList = [];

  /// set filter menu items.
  void setFilterMenuList(List<ClubActivityFilter> list) {
    filterMenuList.clear();
    filterMenuList.addAll(list);
    ClubDataProviderController clubDataProvider =
        Get.find(tag: Routes.CLUB_DATA_PROVIDER);
    originalList = clubDataProvider.filterMenuList;
  }

  /// On select or deselect list.
  ///
  /// required [parentIndex] as parent list index.
  /// required [childIndex] as child list index.
  /// required [isSelected] as stores is checked or not.
  void onItemClick(int parentIndex, int childIndex, bool isSelected) {
    filterMenuList[parentIndex].filterSubItems[childIndex].isSelected =
        isSelected;
    if (GetIt.I<PreferenceManager>().isClub && parentIndex == 0) {
      final filteredIds = (originalList[0]
          .filterSubItems
          .where((element) => element.isSelected)).map((e) => e.itemId);

      // Prepare position list based on selected sport ids (filteredIds).
      final list = originalList[4]
          .filterSubItems
          .where((element) => filteredIds.contains(element.parentSportId))
          .toList();
      // // Update the preferred position based sport selection.
      if (parentIndex == 0) {
        ActivityFilterSublistController controller =
            Get.find(tag: "filter_${AppString.preferredPositions}");
        controller.setInitialData(list, false, false);
      }
    }
  }

  /// clear all selection on click.
  void clearAll() {
    filterMenuList.forEachIndexed((parentIndex, element) {
      element.filterSubItems.forEachIndexed((childIndex, childElement) {
        filterMenuList[parentIndex].filterSubItems[childIndex].isSelected =
            false;
      });
      bool isControllerRegister =
          Get.isRegistered<ActivityFilterSublistController>(
              tag: "filter_${filterMenuList[parentIndex].title}");
      if (isControllerRegister) {
        ActivityFilterSublistController activityFilterSublistController =
            Get.find(tag: "filter_${filterMenuList[parentIndex].title}");
        activityFilterSublistController.unselectAll();
      }
    });
    filterMenuList.refresh();
  }
}
