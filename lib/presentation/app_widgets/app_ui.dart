import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_on_flutter/values/app_colors.dart';

class AppUI {
  Widget chatLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget typingLoadingIndicator() {
    return const SizedBox(
      height: 10,
      child: Text("Typing..."),
    );
  }

  Widget noChatsUI() {
    return Container();
  }

  /// Builds user image from url.
  static Widget loadUserImageFromNetWork(
      {required String url,
      double width = double.infinity,
      double height = double.infinity,
      BoxFit fit = BoxFit.cover,
      double iconSize = double.infinity,
      Color iconColor = Colors.black}) {
    return url.isEmpty
        ? SvgPicture.asset(
            "",
            height: iconSize,
            width: iconSize,
            fit: fit,
          )
        : CachedNetworkImage(
            imageUrl: url,
            height: height,
            width: width,
            fit: fit,
            errorWidget: (ctx, url, error) {
              return SvgPicture.asset(
                "SVGConstants.USER_PLACEHOLDER",
                height: iconSize,
                width: iconSize,
                fit: fit,
              );
            },
            placeholder: (context, url) {
              return SvgPicture.asset(
                "assets/images/user_profile.png",
                height: iconSize,
                width: iconSize,
                fit: fit,
              );
            },
          );
  }

  /// Builds image from url
  static Widget loadChatImageFromNetWork(
      {required String url,
      BoxFit fit = BoxFit.fitWidth,
      double iconSize = 44.0,
      Color iconColor = Colors.black}) {
    return url.isEmpty
        ? Image.asset(
            "assets/images/user_profile.png",
            width: double.infinity,
          )
        : CachedNetworkImage(
            imageUrl: "AppFieldConstant.instance.useProfileImagePath}url",
            errorWidget: (ctx, url, error) {
              return Image.asset(
                "assets/images/user_profile.png",
                width: 34,
                height: 34,
              );
            },
            fadeOutDuration: const Duration(seconds: 1),
            fadeInDuration: const Duration(seconds: 1),
            placeholder: (context, url) {
              return SizedBox(
                height: 150,
                width: 150,
                child: Center(
                    child: SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: iconColor,
                          strokeWidth: 2,
                        ))),
              );
            },
          );
  }
}
