import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:game_on_flutter/infrastructure/navigation/route_config.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_dialog_widget.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_loading_mixin.dart';
import 'package:game_on_flutter/presentation/app_widgets/base_bottomsheet.dart';
import 'package:game_on_flutter/values/app_colors.dart';
import 'package:game_on_flutter/values/app_values.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../../../../infrastructure/firebase/firestore_manager.dart';
import '../../../../../infrastructure/model/chat/chat_message_model.dart';
import '../../../../../infrastructure/model/club/profile/upload_user_profile_response.dart';
import '../../../../../infrastructure/model/common/app_fields.dart';
import '../../../../../infrastructure/model/user_detail_response_model.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../infrastructure/network/api_utils.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../infrastructure/notification_service.dart';
import '../../../../../infrastructure/storage/preference_manager.dart';
import '../../../../../values/app_constant.dart';
import '../../../../../values/app_string.dart';
import '../../../../../values/common_utils.dart';
import '../../../../../values/firebase_constants.dart';
import '../../../../app_widgets/app_dialog_with_title_widget_two.dart';
import '../../../../app_widgets/image_capture_helper.dart';
import '../../../block_unblock/controller/block_unblock.controller.dart';
import '../../../follow_unfollow/follow_unfollow.controller.dart';
import '../../../home/club_player_detail/controllers/club_player_detail.controller.dart';
import '../../../report_user/controller/report_app_user.controller.dart';
import '../../chat_main/controllers/chat_main.controller.dart';
import '../provider/private_chat_provider.dart';
import '../view/report_user_widget.dart';

class PrivateChatController extends GetxController with AppLoadingMixin {
  /// Logger
  final logger = Logger();

  /// Message Pagination message limit.
  static const int limit = 30;

  /// Provider
  final _provider = PrivateChatProvider();

  /// Private Fields
  String _myId = "";
  String _myName = "";
  String _myProfilePicture = "";
  String _myEmail = "";
  String _friendUseFirebaseId = "";
  String _userId = "";
  String _threadId = "";
  String _userName = "";
  String _userEmail = "";
  String _userProfile = "";
  String _message = "";
  String messageDate = "";
  int userType = AppConstants.userTypeClub;

  /// message textField's controller.
  TextEditingController messageTextEditingController =
      TextEditingController(text: "");

  /// message textField's focus node.
  FocusNode messageFocusNode = FocusNode();

  /// last message timestamp.
  ///
  /// Mark: used for pagination.
  Timestamp? lastMessageTimestamp;

  /// last document added id.
  ///
  /// Mark: used for pagination.
  DocumentSnapshot? lastDocId;

  /// Main chat message list
  RxList<ChatMessageModel> messageList = RxList();

  /// Item scroll controller.
  final ScrollController itemScrollController = ScrollController();

  /// Hold true to identify need to load next page or not for
  /// LoadMore widget.
  RxBool isFinishLoadMore = false.obs;

  /// Hold true to check if emoji keyboard is visible or not.
  RxBool isEmojiVisible = false.obs;

  /// Return [_friendUseFirebaseId]
  String get friendUseFirebaseId => _friendUseFirebaseId;

  /// set [value] to local field[_friendUseFirebaseId].
  set friendUseFirebaseId(String value) {
    _friendUseFirebaseId = value.trim();
  }

  /// Return [_userId]
  String get userId => _userId;

  /// set [value] to local field[_userId].
  set userId(String value) {
    _userId = value.trim();
  }

  /// Return [_threadId]
  String get threadId => _threadId;

  /// set [value] to local field[_threadId].
  set threadId(String value) {
    _threadId = value.trim();
  }

  /// Return [_userName]
  String get userName => _userName;

  /// set [value] to local field[_userName].
  set userName(String value) {
    _userName = value.trim();
  }

  /// Return [_userEmail]
  String get userEmail => _userEmail;

  /// set [value] to local field[_userEmail].
  set userEmail(String value) {
    _userEmail = value.trim();
  }

  /// Return [_userProfile]
  String get userProfile => _userProfile;

  /// set [value] to local field[_userProfile].
  set userProfile(String value) {
    _userProfile = value.trim();
  }

  /// Return [_myId]
  String get myId => _myId;

  /// set [value] to local field[_myId].
  set myId(String value) {
    _myId = value.trim();
  }

  /// Return [_myName]
  String get myName => _myName;

