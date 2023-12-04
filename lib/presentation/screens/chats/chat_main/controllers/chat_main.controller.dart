import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_on_flutter/infrastructure/navigation/route_config.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_loading_mixin.dart';
import 'package:game_on_flutter/presentation/screens/player/player_main/controllers/player_main.controller.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../../../../infrastructure/firebase/firestore_manager.dart';
import '../../../../../infrastructure/model/chat/chat_message_model.dart';
import '../../../../../infrastructure/model/chat/messageModel.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../infrastructure/storage/preference_manager.dart';
import '../../../../../values/firebase_constants.dart';
import '../../../club/club_main/controllers/club_main.controller.dart';
import '../../private_chat/controllers/private_chat.controller.dart';

class ChatMainController extends GetxController with AppLoadingMixin {
  RxList<ChatThreadModel> threads = RxList();

  RxSet<ChatThreadModel> threadListSet = <ChatThreadModel>{}.obs;

  final logger = Logger();

  int eventIndex = 0;
  bool isAdding = false;
  Timestamp? timestamp;

  late StreamSubscription? _listener;

  RxBool isAddingData = false.obs;

  final str = [];

  @override
  void onInit() {
    addListenerForChats();
    getUserThreads();
    super.onInit();
  }

  @override
  void onClose() {
    _listener?.cancel();
    super.onClose();
  }

  /// Add chat thread listener.
  void addListenerForChats() {
    final String userId = GetIt.I<PreferenceManager>().userUUID;
    final query = GetIt.I<FireStoreManager>().getMessageThreadStream(userId);
    _listener = query.listen((event) {
      getUserThreads();
    });
  }

  /// Get user threads from firebase
  Future<void> getUserThreads() async {
    isAdding = true;
    showLoading();
    final String userId = GetIt.I<PreferenceManager>().userUUID;

    try {
      /// Get user's chat with stream from user table order by descending timestamp.
      GetIt.I<FireStoreManager>().getMessageThreads(userId).then((value) async {
        if (value.docs.isNotEmpty) {
          try {
            /// Store the timestamp from each document from updatedAt time.
            timestamp = value.docs.last.get(FirebaseModelParams.updatedAt);
          } catch (ex) {
            print(ex);
          }
          isAddingData.value = true;
          showLoading();
          threads.clear();
        } else {
          isAddingData.value = false;
          hideLoading();
          return;
        }

        /// Reference of group_info collection.
        CollectionReference _groupInfoCollection = FirebaseFirestore.instance
            .collection(FirebaseDocumentConstants.groupInfo);

        for (var element in value.docs) {
          eventIndex += 1;
          try {
            /// Get chat info from group_info where [element.id] is documentReferenceId stored in user> chat with table.
            await _groupInfoCollection
                .doc(element.id)
                .get()
                .then((event) async {
              if (event.exists) {
                await addObjectToThreadList(event, element.id, userId, false);
                isAdding = false;
              }
            });
          } catch (ex) {
            logger.e(ex);
            isAdding = false;
          }
        }
        final tempList = threads;
        if (tempList.isNotEmpty) {
          threadListSet.clear();
          str.clear();
        }

        for (var element in tempList) {
          if (!str.contains(element.userId)) {
            if ((element.messageThreadId ?? "").isNotEmpty) {
              str.add(element.userId);
              threadListSet.add(element);
            }
          }
        }
      });
    } catch (ex) {
      hideLoading();
      print(ex.toString());
    }
    hideLoading();
  }

  /// Refresh thread screen.
  Future<void> onRefreshThreads() async {
    showLoading();
    getUserThreads();
  }

  /// Prepare model object and add to thread list.
  Future<void> addObjectToThreadList(DocumentSnapshot groupObject,
      String elementId, String userId, bool isMuteChat) async {
    bool _isSentByMe =
        (groupObject.get(FirebaseModelParams.sentBy) ?? '') == userId;
    bool isGroup = (groupObject.get(FirebaseModelParams.isGroup) ?? 0) == 1;
    final senderMap = isGroup
        ? SenderDetail.fromMap(groupObject.get(FirebaseModelParams.sender))
        : SenderDetail.fromMap(_isSentByMe
            ? groupObject.get(FirebaseModelParams.receiver)
            : groupObject.get(FirebaseModelParams.sender));

    ChatThreadModel _model = ChatThreadModel();
    _model.messageText = groupObject.get(FirebaseModelParams.lastMessageSent);
    _model.isGroup = isGroup;
    _model.messageTime =
        groupObject.get(FieldPath(const [FirebaseModelParams.lastMessageTime]));
    _model.isSend = _isSentByMe;
    try {
      _model.isRead = groupObject.get(FirebaseModelParams.isRead) == 1;
    } catch (ex) {}
    try {
      final receiver = await getUserDataFromUserId(senderMap.userId ?? "");
      _model.userId = receiver.userId ?? "";
      _model.messageThreadId = elementId ?? "";
      _model.profile = receiver.profilePicture ?? "";
      _model.userName = receiver.senderName ?? "";
      _model.dbUserId = receiver.dbUserId ?? "";
    } catch (ex) {
      logger.e(ex);
    }
    if (!threads.contains(_model)) {
      threads.add(_model);
    }
    threads.sort((obj1, obj2) => obj1.compareTo(obj2));
  }

  /// Get user object from userId.
  Future<SenderDetail> getUserDataFromUserId(String userId) async {
    try {
      final userObject =
          await GetIt.I<FireStoreManager>().getUserObjectFromThreadId(userId);

      SenderDetail senderDetail = SenderDetail();

      if (userObject.exists) {
        senderDetail.userId = userId;
        senderDetail.dbUserId =
            userObject.data()?[FirebaseModelParams.userId] ?? "";
        senderDetail.profilePicture =
            userObject.data()?[FirebaseModelParams.PROFILE_PICTURE] ?? "";
        senderDetail.senderName =
            userObject.data()?[FirebaseModelParams.USER_NAME] ?? "";
      }
      return senderDetail;
    } catch (ex) {
      logger.e(ex);
      return SenderDetail();
    }
  }

  /// navigate to user chat
  ///
  /// required [model].
  void navigateToUserChat(ChatThreadModel model) async {
    Get.lazyPut(() => PrivateChatController(),
        tag: "${Routes.PRIVATE_CHAT}/${model.userId}");

    final threadId = await GetIt.I<FireStoreManager>().getUserChatWith(
        myId: GetIt.I<PreferenceManager>().userUUID,
        friendId: model.userId ?? "");

    Get.toNamed(Routes.PRIVATE_CHAT, arguments: {
      RouteArguments.firebaseUserId: model.userId,
      RouteArguments.userId: model.dbUserId,
      RouteArguments.email: model.profile ?? "".trim(),
      RouteArguments.userName: model.userName,
      RouteArguments.threadId: threadId,
      RouteArguments.profilePicture: model.profile ?? "".trim(),
    });
  }

  /// Navigate to search user screen.
  void navigateToSearchUser() {
    if (GetIt.I<PreferenceManager>().isClub) {
      final ClubMainController controller0 = Get.find(tag: Routes.CLUB_MAIN);
      controller0.changeTabIndex(0);
    } else {
      Get.toNamed(Routes.PLAYER_CLUB_SEARCH);
      Future.delayed(const Duration(seconds: 1), () {
        final PlayerMainController controller =
            Get.find(tag: Routes.PLAYER_MAIN);
        controller.changeTabIndex(0);
      });
    }
  }
}
