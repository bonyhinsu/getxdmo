import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_player_profile_widget.dart';
import 'package:game_on_flutter/values/app_colors.dart';
import 'package:game_on_flutter/values/app_icons.dart';
import 'package:game_on_flutter/values/app_values.dart';

import '../../infrastructure/model/club/home/recent_model.dart';

class UserSearchResultTileWidget extends StatelessWidget {
  RecentModel model;
  late TextTheme textTheme;
  Function(RecentModel model) onUserClick;

  UserSearchResultTileWidget(
      {required this.model, required this.onUserClick, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return ListTile(
      onTap: () => onUserClick(model),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: AppValues.padding_16),
      title: Row(
        children: [
          AppPlayerProfileWidget(
            profileURL: model.playerImage ?? "",
            height: AppValues.size_30,
            width: AppValues.size_30,
          ),
          const SizedBox(
            width: AppValues.size_15,
          ),
          Expanded(
            child: Text(
              model.playerName ?? "",
              style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700,color: AppColors.textColorDarkGray),
            ),
          ),
          SvgPicture.asset(AppIcons.arrowIcon, color: AppColors.textColorDarkGray,)
        ],
      ),
    );
  }
}
