import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_on_flutter/infrastructure/model/common/app_fields.dart';

import '../../infrastructure/utils/line_painter.dart';
import '../../values/app_colors.dart';
import '../../values/app_images.dart';
import '../../values/app_values.dart';
import 'app_shimmer.dart';

class EventImageWidget extends StatelessWidget {
  String profileURL;
  bool isAssetUrl;
  double width;
  double? height;

  EventImageWidget(
      {required this.profileURL,
      this.isAssetUrl = false,
      this.width = double.infinity,
      this.height = null,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
            color: AppColors.inputFieldBorderColor,
            borderRadius: BorderRadius.circular(AppValues.smallRadius)),
        child: profileURL.isNotEmpty
            ? !isAssetUrl
                ? clubIcon
                : assetClubIcon
            : blankClubIcon);
  }

  /// player blank icon.
  Container get blankClubIcon => Container(
    width: width,
    height: height,
     decoration: BoxDecoration(
       borderRadius: BorderRadius.circular(8),
       color: AppColors.choiceUnselectedColor
     ),
    child: Stack(
      fit: StackFit.expand,
      children: [
        CustomPaint(painter: LinePainter()),
        const Center(child: Text('Banner not available')),
      ],
    ),
  );

  /// player asset icon.
  Image get assetClubIcon => Image.asset(
        profileURL,
        fit: BoxFit.cover,
        width: width,
        height: height,
      );

  /// Cache network image for player.
  CachedNetworkImage get clubIcon => CachedNetworkImage(
        imageUrl: "${AppFields.instance.imagePrefix}$profileURL",
        width: width,
        fit: BoxFit.fitWidth,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            AppShimmer(child: blankClubIcon),
        errorWidget: (context, url, error) => blankClubIcon,
      );
}
