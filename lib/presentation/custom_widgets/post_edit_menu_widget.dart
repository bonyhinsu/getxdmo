import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../values/app_colors.dart';
import '../../values/app_icons.dart';
import '../../values/app_string.dart';
import '../../values/app_values.dart';

class PostEditMenuWidget extends StatelessWidget {
  Function() onEdit;
  Function() onDelete;
  late TextTheme textTheme;

  /// Popup Menu key
  final GlobalKey<PopupMenuButtonState<int>> popupMenuKey = GlobalKey();

  PostEditMenuWidget({Key? key, required this.onEdit, required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.only(left: AppValues.margin_10),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerTheme: const DividerThemeData(
              color: AppColors.textColorDarkGray,
              thickness: 0.5,
              space: 0.5,
              indent: 0),
        ),
        child: PopupMenuButton<int>(
          key: popupMenuKey,
          elevation: 4,
          color: AppColors.pageBackground,
          itemBuilder: (context) {
            return <PopupMenuEntry<int>>[
              PopupMenuItem(
                value: 0,
                onTap: () => onEdit(),
                height: AppValues.iconSize_24,
                child: Row(
                  children: [
                    SvgPicture.asset(AppIcons.postEditIcon),
                    size10,
                    Text(AppString.strEdit,
                        style: textTheme.headlineSmall?.copyWith()),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                  onTap: () => onDelete(),
                  height: AppValues.iconSize_24,
                  value: 1,
                  child: Row(
                    children: [
                      SvgPicture.asset(AppIcons.postDeleteIcon),
                      size10,
                      Text(
                        AppString.strDelete,
                        style: textTheme.headlineSmall?.copyWith(),
                      ),
                    ],
                  )),
            ];
          },
          child: SizedBox(
            width: AppValues.iconSize_24,
            height: AppValues.iconSize_24,
            child: SvgPicture.asset(
              AppIcons.horizontalMoreIcon,
            ),
          ),
        ),
      ),
    );
  }

  /// Build margin 10.
  Widget get size10 => const SizedBox(
        width: AppValues.margin_10,
      );
}