  /// set [value] to local field[_myName].
  set myName(String value) {
    _myName = value;
  }

  /// Return [_myProfilePicture]
  String get myProfilePicture => _myProfilePicture;

  /// set [value] to local field[_myProfilePicture].
  set myProfilePicture(String value) {
    _myProfilePicture = value;
  }

  /// Return [_myEmail]
  String get myEmail => _myEmail;

  /// set [value] to local field[_myEmail].
  set myEmail(String value) {
    _myEmail = value;
  }

  /// Return [_message]
  String get message => _message;

  /// set [value] to local field[_message].
  set message(String value) {
    _message = value.trim();
  }

  /// Initialise image capture helper
  final _imageHelper = ImageCaptureHelper();

  /// Check if current user follows to the other club/player or not.
  RxBool followedUser = false.obs;

  /// Check if the viewing user is blocked by me or not.
  RxBool blockedUserByMe = false.obs;

  /// Check if the viewing has blocked me or not.
  RxBool userBlockedMe = false.obs;

  @override
  void onInit() {
    showLoading();
    _setInitialFields();
    _getArguments();
    super.onInit();
    NotificationService().clearNotification(threadId);
  }

  /// Set initial fields.
  void _setInitialFields() async {
    myId = GetIt.I<PreferenceManager>().userUUID;
    GetIt.I<FireStoreManager>().getUserDetails(userId: myId).then((value) {
      myName = value.data()?[FirebaseModelParams.USER_NAME] ?? "";
      myProfilePicture =
          value.data()?[FirebaseModelParams.PROFILE_PICTURE] ?? "";
    });
  }

  /// Receive arguments from previous screen.
  void _getArguments() async {
    if (Get.arguments != null) {
      userName = Get.arguments[RouteArguments.userName] ?? "";

      userEmail = Get.arguments[RouteArguments.email] ?? "";

      friendUseFirebaseId = Get.arguments[RouteArguments.firebaseUserId] ?? "";

      userId = Get.arguments[RouteArguments.userId] ?? "";

      threadId = Get.arguments[RouteArguments.threadId] ?? "";

      userProfile = Get.arguments[RouteArguments.profilePicture] ?? "";

      getUserChats();
      _checkForBlockStatus();
      _getUserDetail();
    }

    final userDetails = await GetIt.I<FireStoreManager>()
        .getUserDetails(userId: friendUseFirebaseId);

    userType = userDetails.data()?[FirebaseModelParams.USER_TYPE];
  }

  /// Get Contacts which which are registered on app.
  Future<bool> getUserChats({
    int pageLimit = 50,
  }) async {
    await FireStoreManager.instance
        .getChatMessages(threadId, limit, lastDocId: lastDocId)
        .then((value) {
      final document = value.docs.reversed;
      if (document.isNotEmpty) {
        lastDocId = document.first;
      } else {
        showLoading();
      }

      for (var event in document) {
        _prepareMessageData(event);
      }

      try {
        lastMessageTimestamp = document.isNotEmpty
            ? document.first.data()[FirebaseModelParams.messageTime] ?? ""
            : null;
      } catch (ex) {
        logger.e(ex);
      }
    });
    hideLoading();
    isFinishLoadMore.value = lastMessageTimestamp == null;

    return lastMessageTimestamp != null;
  }

  /// Prepare message model and add to message list
  void _prepareMessageData(QueryDocumentSnapshot element) {
    if (element.exists) {
      final isSentByMe =
          (element.data().toString().contains(FirebaseModelParams.sentBy)
                  ? element.get(FirebaseModelParams.sentBy)
                  : "") ==
              myId;

      ChatMessageModel messageModel = ChatMessageModel();
      messageModel.messageId = element.id;
      messageModel.messageType =
          element.data().toString().contains(FirebaseModelParams.messageType)
              ? element.get(FirebaseModelParams.messageType)
              : AppConstants.textMessage;
      messageModel.messageText =
          element.data().toString().contains(FirebaseModelParams.messageText)
              ? element.get(FirebaseModelParams.messageText)
              : "";
      messageModel.timestamp =
          element.data().toString().contains(FirebaseModelParams.messageTime)
              ? element.get(FirebaseModelParams.messageTime)
              : "";

      bool hasAttachment = element.get(FirebaseModelParams.hasAttachment) == 1;
      messageModel.hasAttachment = hasAttachment;
      if (hasAttachment) {
        messageModel.attachmentType = element
                .data()
                .toString()
                .contains(FirebaseModelParams.attachmentType)
            ? element.get(FirebaseModelParams.attachmentType)
            : AppConstants.image.toLowerCase();

        messageModel.attachmentURL =
            element.get(FirebaseModelParams.attachment) ?? "";
      }
      messageModel.sentByMe = isSentByMe;

      final senderMap =
          SenderDetail.fromMap(element.get(FirebaseModelParams.sender));
      messageModel.senderDetail = senderMap;
      messageModel.affectedUserId = senderMap.userId;

      /// ------------- Prepare date widget--------------------
      _checkForDateTimeDifference(messageModel);

      messageList.insert(0, messageModel);
    }
  }

