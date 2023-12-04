import 'package:flutter/material.dart';
import 'package:game_on_flutter/presentation/screens/chats/private_chat/view/private_chat_message_tile.dart';
import 'package:get/get.dart';
import 'package:loadmore/loadmore.dart';

import '../../../../../infrastructure/model/chat/chat_message_model.dart';
import '../../../../../infrastructure/utils/my_load_more_delegate.dart';
import 'chat_date_widget.dart';
import 'loading_chats.dart';

class ChatBodyWidget extends StatelessWidget {
  bool isFinishLoadMore;

  Function() onPullToRefresh;
  Function(ChatMessageModel messageModel) onAttachedImageClick;

  List<ChatMessageModel> messageList;

  ScrollController itemScrollController;

  bool isChatLoading;

  ChatBodyWidget(
      {required this.isFinishLoadMore,
      required this.onPullToRefresh,
      required this.isChatLoading,
      required this.messageList,
      required this.onAttachedImageClick,
      required this.itemScrollController,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildChatThreadList();
  }

  /// Build chat thread list
  Widget buildChatThreadList() {
    return Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
        ),
        Obx(() => AnimatedSwitcher(
              duration: const Duration(milliseconds: 1400),
              child: messageList.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: LoadMore(
                        onLoadMore: () => onPullToRefresh(),
                        isFinish: isFinishLoadMore,
                        delegate: MyLoadMoreDelegate(),
                        whenEmptyLoad: true,
                        child: ListView.separated(
                            itemBuilder: (_, index) {
                              final chatObj = messageList[index];
                              if (chatObj.isDate) {
                                return ChatDateWidget(chatObj: chatObj);
                              }
                              switch (chatObj.messageType) {
                                default:
                                  return PrivateChatMessageRow(
                                    chatObj,
                                    onAttachedImageClick: onAttachedImageClick,
                                  );
                              }
                            },
                            separatorBuilder: (_, index) {
                              return const Divider(
                                height: 2,
                                color: Colors.transparent,
                              );
                            },
                            reverse: true,
                            controller: itemScrollController,
                            itemCount: messageList.length),
                      ),
                    )
                  : isChatLoading
                      ? const LoadingChatsShimmerWidget()
                      : buildStartNewChatWidget(),
            )),
      ],
    );
  }

  /// Empty view when no chat available.
  Widget buildStartNewChatWidget() {
    return Container();
  }
}
