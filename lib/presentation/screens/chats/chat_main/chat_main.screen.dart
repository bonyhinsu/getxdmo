import 'package:flutter/material.dart';
import 'package:game_on_flutter/infrastructure/model/common/app_fields.dart';
import 'package:game_on_flutter/infrastructure/storage/preference_manager.dart';
import 'package:game_on_flutter/presentation/screens/chats/chat_main/view/chat_main_shimmer_widget.dart';
import 'package:game_on_flutter/presentation/screens/chats/chat_main/view/chat_tile_widget.dart';
import 'package:game_on_flutter/presentation/screens/chats/chat_main/view/disabled_chat_screen.dart';
import 'package:game_on_flutter/values/app_colors.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:game_on_flutter/values/app_values.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../infrastructure/navigation/routes.dart';
import '../../../app_widgets/app_button_mixin.dart';
import '../../../app_widgets/user_feature_mixin.dart';
import 'controllers/chat_main.controller.dart';

class ChatMainScreen extends GetView<ChatMainController>
    with UserFeatureMixin, AppButtonMixin {
  final ChatMainController _controller = Get.find(tag: Routes.CHAT_MAIN);

  ChatMainScreen({Key? key}) : super(key: key);

  late TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    _controller.getUserThreads();
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppValues.screenMargin),
            child: SizedBox(
              width: double.infinity,
              child: RefreshIndicator(
                onRefresh: _controller.onRefreshThreads,
                child: Obx(
                  () => buildChatBody(),
                ),
              ),
            ),
          ),
          if (AppFields.instance.subscriptionExpired || !AppFields.instance.enableChat) DisabledChatScreen()
        ],
      ),
    );
  }

  /// Build chat body widget.
  Widget buildChatBody() {
    final isChatsAvailable = _controller.threadListSet.isNotEmpty;

    final isLoading =
        _controller.isLoading.value && _controller.threadListSet.isEmpty;

    final isShowStartChat =
        _controller.threadListSet.isEmpty && _controller.isLoading.isFalse;

    return isLoading
        ? const ChatMainShimmerWidget()
        : isChatsAvailable
            ? buildListUI()
            : isShowStartChat
                ? AppFields.instance.enableChat?buildNoChatView():Container()
                : Container();
  }

  /// Build chat main list UI
  Widget buildListUI() {
    return ListView.separated(
      itemBuilder: (_, index) {
        return ChatMainTileWidget(
          model: _controller.threadListSet.elementAt(index),
          onTap: _controller.navigateToUserChat,
        );
      },
      separatorBuilder: (_, index) {
        return const Divider(
          height: AppValues.height_10,
          color: Colors.transparent,
        );
      },
      itemCount: _controller.threadListSet.length,
    );
  }

  /// Build no chat UI.
  Widget buildNoChatView() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(AppString.noMessageTitle,
              style: textTheme.headlineMedium
                  ?.copyWith(color: AppColors.textColorSecondary)),
          const SizedBox(
            height: AppValues.height_20,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppValues.margin_50),
            child: Text(
                GetIt.I<PreferenceManager>().isClub
                    ? AppString.noMessageInformationText
                    : AppString.noClubsFound,
                textAlign: TextAlign.center,
                style: textTheme.displaySmall
                    ?.copyWith(color: AppColors.textColorDarkGray)),
          ),
          const SizedBox(
            height: AppValues.margin_30,
          ),
          SizedBox(
              width: 120,
              child: appGrayButton(
                  title: GetIt.I<PreferenceManager>().isClub
                      ? AppString.strSearchPlayer
                      : AppString.strSearchClub,
                  onClick: () => _controller.navigateToSearchUser())),
        ],
      );
}
