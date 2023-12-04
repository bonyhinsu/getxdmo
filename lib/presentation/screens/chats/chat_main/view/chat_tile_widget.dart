import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_player_profile_widget.dart';
import 'package:game_on_flutter/values/common_utils.dart';

import '../../../../../infrastructure/model/chat/messageModel.dart';
import '../../../../../values/app_colors.dart';
import '../../../../../values/app_values.dart';

class ChatMainTileWidget extends StatelessWidget {
  ChatThreadModel model;

  Function(ChatThreadModel model) onTap;

  ChatMainTileWidget({required this.model, required this.onTap, Key? key})
      : super(key: key);

  late TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return ListTile(
      contentPadding: const EdgeInsets.only(
          left: AppValues.mediumPadding,
          right: AppValues.mediumPadding,
          top: AppValues.halfPadding,
          bottom: AppValues.halfPadding),
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.transparent, width: 1),
          borderRadius: BorderRadius.circular(AppValues.roundedButtonRadius)),
      tileColor: AppColors.appTileBackground,
      onTap: () {
        onTap(model);
      },
      leading: buildPlayerImage(),
      title: buildPlayerInfoColumn(),
      trailing: buildDateWidget(),
    );
  }

  /// Builds player image view.
  Widget buildPlayerImage() => AppPlayerProfileWidget(
        profileURL: "${model.profile}",
      );

  /// Builds player column widget.
  Widget buildPlayerInfoColumn() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${model.userName}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.textColorSecondary),
          ),
          const SizedBox(
            height: AppValues.smallMargin,
          ),
          Text(
            "${model.messageText}",
            style: textTheme.displaySmall
                ?.copyWith(color: AppColors.textColorDarkGray,fontSize: 13),
          ),
        ],
      );

  /// Build date widget.
  Widget buildDateWidget() {
    String chatTime = "";

    /// Current time stamp
    final currentTimeStamp = Timestamp.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch);

    /// Added time stamp.
    final DateTime serverTimeStamp =
        (model.messageTime ?? currentTimeStamp).toDate();

    chatTime = CommonUtils.getDateFromTimeStamp(
        serverTimeStamp.millisecondsSinceEpoch);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          chatTime,
          style: textTheme.bodySmall
              ?.copyWith(fontSize: 8, color: AppColors.textColorDarkGray),
        ),
      ],
    );
  }
}
