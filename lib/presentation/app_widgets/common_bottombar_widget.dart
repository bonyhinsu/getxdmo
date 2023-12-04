import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../values/app_colors.dart';
import '../screens/club/club_main/controllers/club_main.controller.dart';
import 'bottombar_single_widget.dart';

class CommonBottomBarWidget extends StatelessWidget {
  Function(int index) onTap;
  int currentSelectedIndex;
  List<BottomBarItem> items;

  CommonBottomBarWidget(
      {required this.onTap,
      required this.currentSelectedIndex,
      required this.items,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    bool isIos = GetPlatform.isIOS;
    return BottomAppBar(
      color: AppColors.bottomBarBackground,
      elevation: 0,
      child: BottomNavigationBar(
        unselectedItemColor: AppColors.textPlaceholderColor,
        selectedItemColor: AppColors.textColorPrimary,
        onTap: onTap,
        currentIndex: currentSelectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.bottomBarBackground,
        elevation: 0,
        unselectedLabelStyle:
            themeData.textTheme.bodyText2?.copyWith(fontSize: 0),
        selectedLabelStyle:
            themeData.textTheme.bodyText2?.copyWith(fontSize: 0),
        items: items.map((e) {
          return BottomNavigationBarItem(
              icon: BottombarSingleWidget(
                  selectedIcon: e.selectedIcon ?? "",
                  icon: e.icon ?? "",
                  label: e.title ?? "",
                  isSelected: currentSelectedIndex == e.itemIndex),
              label: "");
        }).toList(),
      ),
    );
  }
}
