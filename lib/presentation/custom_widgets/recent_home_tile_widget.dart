import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:game_on_flutter/infrastructure/model/club/home/recent_model.dart';
import 'package:game_on_flutter/values/app_icons.dart';
import 'package:game_on_flutter/values/common_utils.dart';
import 'package:get/get.dart';

import '../../values/app_colors.dart';
import '../../values/app_values.dart';
import '../app_widgets/app_like_widget.dart';
import '../app_widgets/app_player_profile_widget.dart';

class RecentHomeTileWidget extends StatelessWidget {
  RecentModel postModel;
  int index;
  Function(RecentModel postModel, int index) onTap;
  Function(int index, RecentModel postModel) onLikeChange;

  RecentHomeTileWidget(
      {required this.postModel,
      required this.onLikeChange,
      required this.index,
      required this.onTap,
      Key? key})
      : super(key: key);

  late TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    const playerIconSize = 55.0;
    return ListTile(
      onTap: () => onTap(postModel, index),
      contentPadding: const EdgeInsets.only(
          left: AppValues.mediumPadding,
          right: AppValues.mediumPadding,
          top: AppValues.mediumPadding,
          bottom: AppValues.padding_6),
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.transparent, width: 1),
          borderRadius: BorderRadius.circular(AppValues.roundedButtonRadius)),
      tileColor: AppColors.appTileBackground,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            AppPlayerProfileWidget(
              profileURL: postModel.playerImage ?? "",
              width: playerIconSize,
              isAssetUrl: false,
              height: playerIconSize,
            ),
            const SizedBox(
              width: AppValues.margin_15,
            ),
            Expanded(child: buildCenterColumn()),
            const SizedBox(
              height: AppValues.margin_10,
            ),
            AppLikeWidget(
              isSelected: postModel.isLiked,
              onChanged: (bool isLiked) {
                onLikeChange(index, postModel);
              },
            )
          ]),
          if ((postModel.playerDescription ?? "").isNotEmpty)
            const SizedBox(
              height: AppValues.radius_12,
            ),
          if ((postModel.playerDescription ?? "").isNotEmpty) buildText(),
          if ((postModel.playerDescription ?? "").isNotEmpty)
            const SizedBox(
              height: AppValues.height_2,
            ),
          Align(alignment: Alignment.topRight, child: buildTextTime())
        ],
      ),
    );
  }

  /// Build center column widget.
  Widget buildCenterColumn() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTextName(),
          const SizedBox(
            height: AppValues.margin_10,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildIconAndNameRow(
                        iconAsset: AppIcons.playerPosition,
                        value: postModel.playerPosition ?? ""),
                    const SizedBox(
                      height: 4,
                    ),
                    buildIconAndNameRow(
                        iconAsset: AppIcons.age,
                        value: postModel.playerAge == 'null'
                            ? ''
                            : '${postModel.playerAge ?? ""} Years'),
                  ],
                ),
              ),
              const SizedBox(
                width: AppValues.margin_50,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildIconAndNameRow(
                        iconAsset: AppIcons.locationIcon,
                        value: postModel.playerDistance ?? ""),
                    const SizedBox(
                      height: AppValues.height_4,
                    ),
                    buildIconAndNameRow(
                        iconSize: postModel.isMale
                            ? AppValues.height_14
                            : AppValues.height_16,
                        iconAsset: postModel.isMale
                            ? AppIcons.iconMale
                            : AppIcons.iconFemale,
                        value: postModel.gender ?? ""),
                  ],
                ),
              ),
            ],
          ),
        ],
      );

  /// build player details
  Widget buildIconAndNameRow(
      {required String iconAsset,
      required String value,
      double iconSize = 14}) {
    return Row(
      children: [
        SvgPicture.asset(
          width: iconSize,
          height: iconSize,
          iconAsset,
        ),
        SizedBox(
          width: iconSize == AppValues.height_14 ? 4 : 2,
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
                color: AppColors.textColorWhiteDescription.withOpacity(0.8),
                fontSize: 13),
          ),
        ),
      ],
    );
  }

  /// Build text name
  Widget buildTextName() => Text(
        postModel.playerName ?? "",
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        style: textTheme.bodyMedium?.copyWith(
            color: AppColors.textColorSecondary,
            fontWeight: FontWeight.w500,
            fontSize: 15),
      );

  /// Build text content.
  Widget buildText() => Text(
        postModel.playerDescription ?? "",
        textAlign: TextAlign.start,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: textTheme.bodySmall?.copyWith(
            color: AppColors.textColorWhiteDescription.withOpacity(0.8),
            fontSize: 13),
      );

  /// Build text content.
  Widget buildTextTime() => Text(
        CommonUtils.getRemainingDaysInWord(postModel.date ?? "")
                .capitalizeFirst ??
            "",
        textAlign: TextAlign.start,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style:
            textTheme.bodySmall?.copyWith(color: AppColors.textColorDarkGray),
      );
}
