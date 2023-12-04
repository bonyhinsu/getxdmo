import 'package:flutter/material.dart';
import 'package:game_on_flutter/values/app_colors.dart';

class SliderIndicatorWidget extends StatelessWidget {
  bool isActive = false;

  SliderIndicatorWidget({required this.isActive, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 8,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        height: isActive ? 8 : 6.0,
        width: isActive ? 8 : 6.0,
        decoration: BoxDecoration(

          shape: BoxShape.circle,
          color: isActive
              ? AppColors.appWhiteButtonColor
              : AppColors.appCancelButtonColor,
        ),
      ),
    );
  }
}
