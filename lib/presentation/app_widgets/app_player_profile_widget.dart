import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../../infrastructure/model/common/app_fields.dart';
import '../../values/app_colors.dart';
import '../../values/app_images.dart';
import '../../values/app_values.dart';
import 'app_shimmer.dart';

class AppPlayerProfileWidget extends StatelessWidget {
  String profileURL;
  bool isAssetUrl;
  double width;
  double height;

  AppPlayerProfileWidget(
      {required this.profileURL,
      this.isAssetUrl = false,
      this.width = 40,
      this.height = 40,
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
            borderRadius: BorderRadius.circular(AppValues.fullRadius)),
        child: profileURL.isNotEmpty
            ? !isAssetUrl
                ? clubIcon
                : assetClubIcon
            : blankClubIcon);
  }

  /// player blank icon.
  SvgPicture get blankClubIcon => SvgPicture.asset(
        AppImages.noPlayerImage,
        width: width,
        height: height,
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
        imageUrl: '${AppFields.instance.imagePrefix}$profileURL',
        width: width,
        height: height,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            AppShimmer(child: blankClubIcon),
        errorWidget: (context, url, error) => blankClubIcon,
      );
}
