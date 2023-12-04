import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_on_flutter/presentation/custom_widgets/post_club_detail_sharable_widget.dart';
import 'package:game_on_flutter/presentation/custom_widgets/post_club_detail_widget.dart';
import 'package:game_on_flutter/values/app_icons.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:get/get.dart';

import '../../infrastructure/model/club/post/post_model.dart';
import '../../values/app_colors.dart';
import '../../values/app_values.dart';

class OpenPositionTileWidget extends StatelessWidget {
  PostModel postModel;
  Function(PostModel postModel, int index) onEdit;
  Function(PostModel postModel, int index) onDelete;
  Function(PostModel postModel) onPostClick;
  Function(PostModel postModel, int index) onClubClick;
  bool postShareEnable;
  int index;
  Function(PostModel postModel)? onShare;

  OpenPositionTileWidget(
      {required this.postModel,
      required this.onEdit,
      required this.onDelete,
      required this.onPostClick,
      required this.onClubClick,
      this.onShare,
      required this.index,
      this.postShareEnable = false,
      Key? key})
      : super(key: key);

  late TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return ListTile(
      onTap: () => onPostClick(postModel),
      contentPadding: const EdgeInsets.only(
          left: AppValues.mediumPadding,
          right: AppValues.mediumPadding,
          top: AppValues.mediumPadding,
          bottom: AppValues.padding_6),
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.transparent, width: 1),
          borderRadius: BorderRadius.circular(AppValues.roundedButtonRadius)),
      tileColor: AppColors.textColorSecondary.withOpacity(0.1),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildPlayerPositionText(),
          buildPersonalDetailRow(),
          buildSportsDetailRow(),
          const SizedBox(
            height: AppValues.height_10,
          ),
          if ((postModel.postDescription ?? "").isNotEmpty) buildText(),
          const SizedBox(
            height: AppValues.height_10,
          ),
          Divider(
            color: AppColors.textColorSecondary.withOpacity(0.2),
            height: 1,
          ),
          !postShareEnable
              ? PostClubDetailWidget(
                  postModel: postModel,
                  onClubClick: () => onEdit(postModel, index),
                  onEdit: () => onEdit(postModel, index),
                  onDelete: () => onDelete(postModel, index),
                )
              : PostClubDetailSharableWidget(
                  topMargin: AppValues.height_8,
                  onClubClick: () => onEdit(postModel, index),
                  postModel: postModel,
                  onShare: onShare!,
                ),
        ],
      ),
    );
  }

  /// Build player position text.
  Widget buildPlayerPositionText() => Text(
        postModel.positionName ?? "",
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: textTheme.displayLarge?.copyWith(fontSize: 15),
      );

  /// Build personal detail row.
  Widget buildPersonalDetailRow() => Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          buildItemWidget(icon: AppIcons.age, title: '${postModel.age} years'),
          buildItemWidget(
              icon: (postModel.gender.toLowerCase() == 'male')
                  ? AppIcons.iconMale
                  : AppIcons.iconFemale,
              title: postModel.gender.capitalizeFirst ?? ""),
          Expanded(
              child: buildItemWidget(
                  icon: AppIcons.locationIcon,
                  title: postModel.location ?? "",
                  isLast: true))
        ],
      );

  /// Build sport detail row.
  Widget buildSportsDetailRow() => Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 3,
            child: buildPlayerSkillSingleWidget(
                title: AppString.level, value: postModel.level),
          ),
          Expanded(
            flex: 5,
            child: buildPlayerSkillSingleWidget(
                title: AppString.reference, value: postModel.references),
          ),
          Expanded(
            flex: 5,
            child: buildPlayerSkillSingleWidget(
                title: AppString.skill, value: postModel.skill),
          )
        ],
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
                color: AppColors.textColorDarkGray,
              ),
            )),
          ],
        ),
      );

  /// Build text content.
  Widget buildText() => Text(
        postModel.postDescription ?? "",
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.start,
        style: textTheme.headlineSmall?.copyWith(
            color: AppColors.textColorWhiteDescription.withOpacity(0.8),
            fontSize: 13),
      );

  /// Build item widget.
  Widget buildPlayerSkillSingleWidget({String value = "", String title = ""}) =>
      Padding(
        padding: const EdgeInsets.only(top: AppValues.height_10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: textTheme.headlineSmall
                  ?.copyWith(color: AppColors.textColorSecondary, fontSize: 12),
            ),
            Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: textTheme.headlineSmall?.copyWith(
                color: AppColors.textColorDarkGray,
              ),
            ),
          ],
        ),
      );
}
