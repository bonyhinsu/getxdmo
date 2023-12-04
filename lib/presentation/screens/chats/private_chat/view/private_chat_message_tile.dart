import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game_on_flutter/values/app_colors.dart';
import 'package:game_on_flutter/values/app_constant.dart';
import 'package:game_on_flutter/values/app_values.dart';
import 'package:intl/intl.dart';

import '../../../../../infrastructure/model/chat/chat_message_model.dart';
import '../../../../../infrastructure/model/common/app_fields.dart';
import '../../../../app_widgets/app_image_widget.dart';
import '../../../../custom_widgets/receiver_custom_Painter.dart';
import '../../../../custom_widgets/sender_custom_painter.dart';

//ignore: must_be_immutable
class PrivateChatMessageRow extends StatelessWidget {
  final ChatMessageModel messageModel;

  Function(ChatMessageModel messageModel) onAttachedImageClick;

  late ThemeData _themeData;
  late BuildContext _context;

  PrivateChatMessageRow(
    this.messageModel, {
    required this.onAttachedImageClick,
    Key? key,
  }) : super(key: key);

  late AnimationController animation;
  late AnimationController animationController;
  late AnimationController controller;

  @override
  Widget build(BuildContext context) {
    _themeData = Theme.of(context);
    _context = context;
    return Material(
      color: Colors.transparent,
      child: messageModel.isDate
          ? Container()
          : Container(
              margin: messageModel.sentByMe
                  ? const EdgeInsets.only(
                      left: 84.0,
                      right: AppValues.size_10,
                      top: 4.0,
                      bottom: 4.0)
                  : const EdgeInsets.only(
                      right: 84.0,
                      top: 4.0,
                      bottom: 4.0,
                      left: AppValues.size_10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: messageModel.sentByMe
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  if (!messageModel.sentByMe) buildReceiverArrow,
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                          color: messageModel.sentByMe
                              ? AppColors.bottomSheetInputBackground
                              : AppColors.appRedButtonColorDisable,
                          borderRadius: BorderRadius.only(
                              topRight: const Radius.circular(8),
                              topLeft: const Radius.circular(8),
                              bottomLeft: Radius.circular(
                                  messageModel.sentByMe ? 8 : 0),
                              bottomRight: Radius.circular(
                                  messageModel.sentByMe ? 0 : 8))),
                      child: messageModel.attachmentType == AppConstants.image
                          ? buildImagePreview()
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Flexible(child: buildMessageContent()),
                                const SizedBox(
                                  width: AppValues.size_14,
                                ),
                                buildMessageTime()
                              ],
                            ),
                    ),
                  ),
                  if (messageModel.sentByMe) buildSenderArrow
                ],
              ),
            ),
    );
  }

  /// build chat message content widget
  Widget buildMessageContent() {
    return Text(
      "${messageModel.messageText}",
      textAlign: messageModel.sentByMe ? TextAlign.right : TextAlign.left,
      overflow: TextOverflow.fade,
      style: _themeData.textTheme.bodyText2!.copyWith(),
    );
  }

  /// build chat message content widget
  Widget buildImagePreview() {
    return GestureDetector(
      onTap: () => onAttachedImageClick(messageModel),
      child: Stack(
        children: [
          Hero(
            tag: "${messageModel.timestamp}",
            child: Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppValues.radius_10)),
                child: AppImageWidget(
                  imagePath:
                      "${AppFields.instance.imagePrefix}${messageModel.attachmentURL}",
                  fit: BoxFit.fitWidth,
                  containerSize: 200,
                )),
          ),
          Positioned(right: 8, bottom: 4, child: buildMessageTime())
        ],
      ),
    );
  }

  /// build chat message content widget
  Widget buildMessageTime() {
    String chatTime = "";
    try {
      final DateTime serverTimeStamp =
          (messageModel.timestamp as Timestamp).toDate();
      chatTime = DateFormat('hh:mm a').format(serverTimeStamp);
    } catch (ex) {
      chatTime = DateFormat('hh:mm a').format(DateTime.now());
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        chatTime,
        style: _themeData.textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.w400,
            color: !messageModel.hasAttachment
                ? AppColors.textColorDarkGray
                : AppColors.textColorSecondary,
            fontSize: 8),
      ),
    );
  }

  /// Build receiver arrow widget.
  Widget get buildReceiverArrow => SizedBox(
        height: 6,
        child: CustomPaint(
          painter: ReceiverCustomPainter(),
          child: Container(),
        ),
      );

  /// Build sender arrow widget.
  Widget get buildSenderArrow => SizedBox(
        height: 6,
        child: CustomPaint(
          painter: SenderShapePainter(),
          child: Container(),
        ),
      );
}
