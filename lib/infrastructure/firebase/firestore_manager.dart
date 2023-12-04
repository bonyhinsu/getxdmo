import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:game_on_flutter/values/app_constant.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../values/firebase_constants.dart';
import '../model/chat/messageModel.dart';
import '../storage/preference_manager.dart';

class FireStoreManager {
  final logger = Logger();

  late CollectionReference _groupCollection;
  late CollectionReference _groupInfoCollection;

  static final _instance = FireStoreManager._();

  static FireStoreManager get instance => _instance;

  FireStoreManager();

  ///Get only properties
  CollectionReference get groupInfoCollection => _groupInfoCollection;

  FireStoreManager._() {
    _groupCollection =
        FirebaseFirestore.instance.collection(FirebaseDocumentConstants.group);

    /// >>> group info collection.
    _groupInfoCollection = FirebaseFirestore.instance
        .collection(FirebaseDocumentConstants.groupInfo);
  }

  /// Save user detail.
  ///
  /// required [email]
  /// required [uid]
  /// required [deviceType]
  /// required [buildNumber]
  /// required [version]
  /// required [lastLoginDateAndTime]
  /// required [mobileNumber]
  /// required [countryCode]
  /// required [userProfile]
  /// required [isRegisterUser]
  Future<void> saveUserData({
    String email = "",
    String uuid = "",
    String userId = "",
    String deviceType = "",
    String buildNumber = "",
    String version = "",
    String userName = "",
    String phoneNumber = "",
    String lastLoginDateAndTime = "",
    bool isRegisterUser = true,
    int userType = AppConstants.userTypeClub,
  }) async {
    try {
      final map = {
        FirebaseModelParams.EMAIL: email,
        FirebaseModelParams.PROFILE_PICTURE: '',
        FirebaseModelParams.UUID: uuid,
        FirebaseModelParams.DEVICE_TYPE: deviceType,
        FirebaseModelParams.BUILD_VERSION: version,
        FirebaseModelParams.BUILD_NUMBER: buildNumber,
        FirebaseModelParams.LAST_LOGIN_TIME: lastLoginDateAndTime,
        if (userName.isNotEmpty) FirebaseModelParams.USER_NAME: userName,
        FirebaseModelParams.USER_TYPE: userType,
        if (phoneNumber.isNotEmpty)
          FirebaseModelParams.PHONE_NUMBER: phoneNumber,
        if (userId.isNotEmpty) FirebaseModelParams.userId: userId,
      };

      if (isRegisterUser) {
        FirebaseFirestore.instance
            .collection(FirebaseDocumentConstants.users)
            .doc(uuid)
            .set(map);
      } else {
        FirebaseFirestore.instance
            .collection(FirebaseDocumentConstants.users)
            .doc(uuid)
            .update(map);
      }
    } catch (e) {
      logger.i(e);
    }
  }

  /// Update user detail.
  ///
  /// required [profile]
  /// required [uid]
  /// required [userId]
  /// required [fcmToken]
  void updateUserData({
    String userId = "",
    String fcmToken = "",
  }) async {
    try {
      final map = {
        FirebaseModelParams.fcmToken: fcmToken,
      };
      await FirebaseFirestore.instance
          .collection(FirebaseDocumentConstants.users)
          .doc(userId)
          .update(map);
    } catch (e) {
      logger.i(e);
    }
  }

  /// Update user detail.
  ///
  /// required [profile]
  /// required [uid]
  void updateUserAccountData({
    required String firebaseUUID,
    required String profile,
    required String name,
    required String phoneNumber,
    required String email,
  }) async {
    try {
      final map = {
        FirebaseModelParams.USER_NAME: name,
        FirebaseModelParams.PROFILE_PICTURE: profile,
        FirebaseModelParams.PHONE_NUMBER: phoneNumber,
        FirebaseModelParams.EMAIL: email,
      };
      await FirebaseFirestore.instance
          .collection(FirebaseDocumentConstants.users)
          .doc(firebaseUUID)
          .update(map);
    } catch (e) {
      logger.i(e);
    }
  }

