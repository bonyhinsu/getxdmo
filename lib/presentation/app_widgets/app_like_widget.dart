import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_on_flutter/values/app_icons.dart';
import 'package:like_button/like_button.dart';

class AppLikeWidget extends StatelessWidget {
  bool isSelected;
  double iconSize;
  double areaSize;
  Function(bool isLiked) onChanged;

  AppLikeWidget(
      {this.isSelected = true,
      required this.onChanged,
      this.iconSize = 20,
      this.areaSize = 20,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LikeButton(
      size: areaSize,
      isLiked: isSelected,
      onTap: onLikeButtonTapped,
      likeBuilder: (bool isLiked) {
        return SvgPicture.asset(
          isSelected ? AppIcons.heartSelected : AppIcons.heartIcon,
          width: iconSize,
          height: iconSize,
        );
      },
    );
  }

  ///Handle like widget click
  Future<bool> onLikeButtonTapped(bool isLiked) async {
    onChanged(isLiked);
    return !isLiked;
  }
}
