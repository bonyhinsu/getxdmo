import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_on_flutter/presentation/custom_widgets/post_edit_menu_widget.dart';
import 'package:game_on_flutter/values/app_icons.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:game_on_flutter/values/app_values.dart';
import 'package:game_on_flutter/values/common_utils.dart';
import 'package:get/get.dart';

import '../../infrastructure/model/club/post/post_model.dart';
import '../../values/app_colors.dart';
import '../app_widgets/club_profile_widget.dart';

class PostClubDetailWidget extends StatelessWidget {
  PostModel postModel;
  Function() onEdit;
  Function() onDelete;
  Function() onClubClick;
  TextEditingController searchController = TextEditingController();
  final GlobalKey<PopupMenuButtonState<int>> _key = GlobalKey();

  PostClubDetailWidget(
      {required this.postModel,
      required this.onEdit,
      required this.onDelete,
      required this.onClubClick,
      Key? key})
      : super(key: key);

  late TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(top: AppValues.margin_10),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onClubClick(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildLogoWidget(),
                  size10,
                  buildClubDetailColumn(),
                ],
              ),
            ),
          ),
          PostEditMenuWidget(
            onDelete: onDelete,
            onEdit: onEdit,
          ),
        ],
      ),
    );
  }

  /// Build margin 10.
  Widget get size10 => const SizedBox(
        width: AppValues.margin_10,
      );

  /// Build logo widget.
  Widget buildLogoWidget() => ClubProfileWidget(
        width: AppValues.size_30,
        height: AppValues.size_30,
        profileURL: postModel.clubLogo ?? "",
      );

  /// Build club detail column.
  Widget buildClubDetailColumn() => Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              postModel.clubName ?? "",
              style: textTheme.displaySmall,
            ),
            Text(
              CommonUtils.getRemainingDaysInWord(postModel.postDate ?? "", isUTC: true),
              style: textTheme.headlineSmall
                  ?.copyWith(color: AppColors.textColorDarkGray),
            ),
          ],
        ),
      );

  /// Build post option icon
  Widget buildPostOptions() => Container(
        padding: const EdgeInsets.only(left: AppValues.margin_10),
        child: Theme(
          data: Theme.of(Get.context!).copyWith(
            dividerTheme: const DividerThemeData(
                color: AppColors.textColorDarkGray,
                thickness: 0.5,
                space: 0.5,
                indent: 0),
          ),
          child: PopupMenuButton<int>(
            key: _key,
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
