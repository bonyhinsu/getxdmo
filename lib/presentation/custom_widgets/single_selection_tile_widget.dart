import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_checkbox_widget.dart';
import 'package:game_on_flutter/values/app_colors.dart';
import 'package:game_on_flutter/values/app_icons.dart';
import 'package:game_on_flutter/values/app_values.dart';

import '../../infrastructure/model/club/signup/selection_model.dart';

class SingleSelectionTileWidget extends StatelessWidget {
  SelectionModel model;
  Function(SelectionModel model) onSelectTile;
  Function(SelectionModel model, int index)? onInfoClick;
  bool enableInfo;
  int index;

  SingleSelectionTileWidget(
      {required this.model,
      required this.onSelectTile,
      this.onInfoClick,
      this.enableInfo = false,
      Key? key,
      this.index = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListTile(
      minVerticalPadding: 0,
      enabled: model.isEnabled,
      contentPadding: const EdgeInsets.symmetric(
          vertical: AppValues.padding_4, horizontal: AppValues.mediumPadding),
      shape: RoundedRectangleBorder(
          side: BorderSide(
              color: model.isSelected
                  ? AppColors.appWhiteButtonColor
                  : Colors.transparent,
              width: 1),
          borderRadius: BorderRadius.circular(AppValues.roundedButtonRadius)),
      tileColor: model.isSelected
          ? AppColors.appWhiteButtonColor.withOpacity(0.2)
          : AppColors.appWhiteButtonColor.withOpacity(0.1),
      onTap: () => onSelectTile(model),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            model.title ?? "",
            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
          ),
          if (enableInfo && (model.description ?? "").isNotEmpty)
            InkWell(
              onTap: () {
                if (onInfoClick != null) {
                  onInfoClick!(model, index);
                }
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppValues.margin_10),
                child: SvgPicture.asset(AppIcons.infoRoundIcon),
              ),
            )
        ],
      ),
      leading: model.icon != null
          ? model.isPng
              ? (model.icon ?? "").contains('.svg')
                  ? SvgPicture.network(model.icon ?? "",width: AppValues.iconDefaultSize,height: AppValues.iconDefaultSize,)
                  : Image.network(model.icon ?? "",width: AppValues.iconDefaultSize,height: AppValues.iconDefaultSize,)
              : null
          : null,
      minLeadingWidth: 30,
      trailing: AppCheckboxWidget(
        isSelected: model.isSelected,
        onSelected: (bool isSelected) => onSelectTile(model),
      ),
    );
  }
}