  /// Get date and time difference.
  void _checkForDateTimeDifference(ChatMessageModel messageModel) {
    try {
      String chatTime = "";
      final DateTime serverTimeStamp =
          (messageModel.timestamp as Timestamp).toDate();
      chatTime = DateFormat('dd/MM/yyyy').format(serverTimeStamp);
      if (messageDate.isEmpty) {
        messageDate = chatTime;
        ChatMessageModel model = ChatMessageModel();
        model.isDate = true;
        model.timestamp = messageModel.timestamp;
        messageList.insert(messageList.length, model);
      } else if (messageDate != chatTime) {
        ChatMessageModel model = ChatMessageModel();
        messageDate = chatTime;
        model.isDate = true;
        model.timestamp = messageModel.timestamp;
        messageList.insert(0, model);
      }
    } catch (ex) {
      print(ex);
    }
  }

  /// toggle emoji keyboard
  void toggleEmojiKeyboard(bool visibleEmoji) {
    if (visibleEmoji) {
      messageFocusNode.unfocus();
    }
    isEmojiVisible.value = visibleEmoji;
  }

  /// Add first private chat message.
  void addInitialMessageForPrivateChat(Timestamp timestamp) {
    ChatMessageModel model = ChatMessageModel();
    model.timestamp = timestamp;
    messageList.insert(0, model);
  }

  /// Send message request
  Future<void> sendMessageToFriend(
      {String attachmentUrl = "",
      String attachmentType = "",
      bool hasAttachment = false}) async {
    if (message.isNotEmpty || attachmentUrl.isNotEmpty) {
      GetIt.I<FireStoreManager>().sendPrivateMessage(
        senderId: myId,
        receiverId: friendUseFirebaseId,
        attachmentUrl: hasAttachment ? attachmentUrl : "",
        attachmentType: attachmentType,
        message: message.trim(),
      );
      onMessageSent(attachmentUrl);
    }
  }

  /// function call when message sent.
  void onMessageSent(String attachmentUrl) {
    // Prepare message model.
    final messageModel = prepareMessageModel(attachmentUrl);

    _addMessageAndScrollToBottom(messageModel);

    sendNotificationToUser(messageModel: messageModel);
  }

  /// send notification to user.
  Future sendNotificationToUser(
      {required ChatMessageModel messageModel}) async {
    ///Send Push notification for receiver using FCM
    final userCollection =
        FirebaseFirestore.instance.collection(FirebaseDocumentConstants.users);

    final receiverMap = await userCollection.doc(friendUseFirebaseId).get();

    final receiverToken = receiverMap[FirebaseModelParams.fcmToken] ?? "";

    final sendNotificationToUsers = [receiverToken];

    if (sendNotificationToUsers.isEmpty) {
      return;
    }

    String strMessageModel = json.encode(messageModel.toJson());

    final notificationBody = ((messageModel.attachmentType ?? "") == "" ||
            messageModel.attachmentType == AppConstants.text.toLowerCase())
        ? messageModel.messageText ?? ""
        : messageModel.attachmentType == AppConstants.image.toLowerCase()
            ? AppConstants.image.toUpperCase()
            : AppConstants.gif.toUpperCase();

    /// Send notification to another user.
    NotificationService().sendFCMPushNotifications([receiverToken],
        notificationPayload: strMessageModel,
        senderName: messageModel.senderDetail?.senderName ?? "",
        body: notificationBody,
        senderUserId: myId,
        userId: userId,
        receiverUserId: friendUseFirebaseId);
  }

