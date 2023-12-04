import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_on_flutter/presentation/app_widgets/user_feature_mixin.dart';
import 'package:game_on_flutter/values/app_icons.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:get/get.dart';

import '../../../../../values/app_colors.dart';
import '../../../../../values/app_values.dart';

class ChatBottomWidget extends StatelessWidget with UserFeatureMixin {
  RxBool isAttachmentShowing = false.obs;

  late TextEditingController messageController;
  FocusNode messageFocusNode;
  Function() onSend;
  Function() onAttachmentClick;
  Function(bool visibleEmoji)? toggleEmojiKeyboard;
  ScrollController textFieldScrollController = ScrollController();
  bool emojiVisible = false;

  ChatBottomWidget(
      {required this.messageController,
      required this.messageFocusNode,
      required this.onAttachmentClick,
      required this.onSend,
      this.emojiVisible = false,
      this.toggleEmojiKeyboard,
      Key? key})
      : super(key: key);

  late ThemeData _themeData;

  @override
  Widget build(BuildContext context) {
    _themeData = Theme.of(context);
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      if (isKeyboardVisible && messageFocusNode.hasFocus && emojiVisible) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (toggleEmojiKeyboard != null) {
            toggleEmojiKeyboard!(false);
          }
        });
      }
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: inputRow),
                InkWell(
                  onTap: () => onSend(),
                  child: Container(
                    margin: const EdgeInsets.only(
                        left: 12, right: AppValues.size_15),
                    child: buildIconButton(icon: AppIcons.chatSendIcon),
                  ),
                ),
              ],
            ),
          ),
          buildMediaAttachmentRow()
        ],
      );
    });
  }

  /// Build input row widget.
  Widget get inputRow => Container(
        margin: const EdgeInsets.only(left: AppValues.height_20),
        decoration: BoxDecoration(
            color: AppColors.textColorSecondary.withOpacity(0.20),
            borderRadius: BorderRadius.circular(AppValues.radius_10)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            emojiIcon,
            Expanded(
              child: buildMessageTextField(),
            ),
            attachmentIcon
          ],
        ),
      );

  /// Build emoji icon widget.
  Widget get emojiIcon => InkWell(
        onTap: () => toggleEmojiKeyboard != null
            ? toggleEmojiKeyboard!(!emojiVisible)
            : null,
        child: Container(
          margin: const EdgeInsets.only(
              right: AppValues.size_12, left: AppValues.size_15, bottom: 14),
          child: SvgPicture.asset(AppIcons.chatSmileyIcon),
        ),
      );

  /// Build attachment icon widget.
  Widget get attachmentIcon => InkWell(
        onTap: onAttachmentClick,
        child: Container(
          margin: const EdgeInsets.only(
              left: AppValues.size_12, right: AppValues.size_15, bottom: 14),
          child: SvgPicture.asset(AppIcons.chatAttachment),
        ),
      );

  /// Build message text field.
  Widget buildMessageTextField() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: TextField(
        style: _themeData.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 14.0,
            color: AppColors.textColorSecondary),
        cursorColor: AppColors.inputFieldBorderColor,
        scrollController: textFieldScrollController,
        controller: messageController,
        keyboardType: TextInputType.multiline,
        maxLines: 3,
        minLines: 1,
        focusNode: messageFocusNode,
        cursorHeight: 20.0,
        onSubmitted: (text) => onSend,
        decoration: InputDecoration(
            filled: false,
            errorMaxLines: 5,

            hintStyle: _themeData.textTheme.headline5?.copyWith(
                fontSize: 14.0, color: AppColors.textColorLightTheme),
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            border: InputBorder.none,
            counterStyle: _themeData.textTheme.bodyText1!.merge(
              const TextStyle(
                color: AppColors.textPlaceholderColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            counterText: ''),
      ),
    );
  }

  /// Build media attachment row widget.
  Widget buildMediaAttachmentRow() => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: emojiVisible ? 280 : 0,
        child: emojiVisible ? buildEmojiPicker() : Container(),
      );

  /// Build media icon
  Widget buildMediaIcon(String text, Function onClick) {
    return InkWell(
      onTap: () => onClick(),
      child: Center(
          child: Text(
        text,
        style: const TextStyle(fontSize: 26),
      )),
    );
  }

  /// Return back button widget.
  Widget buildIconButton({Function? onClick, required String icon}) =>
      Container(
        decoration: BoxDecoration(
            color: AppColors.textColorSecondary.withOpacity(0.20),
            borderRadius: BorderRadius.circular(AppValues.smallRadius)),
        height: AppValues.chatSendButtonSize,
        width: AppValues.chatSendButtonSize,
        padding: const EdgeInsets.all(AppValues.smallPadding),
        child: SvgPicture.asset(icon),
      );

  /// Build emoji picker.
  Widget buildEmojiPicker() => EmojiPicker(
        onEmojiSelected: (Category? category, Emoji emoji) {
          // Do something when emoji is tapped (optional)
        },
        onBackspacePressed: () {
          // Do something when the user taps the backspace button (optional)
          // Set it to null to hide the Backspace-Button
        },
        textEditingController: messageController,
        config: Config(
          columns: 8,
          emojiSizeMax: 26 * (GetPlatform.isIOS ? 1.30 : 1.0),
          verticalSpacing: 0,
          horizontalSpacing: 0,
          gridPadding: EdgeInsets.zero,
          initCategory: Category.RECENT,
          bgColor: AppColors.textPlaceholderColor,
          indicatorColor: AppColors.appRedButtonColor,
          iconColor: Colors.grey,
          iconColorSelected: AppColors.appRedButtonColor,
          backspaceColor: AppColors.appRedButtonColor,
          skinToneDialogBgColor: Colors.white,
          skinToneIndicatorColor: Colors.grey,
          enableSkinTones: true,
          recentTabBehavior: RecentTabBehavior.POPULAR,
          recentsLimit: 28,
          noRecents: const Text(
            'No Recent',
            style: TextStyle(fontSize: 20, color: Colors.black26),
            textAlign: TextAlign.center,
          ),
          // Needs to be const Widget
          loadingIndicator: const SizedBox.shrink(),
          // Needs to be const Widget
          tabIndicatorAnimDuration: kTabScrollDuration,
          categoryIcons: const CategoryIcons(),
          buttonMode: ButtonMode.MATERIAL,
        ),
      );
}
