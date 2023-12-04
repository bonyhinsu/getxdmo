import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../infrastructure/model/club/post/post_model.dart';
import '../../values/app_colors.dart';
import '../../values/app_icons.dart';
import '../../values/app_values.dart';
import '../../values/common_utils.dart';
import '../app_widgets/club_profile_widget.dart';

class PostClubDetailSharableWidget extends StatelessWidget {
  PostModel postModel;
  Function(PostModel postModel) onShare;
  TextEditingController searchController = TextEditingController();
  double topMargin;
  Function() onClubClick;

  PostClubDetailSharableWidget(
      {required this.postModel,
      required this.onShare,
      required this.onClubClick,
      this.topMargin = AppValues.margin_10,
      Key? key})
      : super(key: key);

  late TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return Container(
      margin: EdgeInsets.only(top: topMargin),
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
          buildPostOptions()
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
  Widget buildPostOptions() => InkWell(
        onTap: () => onShare(postModel),
        child: Container(
          padding: const EdgeInsets.only(
              left: AppValues.margin_20,
              top: AppValues.height_6,
              bottom: AppValues.height_6),
          child: SvgPicture.asset(
            AppIcons.iconShare,
          ),
        ),
      );
}
