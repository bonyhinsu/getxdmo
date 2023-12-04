import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game_on_flutter/values/app_colors.dart';

import '../../../../../infrastructure/model/chat/chat_message_model.dart';
import '../../../../../values/app_values.dart';
import '../../../../../values/common_utils.dart';

class ChatDateWidget extends StatelessWidget {
  ChatMessageModel chatObj;

  ChatDateWidget({required this.chatObj, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String chatTime = "";
    final DateTime serverTimeStamp = (chatObj.timestamp as Timestamp).toDate();
    chatTime = CommonUtils.getDateFromTimeStamp(
        serverTimeStamp.millisecondsSinceEpoch);
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppValues.height_10, vertical: AppValues.height_20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            child: Text(
              chatTime,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColorPrimary),
            ),
          ),
          Divider(
            color: AppColors.textColorSecondary.withOpacity(0.1),
            height: 0.5,
          ),
        ],
      ),
    );
  }

  /// Returns the difference (in full days) between the provided date and today.
  int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }
}
