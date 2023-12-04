import 'package:collection/collection.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_loading_mixin.dart';
import 'package:get/get.dart';
import 'package:group_button/group_button.dart';

import '../../../../../infrastructure/model/club/post/post_filter_model.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../club/club_favorite/controllers/club_data_provider_controller.dart';

class ActivityFilterSublistController extends GetxController
    with AppLoadingMixin {
  /// Button selection controller
  GroupButtonController controller = GroupButtonController();

  RxString selectedValue = ''.obs;

  RxBool showSection = true.obs;

  List<PostFilterModel> originalList = [];

  RxList<PostFilterModel> subItemList = RxList();

  List<int> filterItemIds = [];

  void setInitialData(
      List<PostFilterModel> filterSubItems, bool isRadio, bool canBeDisabled) {
    originalList = filterSubItems;
    subItemList.value = originalList;
    prepareFieldProperties(isRadio, canBeDisabled);
  }

  void prepareFieldProperties(bool isRadio, bool canBeDisabled) {
    if (canBeDisabled) {
      List<int> disableIndex = [];
      subItemList.value.forEachIndexed((index, element) {
        if (!element.enable) {
          disableIndex.add(index);
        }
      });

      // Pass disableIndex list to button controller.
      controller.disableIndexes(disableIndex);
    }

    List<int> selectedIndex = [];
    subItemList.value.forEachIndexed((index, element) {
      if (element.isSelected) {
        // select radio button for single selection
        if (isRadio) {
          selectedValue.value = element.title ?? "";
        } else {
          // select controller index
          selectedIndex.add(index);
        }
      }
    });
    subItemList.refresh();

    controller.selectIndexes(selectedIndex);
  }

  void unselectAll() {
    controller.unselectAll();
    selectedValue.value = '';
    filterItemIds.clear();
    filterBySportIds();
  }

  void filterMenuListBySportId(int sportId, bool selected) {
    if (!selected) {
      filterItemIds.remove(sportId);
    } else {
      filterItemIds.add(sportId);
    }
    filterItemIds.removeWhere((element) => element == -1);

    filterBySportIds();
  }

  /// filter by sport Ids
  void filterBySportIds() {
    if (filterItemIds.isEmpty) {
      subItemList.value = originalList;
    } else {
      subItemList.value = originalList
          .where((element) => filterItemIds.contains(element.parentSportId))
          .toList();

      subItemList.refresh();
    }
  }

  /// Filter already selected preferred positions.
  void filterSelectedSport() {
    ClubDataProviderController clubDataProvider =
        Get.find(tag: Routes.CLUB_DATA_PROVIDER);
    final mainList = clubDataProvider.filterMenuList;

    final filteredIds = (mainList[0]
        .filterSubItems
        .where((element) => element.isSelected)).map((e) => e.itemId);
    // Prepare position list based on selected sport ids (filteredIds).
    final list1 = mainList[4]
        .filterSubItems
        .where((element) => filteredIds.contains(element.parentSportId))
        .toList();

    setInitialData(list1, false, false);
  }
}
