import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_shimmer.dart';

import '../../values/app_images.dart';

class AppImageWidget extends StatelessWidget {
  double containerSize;

  bool isFileImagePath;

  String imagePath;

  BoxFit fit;

  AppImageWidget(
      {this.containerSize = 50,
      this.isFileImagePath = false,
      this.fit = BoxFit.cover,
      required this.imagePath,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isFileImagePath ? getAssetImage : networkImage;
  }

  ///Image widget from file image
  Widget get getAssetImage => Image.file(File(imagePath));

  /// Load image from network using placeholder.
  Widget get networkImage => CachedNetworkImage(
        imageUrl: imagePath,
        fit: fit,
        placeholder: (context, url) => SizedBox(
          height: containerSize,
          width: containerSize,
          child: AppShimmer(
            child: Container(
              height: containerSize,
              width: containerSize,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
        ),
        errorWidget: (context, url, error) => SizedBox(
          height: containerSize,
          width: containerSize,
          child: SvgPicture.asset(
            (AppImages.authenticationPlaceholder),
          ),
        ),
      );
}
