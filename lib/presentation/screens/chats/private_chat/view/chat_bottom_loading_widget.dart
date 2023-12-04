import 'package:flutter/material.dart';

import '../../../../../values/app_colors.dart';
import '../../../../../values/app_values.dart';

class ChatBottomLoadingWidget extends StatelessWidget {
  ChatBottomLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppValues.screenMargin, vertical: AppValues.margin),
      decoration: const BoxDecoration(
        color: AppColors.appTileBackground,
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      )
    );
  }
}
