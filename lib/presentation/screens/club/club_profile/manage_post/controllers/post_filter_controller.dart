import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:group_button/group_button.dart';

import '../../../../../../infrastructure/model/club/actiivty_filter_model.dart';

class PostFilterController extends GetxController {
  /// Menu list
  RxList<FilterItem> filterMenuList = RxList();

  /// Button selection controller
  GroupButtonController controller = GroupButtonController();

  /// set filter menu items.
  void setFilterMenuList(List<FilterItem> list) {
    filterMenuList.clear();
    filterMenuList.addAll(list);
  }

  /// On select or deselect list.
  ///
  /// required [parentIndex] as parent list index.
  /// required [childIndex] as child list index.
  /// required [isSelected] as stores is checked or not.
  void onItemClick(int parentIndex, bool isSelected) {
    filterMenuList[parentIndex].isSelected = isSelected;
    filterMenuList.refresh();
  }

  /// Build clear all fields.
  void clearAll() {
    controller.unselectAll();
    filterMenuList.forEachIndexed((childIndex, childElement) {
      filterMenuList[childIndex].isSelected = false;
    });
    filterMenuList.refresh();
  }
}