  /// Return threadId for friend.
  ///
  /// required [myId]
  /// required [friendId]
  Future<String> getChatThreadId(String myId, String friendId) async {
    String userThreadId = "";
    final userCollection =
        FirebaseFirestore.instance.collection(FirebaseDocumentConstants.users);
    try {
      final receiverMap = userCollection
          .doc(myId)
          .collection(FirebaseDocumentConstants.chatWith);
      await receiverMap.get().then((element) {
        if (element.docs.isNotEmpty) {
          final objectId = element.docs.firstWhere((element1) =>
              element1.get(FirebaseModelParams.userId) == friendId);
          if (objectId.exists) {
            if (friendId == objectId.get(FirebaseModelParams.userId)) {
              userThreadId = objectId.id;
              return userThreadId;
            }
          }
        } else {
          userThreadId = userCollection.doc().id;
          return userThreadId;
        }
      });
      return userThreadId;
    } catch (ex) {
      return userCollection.doc().id;
    }
  }

  /// send private message for new as well as existing user
  ///
  /// required [senderId]
  /// required [receiverId]
  /// required [attachmentUrl]
  /// required [message]
  /// required [chatId]
  /// required [isReplay]
  /// required [oThreadId]
  /// required [oMessageText]
  /// required [oMessageSentBy]
  /// required [attachmentType]
  /// required [oAttachmentType]
  /// required [oAttachmentUrl]
  /// required [isRequestMessage]
  /// required [messages]
  /// required [onMessageSent]
  Future<void> sendPrivateMessage(
      {String senderId = "",
      String receiverId = "",
      String attachmentUrl = "",
      String message = "",
      String chatId = "",
      String attachmentType = "",
      bool isGroup = false,
      List<MessageModel>? messages,
      Function(String chatId)? onMessageSent}) async {
    try {
      /// user object from user.
      final userCollection = FirebaseFirestore.instance
          .collection(FirebaseDocumentConstants.users);

      final receiverMap0 = await userCollection.doc(receiverId).get();
      final senderMap0 = await userCollection.doc(senderId).get();

      FieldValue timeStamp = FieldValue.serverTimestamp();

      Map<String, dynamic> receiverMap = {};
      Map<String, dynamic> senderMap = {};

      try {
        // /// Receiver user data map
        receiverMap = {
          FirebaseModelParams.userId:
              receiverMap0.get(FirebaseModelParams.UUID),
          FirebaseModelParams.USER_NAME:
              receiverMap0.data()?[FirebaseModelParams.USER_NAME] ?? "",
          FirebaseModelParams.PROFILE_PICTURE:
              receiverMap0.data()?[FirebaseModelParams.PROFILE_PICTURE] ?? "",
        };
      } catch (ex) {
        logger.i("receiverMap $ex");
      }

      try {
        // /// Sender user data map
        senderMap = {
          FirebaseModelParams.userId: senderMap0.get(FirebaseModelParams.UUID),
          FirebaseModelParams.USER_NAME:
              senderMap0.data()?[FirebaseModelParams.USER_NAME] ?? "",
          FirebaseModelParams.PROFILE_PICTURE:
              senderMap0.data()?[FirebaseModelParams.PROFILE_PICTURE] ?? "",
        };
      } catch (ex) {
        Get.log("sender $ex");
      }

      // message object for message table
      final messageMap = {
        FirebaseModelParams.messageText: message,
        FirebaseModelParams.hasAttachment: 0,
        FirebaseModelParams.sentBy: senderId,
        FirebaseModelParams.messageTime: timeStamp,
        FirebaseModelParams.sender: senderMap,
        FirebaseModelParams.receiver: receiverMap,
      };

      /// update map when there is attachment
      if (attachmentUrl.isNotEmpty) {
        final messageAttachment = {
          FirebaseModelParams.attachment: attachmentUrl,
          FirebaseModelParams.hasAttachment: 1,
          FirebaseModelParams.attachmentType: attachmentType,
        };
        messageMap.addAll(messageAttachment);
      }

      /// >>> messages collection.
      final privateChatCollection = FirebaseFirestore.instance
          .collection(FirebaseDocumentConstants.messages);

      /// Generate new chatId for new chat
      if (chatId.isEmpty) {
        chatId = await getChatThreadId(senderId, receiverId).then((value) {
          return value;
        });
      }

      Get.log('chatId $chatId');

      /// ---------------------------- Add New messages --------------------------
      privateChatCollection.doc(chatId).collection(chatId).add(messageMap);

      /// >>> group info collection.
      final groupCollection = FirebaseFirestore.instance
          .collection(FirebaseDocumentConstants.groupInfo);

      final groupInfoMap = {
        FirebaseModelParams.lastMessageSent:
            attachmentUrl.isNotEmpty ? attachmentType : message,
        FirebaseModelParams.lastMessageTime: timeStamp,
        FirebaseModelParams.sender: senderMap,
        FirebaseModelParams.receiver: receiverMap,
        FirebaseModelParams.sentBy: senderId,
        FirebaseModelParams.isGroup: isGroup ? 1 : 0,
      };

      /// ---------------------------- update group info table --------------------------
      groupCollection.doc(chatId).set(groupInfoMap);

      final path = await groupCollection
          .doc(chatId)
          .collection(FirebaseDocumentConstants.members)
          .doc(senderId)
          .get();
      if (!path.exists) {
        final muteMap = {
          FirebaseModelParams.isMute: 0,
        };
        groupCollection
            .doc(chatId)
            .collection(FirebaseDocumentConstants.members)
            .doc(senderId)
            .set(muteMap);

        groupCollection
            .doc(chatId)
            .collection(FirebaseDocumentConstants.members)
            .doc(receiverId)
            .set(muteMap);
      }

      try {
        /// Add message unread count.
        final messageCount = {
          FirebaseModelParams.sentBy: senderId,
          FirebaseModelParams.lastMessageSent:
              attachmentUrl.isNotEmpty ? attachmentType : message,
        };
        groupCollection.doc(chatId).collection(receiverId).add(messageCount);
      } catch (ex) {
        logger.i("sendPrivateMessage:: Add message to groupInfo $ex");
      }

      /// Sender object added members.
      final senderChatsMap = {
        FirebaseModelParams.userId: receiverId,
        FirebaseModelParams.updatedAt: timeStamp,
      };

      /// Receiver object added members.
      final receiverChatMap = {
        FirebaseModelParams.userId: senderId,
        FirebaseModelParams.updatedAt: timeStamp,
      };

      /// ---------------------------------------------------
      /// Update sender and receiver object with other userId.
      await userCollection
          .doc(senderId)
          .collection(FirebaseDocumentConstants.chatWith)
          .doc(chatId)
          .set(senderChatsMap);

      await userCollection
          .doc(receiverId)
          .collection(FirebaseDocumentConstants.chatWith)
          .doc(chatId)
          .set(receiverChatMap);

      if (onMessageSent != null) onMessageSent(chatId);
    } catch (e) {
      logger.i("sendPrivateMessage $e");
    }
  }

