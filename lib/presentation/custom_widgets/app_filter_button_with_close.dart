import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_on_flutter/values/app_icons.dart';
import 'package:game_on_flutter/values/app_values.dart';

import '../../infrastructure/model/club/post/post_filter_model.dart';
import '../../values/app_colors.dart';

class AppFilterButtonWithCheck extends StatelessWidget {
  PostFilterModel model;

  int index;

  Function(int index) onDelete;

  AppFilterButtonWithCheck(
      {required this.model,
      required this.index,
      required this.onDelete,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppValues.smallRadius),
          color: AppColors.textColorSecondary.withOpacity(0.1)),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Text(
            model.title ?? "",
            style: theme.displaySmall
                ?.copyWith(color: AppColors.appRedButtonColor),
          ),
          const SizedBox(
            width: AppValues.height_4,
          ),
          GestureDetector(
              onTap: () => onDelete(index),
              child: SvgPicture.asset(
                AppIcons.iconClose,
                color: AppColors.textColorSecondary,
              ))
        ],
      ),
    );
  }
}
