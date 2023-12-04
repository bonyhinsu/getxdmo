import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:game_on_flutter/values/app_colors.dart';
import 'package:game_on_flutter/values/app_icons.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:get/get.dart';

import '../../values/app_values.dart';
import '../screens/club/club_profile/controllers/club_profile.controller.dart';

class ProfileMenuTileWidget extends StatelessWidget {
  Function(MenuModel model) onClick;
  MenuModel model;

  ProfileMenuTileWidget({required this.model, required this.onClick, Key? key})
      : super(key: key);

  late TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
          vertical: AppValues.padding_4, horizontal: AppValues.mediumPadding),
      leading: SvgPicture.asset(
        model.menuIcon,
        height: AppValues.iconSize_24,
        width: AppValues.iconSize_24,
      ),
      minLeadingWidth: 15,
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.transparent, width: 1),
          borderRadius: BorderRadius.circular(AppValues.roundedButtonRadius)),
      tileColor: AppColors.appWhiteButtonColor.withOpacity(0.1),
      onTap: () => onClick(model),
      title: Text(
        model.title,
        style: textTheme.bodyMedium,
      ),
      trailing: Visibility(
          visible: model.isArrowShow,
          child: SvgPicture.asset(AppIcons.arrowIcon)),
    );
  }
}
