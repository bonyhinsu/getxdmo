import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../values/firebase_constants.dart';


class ChatMessageModel {
  String? messageId;
  String? messageText;
  Timestamp? timestamp;
  bool sentByMe = true;
  bool isDate = false;
  bool hasAttachment = false;
  RxBool highlightLine = false.obs;
  String? attachmentType;
  String? attachmentURL;
  bool? isGroup;
  String? affectedUserId;
  String? affectedUserName;
  int? messageType;
  SenderDetail? senderDetail;

  ChatMessageModel({
    this.messageId,
    this.messageText,
    this.timestamp,
    this.sentByMe = true,
    this.hasAttachment = false,
    this.attachmentType,
    this.attachmentURL,
    this.senderDetail,
    this.affectedUserId,
    this.affectedUserName,
    this.isGroup,
    this.messageType,
  });

  Map<String, dynamic> toJson() => {
        FirebaseModelParams.messageId: messageId,
        FirebaseModelParams.messageText: messageText,
        "timestamp": timestamp?.millisecondsSinceEpoch,
        "attachmentType": attachmentType,
        "attachmentURL": attachmentURL,
        "hasAttachment": hasAttachment,
        "senderDetail": senderDetail,
        "isGroup": isGroup,
        "affectedUserId": affectedUserId,
        "affectedUserName": affectedUserName,
        "messageType": messageType,
      };

  factory ChatMessageModel.fromJson(
          Map<dynamic, dynamic> data) =>
      ChatMessageModel(
          messageId: data[FirebaseModelParams.messageId],
          messageText: data[FirebaseModelParams.messageText],
          timestamp:
              data["timestamp"] ==
                      null
                  ? null
                  : Timestamp
                      .fromMillisecondsSinceEpoch(
                          data["timestamp"] is int
                              ? data["timestamp"]
                              : int.parse(data["timestamp"])),
          attachmentType: data["attachmentType"],
          hasAttachment: data["hasAttachment"],
          isGroup: data["isGroup"],
          affectedUserId: data["affectedUserId"],
          attachmentURL: data["attachmentURL"],
          affectedUserName: data["affectedUserName"],
          messageType: data["messageType"],
          senderDetail: data["senderDetail"] != null
              ? SenderDetail.fromMap(data["senderDetail"])
              : null);
}

class SenderDetail {
  String? profilePicture;
  String? senderName;
  String? userId;
  String? dbUserId;
  String? groupName;

  SenderDetail(
      {this.profilePicture, this.senderName, this.userId, this.groupName});

  SenderDetail.fromMap(Map<dynamic, dynamic> data)
      : profilePicture = data[FirebaseModelParams.PROFILE_PICTURE] ?? "",
        senderName = data[FirebaseModelParams.USER_NAME] ?? "",
        userId = data[FirebaseModelParams.userId] ?? "";

  Map<String, dynamic> toJson() => {
        FirebaseModelParams.PROFILE_PICTURE: profilePicture,
        FirebaseModelParams.USER_NAME: senderName,
        FirebaseModelParams.userId: userId,
      };
}
