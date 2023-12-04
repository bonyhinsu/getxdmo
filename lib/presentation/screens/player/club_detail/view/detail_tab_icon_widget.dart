import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_on_flutter/values/app_colors.dart';
import 'package:game_on_flutter/values/app_values.dart';

class DetailTabIconWidget extends StatelessWidget {
  String iconName;
  String menuTitle;
  bool isSelected = false;
  bool darkColorRequired = false;

  DetailTabIconWidget(
      {required this.iconName,
      this.menuTitle = "",
      this.isSelected = false,
      this.darkColorRequired = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        menuTitle.isNotEmpty
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    iconName,
                    height: AppValues.height_18,
                    width: AppValues.height_18,
                    color: isSelected
                        ? AppColors.appRedButtonColor
                        : darkColorRequired
                            ? AppColors.textColorDarkGray
                            : AppColors.textColorSecondary,
                  ),
                  const SizedBox(
                    width: AppValues.margin_8,
                  ),
                  Text(
                    menuTitle,
                    style: textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? AppColors.appRedButtonColor
                            : AppColors.textColorSecondary.withOpacity(0.7)),
                  )
                ],
              )
            : SvgPicture.asset(
                iconName,
                height: AppValues.height_20,
                width: AppValues.height_20,
                color: isSelected
                    ? AppColors.appRedButtonColor
                    : darkColorRequired
                        ? AppColors.textColorDarkGray
                        : AppColors.textColorSecondary,
              ),
        const SizedBox(height: AppValues.height_14,),
      ],
    );
  }
}
