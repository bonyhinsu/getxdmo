import 'package:flutter/material.dart';
import 'package:game_on_flutter/infrastructure/model/club/home/club_list_model.dart';
import 'package:game_on_flutter/presentation/app_widgets/club_profile_widget.dart';

import '../../values/app_colors.dart';
import '../../values/app_font_size.dart';
import '../app_widgets/app_square_checkbox_widget.dart';

class ClubSelectionTileWidget extends StatelessWidget {
  ClubListModel model;
  int index;
  bool enableCheckbox;

  Function(int index, bool isSelected) onChange;

  ClubSelectionTileWidget(
      {required this.model,
      required this.index,
      required this.onChange,
      this.enableCheckbox = true,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
            contentPadding: EdgeInsets.zero,
            title: buildTitleWidget(),
            enableFeedback: true,
            onTap: () =>
                enableCheckbox ? onChange(index, !model.isSelected) : {},
            trailing: enableCheckbox
                ? AppSquareCheckboxWidget(
                    isSelected: model.isSelected,
                    onSelected: (bool isSelected) =>
                        onChange(index, !model.isSelected),
                  )
                : null,
          );
  }

  /// Build title widget
  Widget buildTitleWidget() => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClubProfileWidget(
              profileURL: model.clubLogo ?? "", isAssetUrl: false),
          const SizedBox(width: 8.0),
          Text(
            model.clubName ?? "",
            style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontFamily: FontConstants.poppins,
                fontSize: 13,
                color: AppColors.textColorDarkGray),
          )
        ],
      );
}