  FieldValue getServerTimestamp() => FieldValue.serverTimestamp();

  /// Return unread message count.
  ///
  /// required [threadId]
  /// required [myId]
  /// required [isPrivateChat]
  Future<int> getUnreadMessageCount(
      String threadId, String myId, bool isPrivateChat) async {
    /// >>> group info collection.
    final groupCollection = FirebaseFirestore.instance
        .collection(FirebaseDocumentConstants.groupInfo);
    QuerySnapshot<Map<String, dynamic>> unreadCollections;
    if (isPrivateChat) {
      unreadCollections =
          await groupCollection.doc(threadId).collection(myId).get();
    } else {
      unreadCollections = await groupCollection
          .doc(threadId)
          .collection(FirebaseDocumentConstants.members)
          .doc(myId)
          .collection(FirebaseDocumentConstants.unreadMessage)
          .get();
    }
    return unreadCollections.size;
  }

  /// Return unread message count.
  ///
  /// required [threadId]
  /// required [myId]
  Stream<QuerySnapshot<Map<String, dynamic>>> getUnreadMessageCountSteam(
      String threadId, String myId) {
    /// >>> group info collection.
    final groupCollection = FirebaseFirestore.instance
        .collection(FirebaseDocumentConstants.groupInfo);
    return groupCollection.doc(threadId).collection(myId).snapshots();
  }

