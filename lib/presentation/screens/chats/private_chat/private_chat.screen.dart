import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_on_flutter/presentation/app_widgets/base_view.dart';
import 'package:game_on_flutter/presentation/screens/chats/private_chat/view/block_user_message_widget.dart';
import 'package:game_on_flutter/presentation/screens/chats/private_chat/view/chat_body_widget.dart';
import 'package:game_on_flutter/presentation/screens/chats/private_chat/view/chat_bottom_loading_widget.dart';
import 'package:game_on_flutter/presentation/screens/chats/private_chat/view/chat_bottom_widget.dart';
import 'package:game_on_flutter/presentation/screens/chats/private_chat/view/follow_user_widget.dart';
import 'package:game_on_flutter/values/app_constant.dart';
import 'package:get/get.dart';

import '../../../../infrastructure/navigation/route_config.dart';
import '../../../../infrastructure/navigation/routes.dart';
import '../../../../values/app_colors.dart';
import '../../../../values/app_font_size.dart';
import '../../../../values/app_icons.dart';
import '../../../../values/app_string.dart';
import '../../../../values/app_values.dart';
import '../../../app_widgets/app_button_mixin.dart';
import '../../../app_widgets/app_player_profile_widget.dart';
import '../../../app_widgets/club_profile_widget.dart';
import '../../../app_widgets/user_feature_mixin.dart';
import 'controllers/private_chat.controller.dart';

