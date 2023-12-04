import 'package:game_on_flutter/infrastructure/model/club/post/post_filter_model.dart';

class ClubActivityFilter {
  String title = "";
  bool multiSelection = true;
  bool isRadio = false;
  bool canBeDisabled = false;
  List<PostFilterModel> filterSubItems = [];

  ClubActivityFilter({required this.title, required this.filterSubItems, this.canBeDisabled=false});

  ClubActivityFilter.singleSelection({
    required this.title,
    required this.filterSubItems,
  }) {
    multiSelection = false;
    isRadio = false;
  }

  ClubActivityFilter.radioSelection({
    required this.title,
    required this.filterSubItems,
  }) {
    multiSelection = false;
    isRadio = true;
  }
}

class FilterItem {
  String title = "";
  int itemId = -1;
  bool isSelected = false;

  FilterItem({required this.title,required this.itemId, this.isSelected = false});
}