  /// Return last message added to thread.
  ///
  /// required [threadId]
  /// required [myId]
  Future<DocumentSnapshot<Map<String, dynamic>>> getLastMessageAdded(
      String threadId, String myId) {
    /// >>> group info collection.
    final groupCollection = FirebaseFirestore.instance
        .collection(FirebaseDocumentConstants.groupInfo);
    return groupCollection.doc(threadId).get();
  }

  /// Return unread message count.
  ///
  /// required [threadId]
  /// required [myId]
  Stream<QuerySnapshot<Map<String, dynamic>>> getUnreadGroupMessageCountStream(
      String threadId, String myId) {
    /// >>> group info collection.
    final groupCollection = FirebaseFirestore.instance
        .collection(FirebaseDocumentConstants.groupInfo);
    return groupCollection
        .doc(threadId)
        .collection(FirebaseDocumentConstants.members)
        .doc(myId)
        .collection(FirebaseDocumentConstants.unreadMessage)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUserDetails(
      {required String userId}) {
    /// user object from user.
    final userCollection =
        FirebaseFirestore.instance.collection(FirebaseDocumentConstants.users);

    return userCollection.doc(userId).snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails(
      {required String userId}) {
    /// user object from user.
    final userCollection =
        FirebaseFirestore.instance.collection(FirebaseDocumentConstants.users);

    return userCollection.doc(userId).get();
  }

  /// Return conversation id based on both matches.
  ///
  /// required [userID]
  /// required [peerID]
  String getConversationID(String userID, String peerID) {
    return userID.hashCode <= peerID.hashCode
        ? userID + '_' + peerID
        : peerID + '_' + userID;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> addMuteFieldSnapshots(
      String threadId, String myId) {
    return _groupCollection
        .doc(threadId)
        .collection(FirebaseDocumentConstants.members)
        .doc(myId)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>>
      addPrivateChatMuteFieldSnapshots(String threadId, String myId) {
    return _groupInfoCollection
        .doc(threadId)
        .collection(FirebaseDocumentConstants.members)
        .doc(myId)
        .snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserMuteStatus(
      String threadId, String myId) async {
    final abs = await _groupInfoCollection
        .doc(threadId)
        .collection(FirebaseDocumentConstants.members)
        .doc(myId)
        .get();
    if (abs.exists) {
      return abs;
    } else {
      final groupInfoMap = {
        FirebaseModelParams.isMute: 0,
      };
      await _groupInfoCollection
          .doc(threadId)
          .collection(FirebaseDocumentConstants.members)
          .doc(myId)
          .set(groupInfoMap)
          .then((value) {});
      return await _groupInfoCollection
          .doc(threadId)
          .collection(FirebaseDocumentConstants.members)
          .doc(myId)
          .get();
    }
  }

  /// return chat threads for users.
  ///
  /// required [messageId]
  /// required [userId]
  /// required [friendId]
  Future<Stream<DocumentSnapshot>> getUserMessage(
      String messageId, String userId, String friendId) async {
    CollectionReference reference = FirebaseFirestore.instance
        .collection(FirebaseDocumentConstants.messages);

    final conversationId = getConversationID(userId, friendId);
    final tmp = reference.doc(conversationId).collection(conversationId);
    final selectedChat = tmp.doc();
    return selectedChat.snapshots();
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getThreadAndUserIdFromEmail({
    required String myId,
  }) async {
    /// user object from user.
    final userCollection =
        FirebaseFirestore.instance.collection(FirebaseDocumentConstants.users);

    /// user object from user.
    final userChats = await userCollection.get();
    userChats.docs.removeWhere(
        (element) => element.data()[FirebaseModelParams.UUID] == myId);

    return userChats.docs;
  }

  Future<String?> getUserChatWith({
    required String myId,
    required String friendId,
  }) async {
    /// user object from user.
    final userCollection =
        FirebaseFirestore.instance.collection(FirebaseDocumentConstants.users);

    final userChatWithDoc = await userCollection
        .doc(myId)
        .collection(FirebaseDocumentConstants.chatWith)
        .get();

    final threadIdWithUser = userChatWithDoc.docs.firstWhereOrNull(
        (element) => element.data()[FirebaseModelParams.userId] == friendId);

    if (threadIdWithUser != null) {
      return threadIdWithUser.id;
    }

    return userCollection
        .doc(myId)
        .collection(FirebaseDocumentConstants.chatWith)
        .doc()
        .id;
  }

  /// Return stream data which returns data when update from database.
  ///
  /// required [threadId]
  /// required [limit]
  Future<QuerySnapshot<Map<String, dynamic>>> getChatMessages(
      String threadId, int limit,
      {DocumentSnapshot? lastDocId}) {
    CollectionReference reference = FirebaseFirestore.instance
        .collection(FirebaseDocumentConstants.messages);
    if (threadId.isEmpty) {
      threadId = "1";
    }
    final chatMessages = reference.doc(threadId).collection(threadId);

    if (lastDocId == null) {
      return chatMessages
          .orderBy(FirebaseModelParams.messageTime, descending: true)
          .limit(limit)
          .get();
    }
    return chatMessages
        .orderBy(FirebaseModelParams.messageTime, descending: true)
        .startAfterDocument(lastDocId)
        .limit(limit)
        .get();
  }

  /// Return stream data which returns data when update from database.
  ///
  /// required [threadId]
  /// required [userId]
  Stream<QuerySnapshot<Map<String, dynamic>>> getMessageStream(
      String threadId, String userId) {
    CollectionReference reference = FirebaseFirestore.instance
        .collection(FirebaseDocumentConstants.groupInfo);
    final chatMessages = reference.doc(threadId).collection(userId);
    return chatMessages.snapshots();
  }

  /// Remove unread messages.
  ///
  /// required [threadId]
  /// required [userId]
  /// required [friendId]
  void removeUnreadMessage(
      String threadId, String userId, String friendId) async {
    CollectionReference reference = FirebaseFirestore.instance
        .collection(FirebaseDocumentConstants.groupInfo);
    final chatMessages = reference.doc(threadId).collection(userId);
    await chatMessages.get().then((value) {
      for (DocumentSnapshot ds in value.docs) {
        ds.reference.delete();
      }
    });
  }

  /// Remove unread messages.
  ///
  /// required [threadId]
  /// required [userId]
  /// required [groupId]
  void removeUnreadMessageForGroup(
      String threadId, String userId, String groupId) {
    CollectionReference reference = FirebaseFirestore.instance
        .collection(FirebaseDocumentConstants.groupInfo);
    final chatMessages = reference
        .doc(threadId)
        .collection(FirebaseDocumentConstants.members)
        .doc(userId)
        .collection(FirebaseDocumentConstants.unreadMessage);
    chatMessages.get().then((value) {
      for (DocumentSnapshot ds in value.docs) {
        ds.reference.delete();
      }
    });
  }

  /// Return stream data which returns data when update from database.
  ///
  /// required [userId]
  Stream<QuerySnapshot<Map<String, dynamic>>> getMessageThreadStream(
      String userId) {
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection(FirebaseDocumentConstants.users);
    return userCollection
        .doc(userId)
        .collection(FirebaseDocumentConstants.chatWith)
        .snapshots(includeMetadataChanges: true)
        .where((event) => event.docChanges.isNotEmpty);
  }

  /// Return stream data which returns data when update from database.
  ///
  /// required [userId]
  Future<QuerySnapshot<Map<String, dynamic>>> getMessageThreads(
      String userId) async {
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection(FirebaseDocumentConstants.users);
    return userCollection
        .doc(userId)
        .collection(FirebaseDocumentConstants.chatWith)
        .orderBy(FirebaseModelParams.updatedAt, descending: false)
        .get();
  }

  /// delete user chats from fireStore from users, message and group_info table.
  ///
  /// required [userId]
  /// required [threadId]
  /// required [isAdmin]
  /// required [isPrivateChat]
  Future<void> deleteUserChats(
      String userId, String threadId, bool isAdmin, bool isPrivateChat) async {
    /// Delete group from user chats.
    final userCollection =
        FirebaseFirestore.instance.collection(FirebaseDocumentConstants.users);

    /// >>> group info collection.
    final groupInfoCollection = FirebaseFirestore.instance
        .collection(FirebaseDocumentConstants.groupInfo);

    await userCollection
        .doc(userId)
        .collection(FirebaseDocumentConstants.chatWith)
        .doc(threadId)
        .delete();

    await userCollection
        .doc(GetIt.I<PreferenceManager>().userUUID)
        .collection(FirebaseDocumentConstants.chatWith)
        .doc(threadId)
        .delete();

    /// Remove user from group info.
    groupInfoCollection.doc(threadId).delete();

    CollectionReference groupCollection =
        FirebaseFirestore.instance.collection(FirebaseDocumentConstants.group);

    /// Remove user from group's members
    groupCollection
        .doc(threadId)
        .collection(FirebaseDocumentConstants.members)
        .doc(userId)
        .delete();

    /// Delete group messages.
    final messageCollection = FirebaseFirestore.instance
        .collection(FirebaseDocumentConstants.messages);

    final threadElement =
        await messageCollection.doc(threadId).collection(threadId).get();
    for (var element in threadElement.docs) {
      await messageCollection
          .doc(threadId)
          .collection(threadId)
          .doc(element.id)
          .delete();
    }
    groupInfoCollection.doc(threadId).delete();
  }

  /// clear chat history for users.
  Future<void> clearChatForUser(String threadId, String myUserName) async {
    Get.log("delete chat thread --> $threadId");

    /// Delete user chat messages.
    final messageCollection = FirebaseFirestore.instance
        .collection(FirebaseDocumentConstants.messages);

    /// >>> group info collection.
    final groupInfoCollection = FirebaseFirestore.instance
        .collection(FirebaseDocumentConstants.groupInfo);

    await groupInfoCollection.doc(threadId).update({
      FirebaseModelParams.lastMessageSent: "$myUserName cleared chat history.",
    });

    final threadElement =
        await messageCollection.doc(threadId).collection(threadId).get();
    for (var element in threadElement.docs) {
      await messageCollection
          .doc(threadId)
          .collection(threadId)
          .doc(element.id)
          .delete();
    }
  }

  /// Return groupId for new group.
  String generateNewGroupId() {
    /// >>> group collection.
    CollectionReference groupCollection =
        FirebaseFirestore.instance.collection(FirebaseDocumentConstants.group);

    return groupCollection.doc().id;
  }

  /// Return device token from firebase user document.
  ///
  /// required [data]
  /// required [tokens]
  Future<void> getDeviceTokenFromUserTable(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> data,
      List<String> tokens) async {
    try {
      final d = data.removeLast();
      if (d.data()[FirebaseModelParams.userId].toString() !=
          GetIt.I<PreferenceManager>().userUUID) {
        final user = await FirebaseFirestore.instance
            .collection(FirebaseDocumentConstants.users)
            .doc(d.data()[FirebaseModelParams.userId])
            .get();
        final deviceToken = user.data()?[FirebaseModelParams.fcmToken];
        tokens.add(deviceToken ?? "");
        await getDeviceTokenFromUserTable(data, tokens);
      } else {
        await getDeviceTokenFromUserTable(data, tokens);
      }
    } catch (e) {
      logger.i("exception $e");
    }
  }

  /// Get group all members
  ///
  /// required [groupId]
  Future<QuerySnapshot<Map<String, dynamic>>> getGroupMembers(
      String groupId) async {
    final groupCollection =
        FirebaseFirestore.instance.collection(FirebaseDocumentConstants.group);
    return await groupCollection
        .doc(groupId)
        .collection(FirebaseDocumentConstants.members)
        .orderBy(FirebaseModelParams.updatedAt, descending: true)
        .get();
  }

  /// Get user object based on userId.
  ///
  /// required [userId]
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserObject(
      String userId) async {
    final userCollection =
        FirebaseFirestore.instance.collection(FirebaseDocumentConstants.users);
    return await userCollection.doc(userId).get();
  }

  /// get user detail from userId.
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserObjectFromThreadId(
      String userId) async {
    final userCollection =
        FirebaseFirestore.instance.collection(FirebaseDocumentConstants.users);
    final adminObj = await userCollection.doc(userId).get();
    return adminObj;
  }

  /// Listen for group settings change for members.
  ///
  /// required [threadId]
  Stream<QuerySnapshot<Map<String, dynamic>>> listenForMemberChange(
      String threadId) {
    final groupCollection =
        FirebaseFirestore.instance.collection(FirebaseDocumentConstants.group);
    return groupCollection
        .doc(threadId)
        .collection(FirebaseDocumentConstants.members)
        .snapshots();
  }

  /// Update group admin
  Future<void> updateGroupAdmin(
      {required String groupId,
      required String userId,
      bool isRemoveAdmin = false}) async {
    final groupCollection =
        FirebaseFirestore.instance.collection(FirebaseDocumentConstants.group);

    final groupDocRef = await groupCollection.doc(groupId).get();

    List<String> adminList = List<String>.from(
        groupDocRef.get(FirebaseModelParams.groupAdmin) as List);

    if (!isRemoveAdmin) {
      adminList.add(userId);
    } else {
      adminList.removeWhere((element) => element == userId);
    }
    await groupCollection.doc(groupId).update({
      FirebaseModelParams.groupAdmin: adminList,
    });
  }

  Future<void> subscribeUserTokenToExistingGroup() async {
    /// user collection
    final userCollection =
        FirebaseFirestore.instance.collection(FirebaseDocumentConstants.users);

    final mUserId = GetIt.I<PreferenceManager>().userUUID;

    final userDetailRef = await userCollection.doc(mUserId).get();

    List<String> adminList = List<String>.from(
        userDetailRef.get(FirebaseModelParams.groups) as List);

    for (var groupId in adminList) {
      FirebaseMessaging.instance.subscribeToTopic(groupId);
    }
  }

  Future<void> unSubscribeUserTokenToExistingGroup() async {
    /// user collection
    final userCollection =
        FirebaseFirestore.instance.collection(FirebaseDocumentConstants.users);

    final mUserId = GetIt.I<PreferenceManager>().userUUID;

    final userDetailRef = await userCollection.doc(mUserId).get();

    List<String> adminList = List<String>.from(
        (userDetailRef.data()?[FirebaseModelParams.groups] ?? []) as List);
    for (var groupId in adminList) {
      FirebaseMessaging.instance.unsubscribeFromTopic(groupId);
    }
  }

  Future<void> updateUserGroups(
      String userId, String groupId, bool removeFromGroup) async {
    /// user collection
    final userCollection =
        FirebaseFirestore.instance.collection(FirebaseDocumentConstants.users);

    final userDetailRef = await userCollection.doc(userId).get();

    List<String> adminList = List<String>.from(
        (userDetailRef.data()?[FirebaseModelParams.groups] ?? []) as List);

    if (removeFromGroup) {
      if (adminList.contains(groupId)) {
        adminList.removeWhere((element) => element == groupId);
      }
    } else {
      adminList.add(groupId);
    }

    await userCollection
        .doc(userId)
        .update({FirebaseModelParams.groups: adminList});
  }
}
