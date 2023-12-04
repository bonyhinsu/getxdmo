import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:game_on_flutter/values/app_icons.dart';
import 'package:game_on_flutter/values/common_utils.dart';

import '../../../../../values/app_colors.dart';
import '../../../../../values/app_string.dart';
import '../../../../../values/app_values.dart';

class ClubDetailVideoContainer extends StatelessWidget {
  String thumbnailURL;
  Function() onVideoClick;

  ClubDetailVideoContainer(
      {required this.thumbnailURL, required this.onVideoClick, Key? key})
      : super(key: key);

  /// text theme
  late TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => onVideoClick(),
      child: Padding(
        padding: const EdgeInsets.only(
            left: AppValues.padding_4,
            top: AppValues.height_8,
            right: AppValues.padding_4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [_buildClubUserActionButtonRow(), _buildVideoView()],
        ),
      ),
    );
  }

  /// build club action button row.
  Widget _buildClubUserActionButtonRow() => Padding(
        padding: const EdgeInsets.only(top: AppValues.height_16),
        child: _buildTitle(),
      );

  /// build title button.
  Widget _buildTitle() => Text(
        AppString.video,
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        style:
            textTheme.headlineMedium?.copyWith(color: AppColors.textColorWhite),
      );

  /// Build video view.
  Widget _buildVideoView() {
    final videoImage = CommonUtils.getYoutubeVideoThumbnail(thumbnailURL);
    return Container(
      height: videoImage.isNotEmpty ? 170 : 100,
      margin: const EdgeInsets.only(top: AppValues.height_6),
      width: double.infinity,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(AppValues.radius)),
      child: videoImage.isNotEmpty
          ? Stack(
              fit: StackFit.expand,
              children: [
                FittedBox(
                    fit: BoxFit.fill,
                    child: Image.network(
                      videoImage,
                      fit: BoxFit.fill,
                    )),
                Center(child: SvgPicture.asset(AppIcons.videoPlayIcon))
              ],
            )
          : Center(
              child: Text(AppString.noVideoAvailable,
                  style: textTheme.displaySmall
                      ?.copyWith(color: AppColors.textColorTernary))),
    );
  }
}
