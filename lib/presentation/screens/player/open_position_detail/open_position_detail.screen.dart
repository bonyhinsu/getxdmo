import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../infrastructure/navigation/routes.dart';
import '../../../../values/app_colors.dart';
import '../../../../values/app_font_size.dart';
import '../../../../values/app_icons.dart';
import '../../../../values/app_string.dart';
import '../../../../values/app_values.dart';
import '../../../../values/common_utils.dart';
import '../../../app_widgets/club_profile_widget.dart';
import '../../../custom_widgets/post_edit_menu_widget.dart';
import 'controllers/open_position_detail.controller.dart';

class OpenPositionDetailScreen extends GetView<OpenPositionDetailController> {
  OpenPositionDetailScreen({Key? key}) : super(key: key);

  final OpenPositionDetailController _controller =
      Get.find(tag: Routes.OPEN_POSITION_DETAIL);

  late TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return Obx(()=>Scaffold(
      appBar: buildHeaderAppbar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppValues.screenMargin),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: AppValues.screenMargin,
              ),
              buildDateWidget(),
              const SizedBox(
                height: AppValues.screenMargin,
              ),
              buildPlayerPositionText(),
              const SizedBox(
                height: AppValues.height_10,
              ),
              buildPersonalDetailRow(),
              const SizedBox(
                height: AppValues.height_10,
              ),
              buildSportsDetailRow(),
              const SizedBox(
                height: AppValues.height_10,
              ),
              const SizedBox(
                height: AppValues.height_10,
              ),
              buildText(),
              const SizedBox(
                height: AppValues.screenMargin,
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  /// Build player position text.
  Widget buildPlayerPositionText() => Hero(
        tag: "pos_${(_controller.postModel.value.index).toString()}",
        child: Text(
          _controller.postModel.value.positionName ?? "",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: textTheme.displayLarge?.copyWith(fontSize: 20),
        ),
      );

  /// Build player position text.
  Widget buildDateWidget() => Text(
        CommonUtils.getRemainingDaysInWord(_controller.postModel.value.time ?? "",isUTC: true),
        style: textTheme.headlineSmall
            ?.copyWith(color: AppColors.textColorDarkGray),
      );

  /// Build personal detail row.
  Widget buildPersonalDetailRow() => Hero(
        tag: "personal_detail_${(_controller.postModel.value.index).toString()}",
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            buildItemWidget(
                icon: AppIcons.age, title: '${_controller.postModel.value.age} years'),
            buildItemWidget(icon:( _controller.postModel.value.gender=='male')?AppIcons.iconMale:AppIcons.iconFemale, title: _controller.postModel.value.gender.capitalizeFirst??""),
            Expanded(
                child: buildItemWidget(
                    icon: AppIcons.locationIcon,
                    title: _controller.postModel.value.location??"",
                    isLast: true))
          ],
        ),
      );

  /// Build header app bar widget
  AppBar buildHeaderAppbar() => AppBar(
        elevation: 0,
        backgroundColor: AppColors.pageBackground,
        leadingWidth: AppValues.appbarBackButtonSize + AppValues.screenMargin,
        centerTitle: true,
        leading: FittedBox(
          fit: BoxFit.contain,
          child: buildIconButton(
              icon: AppIcons.backArrowIcon, onClick: _controller.onBackPressed),
        ),
        title: GestureDetector(
          onTap: _controller.onHeaderClick,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildClubProfilePicture(),
              const SizedBox(
                width: AppValues.height_12,
              ),
              Expanded(
                  child: buildTitleText(
                      title: _controller.postModel.value.clubName ?? "",
                      isMainTitle: true)),
            ],
          ),
        ),
        actions: [
          _controller.enableEdit
              ? Padding(
                  padding: const EdgeInsets.only(
                      top: AppValues.appbarTopMargin,
                      right: AppValues.screenMargin,
                      bottom: AppValues.appbarTopMargin),
                  child: PostEditMenuWidget(
                    onDelete: _controller.onDeletePost,
                    onEdit: _controller.onEditPost,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(
                      top: AppValues.appbarTopMargin,
                      right: AppValues.height_6,
                      bottom: AppValues.appbarTopMargin),
                  child: IconButton(
                    onPressed: _controller.onShare,
                    icon: SizedBox(
                      width: AppValues.iconSize_24,
                      height: AppValues.iconSize_24,
                      child: SvgPicture.asset(
                        AppIcons.iconShare,
                      ),
                    ),
                  ),
                )
        ],
      );

  /// Build club profile picture.
  Widget buildClubProfilePicture() {
    const editIconSize = 42.0;
    return Padding(
      padding: const EdgeInsets.only(
          top: AppValues.appbarTopMargin, bottom: AppValues.appbarTopMargin),
      child: ClubProfileWidget(
        profileURL: _controller.postModel.value.clubLogo ?? "",
        width: editIconSize,
        height: editIconSize,
      ),
    );
  }

  /// Return back button widget.
  Widget buildIconButton({Function? onClick, required String icon}) =>
      GestureDetector(
        onTap: onClick == null ? () => Get.back() : () => onClick(),
        child: Container(
          margin: const EdgeInsets.only(
              left: AppValues.screenMargin,
              top: AppValues.appbarTopMargin,
              bottom: AppValues.appbarTopMargin),
          decoration: BoxDecoration(
              border:
                  Border.all(color: AppColors.inputFieldBorderColor, width: 1),
              color: AppColors.textColorSecondary.withOpacity(0.20),
              borderRadius: BorderRadius.circular(AppValues.smallRadius)),
          height: AppValues.appbarBackButtonSize,
          width: AppValues.appbarBackButtonSize,
          padding: const EdgeInsets.all(AppValues.smallPadding),
          child: SvgPicture.asset(icon),
        ),
      );

  /// Return title widget.
  Widget buildTitleText({required String title, bool isMainTitle = true}) {
    return Text(
      title,
      style: TextStyle(
          fontWeight: FontWeight.w600,
          fontFamily: FontConstants.poppins,
          fontSize: isMainTitle ? 18 : 16,
          color: AppColors.textColorSecondary),
    );
  }

  /// Build sport detail row.
  Widget buildSportsDetailRow() => Hero(
        tag: "sports_detail_${(_controller.postModel.value.index).toString()}",
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 3,
              child: buildPlayerSkillSingleWidget(
                  title: AppString.level,
                  value: _controller.postModel.value.level ?? ""),
            ),
            Expanded(
              flex: 5,
              child: buildPlayerSkillSingleWidget(
                  title: AppString.reference,
                  value: _controller.postModel.value.references ?? ""),
            ),
            Expanded(
              flex: 5,
              child: buildPlayerSkillSingleWidget(
                  title: AppString.skill,
                  value: _controller.postModel.value.skill ?? ""),
            )
          ],
        ),
      );

  /// Build item widget.
  Widget buildItemWidget(
          {String title = "", String icon = "", bool isLast = false}) =>
      Padding(
        padding: EdgeInsets.only(
            right: isLast ? 0 : AppValues.height_20, top: AppValues.height_10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              icon,
              color: AppColors.textColorDarkGray,
              height: AppValues.iconSmallSize,
              width: AppValues.iconSmallSize,
            ),
            const SizedBox(
              width: 4,
            ),
            Flexible(
                child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: textTheme.displaySmall?.copyWith(
                color: AppColors.textColorDarkGray,fontSize: 13
              ),
            )),
          ],
        ),
      );

  /// Build text content.
  Widget buildText() => Hero(
        tag: "desc_${(_controller.postModel.value.index).toString()}",
        child: Text(
          _controller.postModel.value.postDescription ?? "",
          textAlign: TextAlign.start,
          style: textTheme.headlineSmall
              ?.copyWith(color: AppColors.textColorDarkGray,fontSize: 13),
        ),
      );

  /// Build item widget.
  Widget buildPlayerSkillSingleWidget({String value = "", String title = ""}) =>
      Padding(
        padding: const EdgeInsets.only(top: AppValues.height_10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: textTheme.headlineSmall
                    ?.copyWith(color: AppColors.textColorSecondary, fontSize: 13),
              ),
              Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: textTheme.headlineSmall?.copyWith(
                  color: AppColors.textColorDarkGray,fontSize: 13
                ),
              ),
            ],
          ),
        ),
      );
}
