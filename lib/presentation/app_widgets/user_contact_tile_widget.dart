import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:game_on_flutter/values/app_colors.dart';
import 'package:game_on_flutter/values/app_icons.dart';
import 'package:game_on_flutter/values/app_values.dart';

import '../screens/club/signup/club_board_members/controllers/club_board_members.controller.dart';
import '../screens/club/signup/club_board_members/model/club_member_model.dart';

class UserContactTileWidget extends StatelessWidget {
  int index;
  bool swipeToDeleteEnable;
  bool enableDelete;
  bool requireRole;
  ClubMemberModel model;
  Function(ClubMemberModel model) onCallClick;
  Function(ClubMemberModel model) onMessageClick;
  Function(ClubMemberModel model, int index) onEditMember;
  Function(ClubMemberModel model, int index) onDeleteMember;
  Future<bool> Function(ClubMemberModel model, int index)? onSwipeToDelete;

  UserContactTileWidget(
      {required this.model,
      required this.index,
      required this.onCallClick,
      required this.onMessageClick,
      required this.onEditMember,
      required this.onDeleteMember,
      this.onSwipeToDelete,
      this.swipeToDeleteEnable = false,
      this.enableDelete = true,
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
        extentRatio: enableDelete?0.30:0.15,
        children: [
          CustomSlidableAction(
              onPressed: onEditClick,
              autoClose: true,
              padding: const EdgeInsets.only(left: 8),
              backgroundColor: Colors.transparent,
              child: buildEditIcon()),
          if(enableDelete)
          CustomSlidableAction(
              onPressed:onDeleteClick,
              autoClose: true,
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
        height: 46,
        decoration: BoxDecoration(
            color: AppColors.textColorSecondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppValues.smallRadius)),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppValues.mediumPadding),
                child: Row(
                  children: [
                    Text(
                      model.userName ?? "",
                      style: textTheme.displaySmall?.copyWith(
                          color: AppColors.textColorSecondary.withOpacity(0.50),fontSize: 13),
                    ),
                    if(requireRole)
                    Flexible(
                      child: Text(
                         " (${model.role??""})",
                        style: textTheme.displaySmall?.copyWith(
                            color: AppColors.textColorSecondary.withOpacity(0.50)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            buildCallWidget(),
            buildMessageWidget()
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
          color: enableDelete?AppColors.appRedButtonColor.withOpacity(0.2):AppColors.appRedButtonColorDisable2.withOpacity(0.2),
        ),
        child: SvgPicture.asset(
          AppIcons.iconDelete,
        ),
      );
}
