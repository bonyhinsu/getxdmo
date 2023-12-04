import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:game_on_flutter/values/app_colors.dart';
import 'package:game_on_flutter/values/app_icons.dart';
import 'package:game_on_flutter/values/app_values.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

class AppCheckboxWidget extends StatelessWidget {
  Function(bool isSelected) onSelected;
  bool isSelected;

  AppCheckboxWidget(
      {required this.isSelected, required this.onSelected, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundCheckBox(
      size: AppValues.iconSize_26,
      onTap: (selected) => onSelected(selected ?? false),
      isChecked: isSelected,
      animationDuration: const Duration(milliseconds: 200),
      border: Border.all(color: Colors.transparent),
      checkedColor: AppColors.appWhiteButtonColor,
      uncheckedColor: AppColors.appWhiteButtonColor.withOpacity(0.15),
      checkedWidget: Padding(
        padding: const EdgeInsets.all(AppValues.padding_6),
        child: SvgPicture.asset(
          AppIcons.iconCheckmark,
          height: AppValues.iconSize_10,
          width: AppValues.iconSize_10,
        ),
      ),
    );
  }
}
