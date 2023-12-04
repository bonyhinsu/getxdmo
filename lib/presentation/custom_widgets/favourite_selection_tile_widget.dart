import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';

import '../../infrastructure/model/player/favourite/favourite_type_model.dart';
import '../../values/app_colors.dart';
import '../../values/app_icons.dart';
import '../../values/app_values.dart';
import '../app_widgets/app_square_checkbox_widget.dart';

class FavouriteSelectionTileWidget extends StatelessWidget {
  FavouriteTypeModel model;

  int index = -1;
  bool swipeToDeleteEnable;
  Function(FavouriteTypeModel model, int index) onChange;
  Function(FavouriteTypeModel model, int index) onEditMember;
  Function(FavouriteTypeModel model, int index) onDeleteMember;

  FavouriteSelectionTileWidget({
    required this.model,
    required this.index,
    required this.onChange,
    required this.onEditMember,
    required this.onDeleteMember,
    this.swipeToDeleteEnable = false,
  });

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
        extentRatio: 0.36,
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
              padding: const EdgeInsets.only(left: 8, right: 0),
              backgroundColor: Colors.transparent,
              child: buildDeleteIcon()),
        ],
      ),
      child: buildBody(),
    );
  }

  Widget buildBody() => InkWell(
        onTap: () => onChange(model, index),
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: AppValues.height_10, vertical: AppValues.height_14),
          decoration: BoxDecoration(
              color: AppColors.textColorSecondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppValues.smallRadius)),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  model.title,
                  maxLines: 1,
                  style: textTheme.displaySmall?.copyWith(fontSize: 13),
                ),
              ),
              AppSquareCheckboxWidget(
                isSelected: model.isSelected,
                onSelected: (bool isSelected) => onChange(model, index),
              ),
            ],
          ),
        ),
      );

  /// ON edit member
  void onEditClick(BuildContext context) => onEditMember(model, index);

  /// on delete member.
  void onDeleteClick(BuildContext context) => onDeleteMember(model, index);

  /// Edit icon.
  Widget buildEditIcon() => Container(
        height: 56,
        width: 56,
        padding: const EdgeInsets.all(AppValues.padding_18),
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
        height: 56,
        width: 56,
        padding: const EdgeInsets.all(AppValues.padding_18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppValues.smallRadius),
          color: AppColors.appRedButtonColor.withOpacity(0.2),
        ),
        child: SvgPicture.asset(
          AppIcons.iconDelete,
        ),
      );
}