  /// returns [ChatMessageModel] to add in the user message list.
  ChatMessageModel prepareMessageModel(String attachmentUrl) {
    SenderDetail senderDetail = SenderDetail();
    senderDetail.userId = myId;
    senderDetail.senderName = myName;
    senderDetail.profilePicture = myProfilePicture;

    ChatMessageModel messageModel = ChatMessageModel();
    messageModel.messageId = threadId;
    messageModel.sentByMe = true;
    messageModel.messageType = AppConstants.textMessage;
    messageModel.messageText = message.trim();
    messageModel.attachmentType =
        message.trim().isEmpty ? AppConstants.image : AppConstants.text;
    messageModel.attachmentURL = attachmentUrl;
    messageModel.hasAttachment = attachmentUrl.isNotEmpty;
    messageModel.senderDetail = senderDetail;
    messageModel.timestamp = Timestamp.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch);
    return messageModel;
  }

  /// Add message to [messageList] and scroll list to last element.
  void _addMessageAndScrollToBottom(ChatMessageModel messageModel) {
    // Prevent duplicate message append to the list
    if (messageList.isNotEmpty) {
      final objLastMessage = messageList[0];
      if (!objLastMessage.isDate) {
        if (objLastMessage.timestamp?.millisecondsSinceEpoch ==
            messageModel.timestamp?.millisecondsSinceEpoch) {
          return;
        }
      }
    }
    // Check if last message date is different or not.
    _checkForLastMessageDate();

    messageList.insert(0, messageModel);
    message = "";

    // Scroll to bottom.
    _scrollToBottom();
  }

  void _checkForLastMessageDate() {
    final DateTime todayDate = DateTime.now();
    final today = DateFormat('dd/MM/yyyy').format(todayDate);

    if (messageList.isNotEmpty) {
      final isDate = messageList[0].isDate;

      if (!isDate) {
        final DateTime lastMessageDate =
            (messageList[0].timestamp as Timestamp).toDate();
        final chatTime = DateFormat('dd/MM/yyyy').format(lastMessageDate);

        if (chatTime != today) {
          ChatMessageModel model = ChatMessageModel();
          messageDate = today;
          model.isDate = true;
          model.timestamp = Timestamp.fromMillisecondsSinceEpoch(
              DateTime.now().millisecondsSinceEpoch);
          messageList.insert(0, model);
        }
      }
    } else {
      ChatMessageModel model = ChatMessageModel();
      messageDate = today;
      model.isDate = true;
      model.timestamp = Timestamp.fromMillisecondsSinceEpoch(
          DateTime.now().millisecondsSinceEpoch);
      messageList.insert(0, model);
    }
  }

  /// Animate scroll to bottom.
  void _scrollToBottom() {
    if (itemScrollController.hasClients) {
      itemScrollController.animateTo(
        itemScrollController.position.minScrollExtent,
        duration: const Duration(
          milliseconds: 200,
        ),
        curve: Curves.easeInOut,
      );
    }
  }

  /// on Back click
  void onBackPressed() => Get.back();

  /// Set message on click.
  void onSendMessageClick() {
    if (messageTextEditingController.text.trim().isNotEmpty) {
      message = messageTextEditingController.text.trim();
      _clearTextField();
      sendMessageToFriend();
    }
    messageFocusNode.requestFocus();
  }

  /// add attachment
  void onAttachment() {
    if (messageTextEditingController.text.trim().isNotEmpty) {
      message = messageTextEditingController.text.trim();
      _clearTextField();
      sendMessageToFriend();
    }
    messageFocusNode.requestFocus();
  }

  /// add message to list.
  void addMessageToList(ChatMessageModel messageModel) {
    messageModel.sentByMe = false;
    _checkForDateTimeDifference(messageModel);
    _addMessageAndScrollToBottom(messageModel);
  }

  /// clear text fields.
  void _clearTextField() {
    messageTextEditingController.text = "";
  }

  /// On block select.
  void onBlock() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Get.dialog(AppDialogWidget(
          dialogText: "Are you sure you want to block $userName?",
          onDone: () {
            _onBlock();
          }));
    });
  }

  /// On blocked list select.
  void onBlockedList() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Get.toNamed(Routes.BLOCKED_USERS);
    });
  }

  /// On report select
  void onReport() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Get.bottomSheet(
              BaseBottomsheet(
                  title: 'Report $userName',
                  child: ReportUserWidget(
                    onReportClick: reportUser,
                  )),
              isScrollControlled: true)
          .then((value) => {});
    });
  }

  /// on unfollow select
  void onUnfollow() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Get.dialog(AppDialogWidget(
          dialogText: "Are you sure you want to unfollow $userName?",
          onDone: () {
            _onUnfollow();
          }));
    });
  }

  /// on unfollow user and navigate to back.
  void _onUnfollow() {
    Get.back();
  }

  /// On user wants to block the other user.
  void _onBlock() {
    BlockUnblockController blockUnblockController = Get.find();
    blockUnblockController.blockUnblockUser(userId).then((value) {
      blockedUserByMe.value = true;
      blockedUserByMe.refresh();
    });
  }

  /// on view profile.
  void onViewProfile() async {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (GetIt.I<PreferenceManager>().isClub) {
        Get.toNamed(Routes.CLUB_PLAYER_DETAIL, arguments: {
          RouteArguments.userId: userId.toString(),
          RouteArguments.playerDetailViewTypeEnum: PlayerDetailViewTypeEnum.chat
        });
      } else {
        Get.toNamed(Routes.CLUB_DETAIL, arguments: {
          RouteArguments.userId: userId.toString(),
        });
      }
    });
  }

  /// on clear chat confirmation dialog.
  void onClearChatConfirmationDialog() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Get.dialog(AppDialogWidget(
          dialogText:
              "Are you sure to clear message all history with $userName?",
          onDone: () {
            _onClearChat();
          }));
    });
  }

  /// Delete chat confirmation
  void deleteChatConfirmation() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Get.dialog(
        AppDialogWidget(
            dialogText:
                "Are you sure you want to delete chat history with $userName?",
            onDone: () {
              _onDeleteChat(forceNavigateToBack: true);
            }),
      );
    });
  }

  /// On delete chat.
  Widget buildButton(
      {required String title,
      bool isPrimary = false,
      required Function() onClick}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: onClick,
        child: Container(
          width: double.infinity,
          height: 44,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              border: isPrimary
                  ? null
                  : Border.all(color: AppColors.appTileBackground),
              color: isPrimary
                  ? Theme.of(Get.context!).primaryColor
                  : Colors.white),
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(Get.context!).textTheme.bodyLarge?.copyWith(
                  color: isPrimary ? Colors.white : Colors.black,
                  fontSize: 14.0),
            ),
          ),
        ),
      ),
    );
  }

  /// get user detail API.
  void _getUserDetail() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showLoading();
      dio.Response? response = await _provider.getUserDetail(userId: userId);
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _getUserDetailSuccess(response);
        } else {
          /// On Error
          _getUserDetailError(response);
        }
      } else {
        hideLoading();
        GetIt.I<CommonUtils>().showServerDownError();
      }
    } else {
      hideLoading();
      GetIt.I<CommonUtils>().showNetworkError();
    }
  }

  /// Get user detail success API response
  void _getUserDetailSuccess(dio.Response response) {
    hideLoading();
    UserDetailResponseModel userDetailResponseModel =
        UserDetailResponseModel.fromJson(response.data);
    if (userDetailResponseModel.data != null) {
      final userDetails = userDetailResponseModel.data!;
      followedUser.value = userDetails.isFollow == 1;
      followedUser.refresh();
    }
  }

  /// Get user detail api error.
  void _getUserDetailError(dio.Response response) {
    hideGlobalLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }

  /// On clear chat
  void _onClearChat() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      showGlobalLoading();
      FireStoreManager.instance
          .clearChatForUser(threadId, myName)
          .then((value) {
        messageList.clear();
        messageList.refresh();
      });
      _refreshThreads();
    });
    Future.delayed(
        const Duration(milliseconds: AppValues.chatClearHistoryOperationDelay),
        () {
      hideGlobalLoading();
    });
  }

  /// On delete chat.
  void _onDeleteChat({bool forceNavigateToBack = false}) {
    FireStoreManager.instance
        .deleteUserChats(friendUseFirebaseId, threadId, false, true)
        .then((value) async {
      if (forceNavigateToBack) {
        //---------------  Update chat threads ---------------
        _refreshThreads();

        //---------------  Navigate to back ---------------
        if (GetIt.I<PreferenceManager>().isClub) {
          Get.until((route) => route.settings.name == Routes.CLUB_MAIN);
        } else {
          Get.until((route) => route.settings.name == Routes.PLAYER_MAIN);
        }
      }
    });
  }

  /// on attach image click.
  void onAttachedImageClick(ChatMessageModel messageModel) {
    Get.toNamed(Routes.IMAGE_PREVIEW, arguments: {
      RouteArguments.imageURL: (messageModel.attachmentURL ?? "").isNotEmpty
          ? '${AppFields.instance.imagePrefix}${messageModel.attachmentURL}'
          : '',
      RouteArguments.heroTag: "${messageModel.timestamp}",
    });
  }

  /// Capture image from internal storage.
  void captureImageFromInternal() async {
    final capturedImage = await _imageHelper.getImage(onRemoveImage: () {});
    if (capturedImage.isNotEmpty) {
      uploadChatAttachment(capturedImage);
    }
  }

  /// show image preview
  void _showImagePreview(String imagePath) {
    FocusManager.instance.primaryFocus?.unfocus();
    sendMessageToFriend(
            hasAttachment: imagePath.isNotEmpty,
            attachmentUrl: imagePath,
            attachmentType: AppConstants.image.toLowerCase())
        .then((value) => {});
  }

  /// Refresh threads.
  void _refreshThreads() {
    bool isControllerRegister =
        Get.isRegistered<ChatMainController>(tag: Routes.CHAT_MAIN);
    if (isControllerRegister) {
      final ChatMainController chatMainThreadController =
          Get.find(tag: Routes.CHAT_MAIN);
      chatMainThreadController.onRefreshThreads();
    }
  }

  /// Upload chat attachment image API.
  void uploadChatAttachment(String imagePath) async {
    try {
      if (await NetworkConnectivity.instance.hasNetwork()) {
        showGlobalLoading();
        dio.Response? response =
            await _provider.uploadUserAttachment(File(imagePath));
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _uploadUserProfileSuccess(response);
        } else {
          /// On Error
          _uploadAPIError(response);
        }
      }
    } catch (ex) {
      logger.e(ex);
      hideGlobalLoading();
      CommonUtils.showErrorSnackBar(message: ex.toString());
    }
  }

  /// Upload user profile success
  void _uploadUserProfileSuccess(dio.Response response) {
    hideGlobalLoading();

    UploadUserProfileResponse userDetailResponseModel =
        UploadUserProfileResponse.fromJson(response.data);

    _showImagePreview(userDetailResponseModel.data?.url ?? "");
  }

  /// Perform upload api error.
  void _uploadAPIError(dio.Response response) {
    hideGlobalLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response, isFromLogin: true);
  }

  /// Show unfollow warning dialog.
  void showUnfollowUserDialog() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Get.dialog(AppDialogWithTitleWidgetTwo(
        cancelButtonText: AppString.cancel,
        doneButtonText: AppString.unfollow,
        onDone: _onUnfollowUser,
        dialogText: AppString.unfollowPlayerWarningMessage,
        dialogTitle: 'Unfollow $userName?',
      ));
    });
  }

  /// On cancel subscription.
  void _onUnfollowUser() {
    FollowUnfollowController unfollowController = Get.find();
    unfollowController.followUnfollowUser(userId).then((value) {
      if (value) {
        followedUser.value = false;
        followedUser.refresh();
      }
    });
  }

  /// Show unfollow warning dialog.
  void onFollowClick() {
    FollowUnfollowController unfollowController = Get.find();
    unfollowController.followUnfollowUser(userId).then((value) {
      if (value) {
        followedUser.value = true;
        followedUser.refresh();
      }
    });
  }

  /// Show unfollow warning dialog.
  void _checkForBlockStatus() {
    BlockUnblockController blockUnblockController = Get.find();
    blockUnblockController.getBlockStatus(userId).then((value) {
      blockedUserByMe.value = value.isUserBlockByMe ?? false;
      userBlockedMe.value = value.isUserBlockMe ?? false;
    });
  }

  /// Report user confirmation dialog
  void reportUser(int itemId, String reason) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Get.dialog(AppDialogWithTitleWidgetTwo(
        cancelButtonText: AppString.cancel,
        doneButtonText: AppString.report,
        onDone: () => _onReportUser(itemId, reason),
        dialogText: AppString.reportUserWarningMessage,
        dialogTitle: 'Report $userName?',
      ));
    });
  }

  /// Show report API
  void _onReportUser(int itemId, String reason) {
    Get.lazyPut<ReportAppUserController>(
      () => ReportAppUserController(),
    );
    Get.back();
    ReportAppUserController reportAppUserController = Get.find();
    reportAppUserController.reportUser(userId, itemId, reason).then((value) {
      if (value) {
        Get.back();
      }
    });
  }
}
