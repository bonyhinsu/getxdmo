import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_on_flutter/values/common_utils.dart';

import '../../values/app_colors.dart';
import '../../values/app_icons.dart';
import '../../values/app_string.dart';
import '../../values/app_values.dart';
import '../screens/club/signup/club_board_members/controllers/club_board_members.controller.dart';
import '../screens/club/signup/club_board_members/model/club_member_model.dart';

class CoachTileWidget extends StatelessWidget {
  int index;
  bool swipeToDeleteEnable;
  bool requireRole;
  ClubMemberModel model;
  Function(ClubMemberModel model) onCallClick;
  Function(ClubMemberModel model) onMessageClick;
  Function(ClubMemberModel model, int index) onEditMember;
  Function(ClubMemberModel model, int index) onDeleteMember;
  Future<bool> Function(ClubMemberModel model, int index)? onSwipeToDelete;

  CoachTileWidget(
      {required this.model,
      required this.index,
      required this.onCallClick,
      required this.onMessageClick,
      required this.onEditMember,
      required this.onDeleteMember,
      this.onSwipeToDelete,
      this.swipeToDeleteEnable = false,
      this.requireRole = false,
      Key? key})
      : super(key: key);

  late TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return Slidable(
      enabled: swipeToDeleteEnable,
      key: const ValueKey(0),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        dragDismissible: false,
        extentRatio: 0.30,
        children: [
          CustomSlidableAction(
              autoClose: true,
              onPressed: onEditClick,
              padding: const EdgeInsets.only(left: 8),
              backgroundColor: Colors.transparent,
              child: buildEditIcon()),
          CustomSlidableAction(
              autoClose: true,
              onPressed: onDeleteClick,
              padding: const EdgeInsets.only(left: 4, right: 0),
              backgroundColor: Colors.transparent,
              child: buildDeleteIcon()),
        ],
      ),
      child: buildBody(),
    );
  }

  /// ON edit member
  void onEditClick(BuildContext context) => onEditMember(model, index);

  /// on delete member.
  void onDeleteClick(BuildContext context) => onDeleteMember(model, index);

  Widget buildBody() => Container(
        decoration: BoxDecoration(
            color: AppColors.textColorSecondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppValues.smallRadius)),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2),
                decoration: BoxDecoration(
                    color: AppColors.appRedButtonColor.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(AppValues.smallRadius),
                        bottomRight: Radius.circular(AppValues.smallRadius))),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      AppIcons.iconDefence,
                      width: AppValues.size_14,
                      height: AppValues.size_14,
                      color: AppColors.appRedButtonColor,
                    ),
                    const SizedBox(
                      width: AppValues.height_4,
                    ),
                    Flexible(
                      child: Text(
                        model.role ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.displaySmall
                            ?.copyWith(color: AppColors.appRedButtonColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppValues.mediumPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              model.gender == 2
                                  ? AppIcons.iconFemale
                                  : AppIcons.iconMale,
                              width: AppValues.size_14,
                              height: AppValues.size_14,
                              color: AppColors.appRedButtonColor,
                            ),
                            const SizedBox(
                              width: AppValues.height_6,
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      maxLines: 1,
                                      model.userName ?? "",
                                      style: textTheme.displaySmall?.copyWith(
                                          color: AppColors.textColorSecondary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: AppValues.margin_4,
                                  ),
                                  Text(
                                    maxLines: 1,
                                    '(${model.totalExperience ?? ""} Exp.)',
                                    style: textTheme.displaySmall?.copyWith(
                                        color: AppColors.textColorSecondary
                                            .withOpacity(0.50),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            // Expanded(
                            //   child: EasyRichText(
                            //       '${model.userName ?? ""} (${model.totalExperience ?? ""} Exp.)',
                            //       maxLines: 2,
                            //       defaultStyle: textTheme.displaySmall
                            //           ?.copyWith(
                            //               color: AppColors.textColorSecondary,
                            //               fontWeight: FontWeight.w500),
                            //       patternList: [
                            //         EasyRichTextPattern(
                            //           targetString: '(${model.totalExperience ?? ""} Exp.)',
                            //           hasSpecialCharacters: true,
                            //           style: textTheme.displaySmall?.copyWith(
                            //               color: AppColors.textColorSecondary
                            //                   .withOpacity(0.50),
                            //               fontWeight: FontWeight.w500),
                            //         ),
                            //       ]),
                            // ),
                          ],
                        ),
                        const SizedBox(
                          height: AppValues.height_10,
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              AppIcons.calenderIcon,
                              width: AppValues.size_14,
                              height: AppValues.size_14,
                              color: AppColors.appRedButtonColor,
                            ),
                            const SizedBox(
                              width: AppValues.height_8,
                            ),
                            Flexible(
                              child: Text(
                                CommonUtils.ddmmmyyyyDateWithTimezone(model.dateOfBirth ?? ""),
                                style: textTheme.displaySmall?.copyWith(
                                    color: AppColors.textColorSecondary,
                                    fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                buildCallWidget(),
                buildMessageWidget()
              ],
            ),
          ],
        ),
      );

  /// Call Widget
  Widget buildCallWidget() {
    return IconButton(
      onPressed: () => onCallClick(model),
      icon: SvgPicture.asset(AppIcons.iconCall),
    );
  }

  /// Message widget
  Widget buildMessageWidget() {
    return IconButton(
      onPressed: () => onMessageClick(model),
      icon: SvgPicture.asset(AppIcons.iconMessage),
    );
  }

  /// Edit icon.
  Widget buildEditIcon() => Container(
        height: 46,
        width: 46,
        padding: const EdgeInsets.all(AppValues.mediumPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppValues.smallRadius),
          color: AppColors.textColorSecondary.withOpacity(0.1),
        ),
        child: SvgPicture.asset(
          AppIcons.iconEdit,
        ),
      );

  /// Delete icon.
  Widget buildDeleteIcon() => Container(
        height: 46,
        width: 46,
        padding: const EdgeInsets.all(AppValues.mediumPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppValues.smallRadius),
          color: AppColors.appRedButtonColor.withOpacity(0.2),
        ),
        child: SvgPicture.asset(
          AppIcons.iconDelete,
        ),
      );
}
