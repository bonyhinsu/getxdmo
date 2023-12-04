import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../values/firebase_constants.dart';

class MessageModel {
  String? messageText;
  int? hasAttachment;
  String? sentBy;
  String? timestamp;

  MessageModel(
      {this.messageText, this.hasAttachment, this.sentBy, this.timestamp});

  MessageModel.fromJson(Map<String, dynamic> json) {
    messageText = json[FirebaseModelParams.messageText];
    hasAttachment = json[FirebaseModelParams.hasAttachment];
    sentBy = json[FirebaseModelParams.sentBy];
    timestamp = json[FirebaseModelParams.messageTime];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[FirebaseModelParams.messageText] = this.messageText;
    data[FirebaseModelParams.hasAttachment] = this.hasAttachment;
    data[FirebaseModelParams.sentBy] = this.sentBy;
    data[FirebaseModelParams.messageTime] = this.timestamp;
    return data;
  }
}

class ChatThreadModel extends Comparable<ChatThreadModel> {
  String? userName;
  String? profile;
  String? messageText;
  String? userId;
  String? dbUserId;
  Timestamp? messageTime;
  String? messageThreadId;
  bool isRead;
  bool isGroup;
  int unreadCount;
  num? isAttachment;
  String? attachmentType;
  bool isSend;
  bool isMute;
  List<String>? members;

  ChatThreadModel(
      {this.userName,
      this.profile,
      this.messageText,
      this.members,
      this.dbUserId,
      this.messageThreadId,
      this.userId,
      this.messageTime,
      this.isMute = false,
      this.isGroup = false,
      this.isRead = true,
      this.unreadCount = 0,
      this.isAttachment,
      this.isSend = false});

  @override
  int compareTo(obj) {
    if ((this.messageTime?.millisecondsSinceEpoch ?? 0) <
        (obj.messageTime?.millisecondsSinceEpoch ?? 0))
      return 1;
    else if ((this.messageTime?.millisecondsSinceEpoch ?? 0) >
        (obj.messageTime?.millisecondsSinceEpoch ?? 0))
      return -1;
    else
      return 0;
  }
}
