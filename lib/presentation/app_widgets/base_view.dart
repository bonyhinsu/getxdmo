import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_on_flutter/values/app_colors.dart';
import 'package:get/get.dart';

import '../../values/app_font_size.dart';
import '../../values/app_icons.dart';
import '../../values/app_values.dart';

mixin AppBarMixin {
  /// Return app bar widget.
  AppBar buildAppBar(
      {String title = "",
      bool centerTitle = true,
      bool backEnable = true,
      Function? onBackClick}) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.pageBackground,
      leadingWidth: backEnable
          ? AppValues.appbarBackButtonSize + AppValues.margin
          : 0,
      centerTitle: centerTitle,
      leading: backEnable ? buildBackButton(onClick: onBackClick) : Container(),
      title: buildTitleText(title: title, isMainTitle: centerTitle),
    );
  }

  /// Return back button widget.
  Widget buildBackButton({Function? onClick, Color? backgroundColor}) => GestureDetector(
        onTap: onClick == null ? () => Get.back() : () => onClick(),
        child: Container(
          margin: const EdgeInsets.only(
              left: AppValues.margin, top: AppValues.appbarTopMargin),
          decoration: BoxDecoration(
              color: backgroundColor??Colors.transparent,
              borderRadius: BorderRadius.circular(8)),
          height: AppValues.appbarBackButtonSize,
          width: AppValues.appbarBackButtonSize,
          child: SvgPicture.asset(AppIcons.backIcon),
        ),
      );

  /// Return title widget.
  Widget buildTitleText({required String title, bool isMainTitle = true}) {
    return Container(
        margin: const EdgeInsets.only(top: AppValues.appbarTopMargin),
        child: Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: FontConstants.poppins,
              fontSize: isMainTitle ? 18 : 16,
              color: AppColors.textColorSecondary),
        ));
  }

  /// Return app bar widget.
  AppBar buildAppBarWithActions(
      {String title = "",
      bool centerTitle = true,
      bool backEnable = true,
      required List<Widget> actions}) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leadingWidth: backEnable
          ? AppValues.appbarBackButtonSize + AppValues.screenMargin
          : 0,
      centerTitle: centerTitle,
      leading: backEnable ? buildBackButton() : Container(),
      title: buildTitleText(title: title, isMainTitle: centerTitle),
      actions: actions,
    );
  }

  /// Return app bar with logo widget.
  AppBar buildAppBarLogoWithActions(
      {String title = "",
      bool centerTitle = true,
      bool logoEnable = true,
      required List<Widget> actions}) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leadingWidth: 150,
      centerTitle: centerTitle,
      leading: logoEnable ? buildLogoButton() : Container(),
      title: buildTitleText(title: title, isMainTitle: centerTitle),
      actions: actions,
    );
  }

  /// Return app bar with logo widget.
  AppBar buildHomeAppBarLogoWithActions(
      {String title = "",
      bool centerTitle = true,
      bool logoEnable = true,
      required List<Widget> actions}) {
    return AppBar(
      elevation: 0,
      toolbarHeight: 70,
      backgroundColor: AppColors.pageBackground,
      leadingWidth: 190,
      centerTitle: centerTitle,
      leading: logoEnable ? buildLogoButton() : Container(),
      title: buildTitleText(title: title, isMainTitle: centerTitle),
      actions: actions,
    );
  }

  /// Return logo widget.
  Widget buildLogoButton() => GestureDetector(
        child: Container(
          margin: const EdgeInsets.only(
            left: AppValues.screenMargin,
          ),
          child: SvgPicture.asset(
            AppIcons.logo,
          ),
        ),
      );
}
