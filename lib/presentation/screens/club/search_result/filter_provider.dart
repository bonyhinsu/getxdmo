import 'package:flutter/cupertino.dart';

import '../../../../infrastructure/model/club/actiivty_filter_model.dart';

class FilterItemProvider extends ChangeNotifier{
  List<ClubActivityFilter> filterMenu = [];


  void setFilterMenu(List<ClubActivityFilter> list){
    filterMenu = list;
    notifyListeners();
  }
}