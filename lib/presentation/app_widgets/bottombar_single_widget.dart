import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class BottombarSingleWidget extends StatelessWidget {
  String icon;
  String selectedIcon;
  String label;
  bool isSelected;

  BottombarSingleWidget(
      {required this.icon,
      required this.selectedIcon,
      required this.label,
      required this.isSelected,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isIos = GetPlatform.isIOS;
    return Visibility(
      visible: label.isNotEmpty,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 7,
                    blurRadius: 12,
                  ),
                ]
              : [],
        ),
        child: SvgPicture.asset(
          isSelected ? selectedIcon : icon,
          height: 24,
          width: 24,
        ),
      ),
    );
  }
}
