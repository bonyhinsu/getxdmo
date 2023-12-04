import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_on_flutter/infrastructure/model/common/app_fields.dart';
import 'package:get/get.dart';

import '../../infrastructure/model/club/home/club_list_model.dart';
import '../../values/app_colors.dart';
import '../../values/app_icons.dart';
import '../../values/app_values.dart';
import '../../values/common_utils.dart';
import '../app_widgets/app_like_widget.dart';
import '../app_widgets/club_profile_widget.dart';

class FavouriteClubTileWidget extends StatelessWidget {
  ClubListModel postModel;
  int index;
  Function(ClubListModel postModel, int index) onTap;
  Function(int index, ClubListModel postModel) onLikeChange;

  FavouriteClubTileWidget(
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
    const playerIconSize = 64.0;
    return ListTile(
      onTap: () => onTap(postModel, index),
      contentPadding: const EdgeInsets.only(
          left: AppValues.mediumPadding,
          right: AppValues.mediumPadding,
          top: AppValues.mediumPadding,
          bottom: AppValues.padding_4),
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.transparent, width: 1),
          borderRadius: BorderRadius.circular(AppValues.roundedButtonRadius)),
      tileColor: AppColors.appTileBackground,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ClubProfileWidget(
              isAssetUrl: false,
              profileURL: postModel.clubLogo ?? "",
              width: playerIconSize,
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
            height: AppValues.margin_4,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildIconAndNameRow(
                        iconAsset: AppIcons.playerPosition,
                        value: postModel.position ?? ""),
                    const SizedBox(
                      height: 4,
                    ),
                    buildIconAndNameRow(
                        iconAsset: AppIcons.levelIcon,
                        value: postModel.level ?? ""),
                  ],
                ),
              ),
              const SizedBox(
                width: AppValues.margin_8,
              ),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildDynamicIconAndNameRow(
                          logo: postModel.sportLogo ?? "",
                          value: postModel.sports ?? ""),
                      const SizedBox(
                        height: AppValues.height_4,
                      ),
                      buildIconAndNameRow(
                          iconAsset: AppIcons.locationIcon,
                          value: postModel.location ?? ""),
                    ]),
              ),
            ],
          ),
        ],
      );

  /// build player details
  Widget buildIconAndNameRow(
      {required String iconAsset,
      required String value,
      double iconSize = 14,
      bool isImageAsset = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        isImageAsset
            ? Container(
                width: iconSize,
                height: iconSize,
                padding: const EdgeInsets.all(1.0),
                child: Image.asset(
                  iconAsset,
                ),
              )
            : SvgPicture.asset(
                width: iconSize,
                height: iconSize,
                iconAsset,
              ),
        SizedBox(
          width: iconSize == AppValues.height_14 ? 8 : 2,
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            style: textTheme.displaySmall?.copyWith(
                color: AppColors.textColorPrimary.withOpacity(0.8),
                fontSize: 13),
          ),
        ),
      ],
    );
  }

  /// build player details
  Widget buildDynamicIconAndNameRow({
    required String logo,
    required String value,
    double iconSize = 14,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: iconSize,
          height: iconSize,
          padding: const EdgeInsets.all(1.0),
          child: Image.network(
            "${AppFields.instance.imagePrefix}$logo",
          ),
        ),
        SizedBox(
          width: iconSize == AppValues.height_14 ? 8 : 2,
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            style: textTheme.displaySmall?.copyWith(
                color: AppColors.textColorPrimary.withOpacity(0.8), fontSize: 13),
          ),
        ),
      ],
    );
  }

  /// Build text name
  Widget buildTextName() => Text(
        postModel.clubName ?? "",
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        style: textTheme.bodyMedium?.copyWith(
            color: AppColors.textColorWhite,
            fontWeight: FontWeight.w500,
            fontSize: 15),
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

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
