import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

import '../../values/app_icons.dart';
import '../../values/app_values.dart';

class AppSquareCheckboxWidget extends StatelessWidget {
  Function(bool isSelected) onSelected;
  bool isSelected;

  AppSquareCheckboxWidget(
      {required this.isSelected, required this.onSelected, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundCheckBox(
      isRound: false,
      size: AppValues.iconSize_26,
      onTap: (selected) => onSelected(selected ?? false),
      isChecked: isSelected,
      animationDuration: const Duration(milliseconds: 200),
      border: Border.all(color: Colors.transparent),
      checkedColor: Colors.transparent,
      uncheckedColor: Colors.transparent,
      checkedWidget: SvgPicture.asset(
        AppIcons.checkSelected,
      ),
      uncheckedWidget: SvgPicture.asset(
        AppIcons.checkUnSelected,
      ),
    );
  }
}
