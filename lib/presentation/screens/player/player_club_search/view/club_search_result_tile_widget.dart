import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_on_flutter/infrastructure/model/club/post/post_model.dart';
import 'package:game_on_flutter/presentation/app_widgets/club_profile_widget.dart';
import 'package:game_on_flutter/values/app_colors.dart';

import '../../../../../infrastructure/model/club/home/club_list_model.dart';
import '../../../../../infrastructure/model/player/search_club/search_club_response_model.dart';
import '../../../../../values/app_icons.dart';
import '../../../../../values/app_values.dart';

class ClubSearchResultTileWidget extends StatelessWidget {
  SearchClubResponseModelData model;
  late TextTheme textTheme;
  Function(SearchClubResponseModelData model) onUserClick;

  ClubSearchResultTileWidget(
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
          ClubProfileWidget(
            profileURL: model.profileImage ?? "",
            height: AppValues.size_30,
            width: AppValues.size_30,
          ),
          const SizedBox(
            width: AppValues.size_15,
          ),
          Expanded(
            child: Text(
              model.name ?? "",
              style: textTheme.headlineSmall?.copyWith(
                color: AppColors.textColorDarkGray,
                fontWeight: FontWeight.w600
              ),
            ),
          ),
          SvgPicture.asset(AppIcons.arrowIcon,color: AppColors.textColorDarkGray,)
        ],
      ),
    );
  }
}
