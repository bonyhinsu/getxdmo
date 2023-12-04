import 'package:flutter/material.dart';
import 'package:game_on_flutter/values/app_values.dart';

import '../../../../../values/app_colors.dart';

class BlockUserMessageWidget extends StatelessWidget {
  bool isBlockByMe;

  BlockUserMessageWidget({this.isBlockByMe = false, Key? key})
      : super(key: key);
  late TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;

    return Container(
      color: AppColors.textFieldBackgroundColor,
      padding: const EdgeInsets.all(AppValues.screenMargin),
      child: Text(
        isBlockByMe
            ? 'This user is blocked.\nYou can only write message after unblocking this user.'
            : 'You can not write message to this user.',
        textAlign: TextAlign.center,
        style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
      ),
    );
  }
}