class PrivateChatScreen extends StatefulWidget
    with UserFeatureMixin, AppButtonMixin, AppBarMixin {
  String uUId = "";

  late PrivateChatController _controller;

  PrivateChatScreen({Key? key}) : super(key: key);

  @override
  State<PrivateChatScreen> createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends State<PrivateChatScreen> {
  final GlobalKey<PopupMenuButtonState<int>> _key = GlobalKey();

  String uUId = "";

  late TextTheme textTheme;

  @override
  void initState() {
    if (Get.arguments != null) {
      widget.uUId = Get.arguments[RouteArguments.firebaseUserId] ?? "";
      Get.put(() => PrivateChatController(),
          tag: "${Routes.PRIVATE_CHAT}/${widget.uUId}");

      widget._controller =
          Get.find(tag: "${Routes.PRIVATE_CHAT}/${widget.uUId}");
    } else {
      Get.put(() => PrivateChatController(), tag: Routes.PRIVATE_CHAT);
      widget._controller = Get.find(tag: Routes.PRIVATE_CHAT);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return WillPopScope(
      onWillPop: () async {
        Get.delete<PrivateChatController>(
            tag: "${Routes.PRIVATE_CHAT}/${widget.uUId}");
        return true;
      },
      child: Obx(
        () => Scaffold(
          appBar: buildHeaderAppbar(),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppValues.height_14),
                    child: buildMessageListWidget(),
                  ),
                ),
                buildBottomBar()
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build header app bar widget
  AppBar buildHeaderAppbar() => AppBar(
        elevation: 0,
        backgroundColor: AppColors.pageBackground,
        leadingWidth: AppValues.appbarBackButtonSize + AppValues.screenMargin,
        centerTitle: true,
        leading: FittedBox(
          fit: BoxFit.contain,
          child: buildIconButton(
              icon: AppIcons.backArrowIcon,
              onClick: widget._controller.onBackPressed),
        ),
        title: GestureDetector(
          onTap: widget._controller.onViewProfile,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildClubProfilePicture(),
              const SizedBox(
                width: AppValues.height_10,
              ),
              Expanded(
                child: Text(
                  widget._controller.userName,
                  style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontFamily: FontConstants.poppins,
                      color: AppColors.textColorSecondary),
                ),
              )
            ],
          ),
        ),
        actions: [
          if (widget._controller.followedUser.isTrue)
            Padding(
              padding: const EdgeInsets.only(
                  right: AppValues.appbarTopMargin,
                  top: AppValues.appbarTopMargin,
                  bottom: AppValues.appbarTopMargin),
              child: Padding(
                padding: const EdgeInsets.only(right: AppValues.height_20),
                child: PopupMenuButton<int>(
                  key: _key,
                  elevation: 4,
                  color: AppColors.pageBackground.withOpacity(0.9),
                  itemBuilder: (context) {
                    return <PopupMenuEntry<int>>[
                      PopupMenuItem(
                        value: 0,
                        onTap: widget._controller.showUnfollowUserDialog,
                        height: AppValues.iconSize_24,
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              AppIcons.postCloseIcon,
                              color: AppColors.textColorSecondary,
                            ),
                            size10,
                            Text(AppString.unfollow,
                                style: textTheme.headlineSmall
                                    ?.copyWith(fontSize: 14)),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem(
                        value: 1,
                        onTap: widget._controller.onBlock,
                        height: AppValues.iconSize_24,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.block,
                              size: 14,
                              color: AppColors.textColorSecondary,
                            ),
                            size10,
                            Text(AppString.block,
                                style: textTheme.headlineSmall
                                    ?.copyWith(fontSize: 14)),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem(
                        value: 1,
                        onTap: widget._controller.onBlockedList,
                        height: AppValues.iconSize_24,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.block,
                              size: 14,
                              color: AppColors.textColorSecondary,
                            ),
                            size10,
                            Text(AppString.blockedUserList,
                                style: textTheme.headlineSmall
                                    ?.copyWith(fontSize: 14)),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem(
                        value: 2,
                        onTap: widget._controller.onReport,
                        height: AppValues.iconSize_24,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.report_outlined,
                              size: 14,
                              color: AppColors.textColorSecondary,
                            ),
                            size10,
                            Text(AppString.report,
                                style: textTheme.headlineSmall
                                    ?.copyWith(fontSize: 14)),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem(
                          onTap: () => widget._controller
                              .onClearChatConfirmationDialog(),
                          height: AppValues.iconSize_24,
                          value: 3,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.clear,
                                size: 14,
                                color: AppColors.textColorSecondary,
                              ),
                              size10,
                              Text(
                                AppString.strClearChat,
                                style: textTheme.headlineSmall
                                    ?.copyWith(fontSize: 14),
                              ),
                            ],
                          )),
                      const PopupMenuDivider(),
                      PopupMenuItem(
                          onTap: () =>
                              widget._controller.deleteChatConfirmation(),
                          height: AppValues.iconSize_24,
                          value: 4,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.delete_outline,
                                size: 14,
                                color: AppColors.appRedButtonColor,
                              ),
                              size10,
                              Text(
                                AppString.strDeleteChat,
                                style: textTheme.headlineSmall
                                    ?.copyWith(fontSize: 14),
                              ),
                            ],
                          )),
                    ];
                  },
                  child: SizedBox(
                    width: AppValues.iconSize_24,
                    height: AppValues.iconSize_24,
                    child: SvgPicture.asset(
                      AppIcons.moreVertical,
                    ),
                  ),
                ),
              ),
            )
        ],
      );

  /// Build margin 10.
  Widget get size10 => const SizedBox(
        width: AppValues.margin_10,
      );

  /// Build club profile picture.
  Widget buildClubProfilePicture() {
    return Padding(
      padding: const EdgeInsets.only(
          top: AppValues.appbarTopMargin, bottom: AppValues.appbarTopMargin),
      child: widget._controller.userType == AppConstants.userTypeClub
          ? ClubProfileWidget(
              profileURL: widget._controller.userProfile,
            )
          : AppPlayerProfileWidget(profileURL: widget._controller.userProfile),
    );
  }

  /// Return back button widget.
  Widget buildIconButton({Function? onClick, required String icon}) =>
      GestureDetector(
        onTap: onClick == null ? () => Get.back() : () => onClick(),
        child: Container(
          margin: const EdgeInsets.only(
              left: AppValues.screenMargin,
              top: AppValues.appbarTopMargin,
              bottom: AppValues.appbarTopMargin),
          decoration: BoxDecoration(
              border: Border.all(
                  color: AppColors.textColorSecondary.withOpacity(0.1),
                  width: 1),
              color: AppColors.textFieldBackgroundColor,
              borderRadius: BorderRadius.circular(AppValues.smallRadius)),
          height: AppValues.appbarBackButtonSize,
          width: AppValues.appbarBackButtonSize,
          padding: const EdgeInsets.all(AppValues.smallPadding),
          child: SvgPicture.asset(icon),
        ),
      );

  /// Build bottomBar widget
  Widget buildBottomBar() => AnimatedSwitcher(
        duration: const Duration(seconds: 1),
        child: widget._controller.isLoading.isTrue
            ? ChatBottomLoadingWidget()
            : widget._controller.userBlockedMe.isTrue ||
                    widget._controller.blockedUserByMe.isTrue
                ? BlockUserMessageWidget(
                    isBlockByMe: widget._controller.blockedUserByMe.isTrue,
                  )
                : widget._controller.followedUser.value
                    ? ChatBottomWidget(
                        emojiVisible: widget._controller.isEmojiVisible.value,
                        onSend: widget._controller.onSendMessageClick,
                        toggleEmojiKeyboard:
                            widget._controller.toggleEmojiKeyboard,
                        messageController:
                            widget._controller.messageTextEditingController,
                        messageFocusNode: widget._controller.messageFocusNode,
                        onAttachmentClick:
                            widget._controller.captureImageFromInternal,
                      )
                    : FollowUserWidget(
                        userName: widget._controller.userName,
                        onFollowClick: widget._controller.onFollowClick,
                      ),
      );

  /// Build message list widget.
  Widget buildMessageListWidget() => ChatBodyWidget(
        isFinishLoadMore: widget._controller.isFinishLoadMore.value,
        onPullToRefresh: widget._controller.getUserChats,
        isChatLoading: widget._controller.isLoading.value,
        messageList: widget._controller.messageList,
        itemScrollController: widget._controller.itemScrollController,
        onAttachedImageClick: widget._controller.onAttachedImageClick,
      );
}
