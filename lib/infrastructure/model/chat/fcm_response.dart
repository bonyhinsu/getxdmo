import 'dart:convert';

import '../../../values/firebase_params.dart';
import 'chat_message_model.dart';

class FCMResponse {
  FCMResponse({
    this.receiverId,
    this.senderId,
    this.friendId,
    this.payloadData,
    this.notificationType,
  });

  String? senderId;
  String? friendId;
  String? notificationType;
  String? receiverId;
  ChatMessageModel? payloadData;

  factory FCMResponse.fromJson(Map<String, dynamic> json) => FCMResponse(
        senderId: json[FirebaseParams.senderId],
        receiverId: json[FirebaseParams.receiverId],
        friendId: json[FirebaseParams.friendId],
        notificationType: json[FirebaseParams.notificationType],
        payloadData: json[FirebaseParams.notificationPayload] != null
            ? ChatMessageModel.fromJson(
                jsonDecode(json[FirebaseParams.notificationPayload]))
            : null,
      );

  Map<String, dynamic> toJson() => {
        FirebaseParams.receiverId: receiverId,
        FirebaseParams.senderId: senderId,
        FirebaseParams.friendId: friendId,
        FirebaseParams.notificationPayload: jsonEncode(payloadData),
        FirebaseParams.notificationType: notificationType,
      };
}
