import 'package:flutter/material.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_button_mixin.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_player_profile_widget.dart';

import '../../infrastructure/model/common/block_unblock_response.dart';
import '../../values/app_colors.dart';
import '../../values/app_values.dart';

class BlockedUserListTileWidget extends StatelessWidget with AppButtonMixin {
  BlockUnblockUserResponseData model;
  Function(String userId, String userName) onUnblock;

  BlockedUserListTileWidget(
      {required this.model, required this.onUnblock, Key? key})
      : super(key: key);
  late TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
          vertical: AppValues.padding_6, horizontal: AppValues.mediumPadding),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppValues.roundedButtonRadius)),
      tileColor: AppColors.appWhiteButtonColor.withOpacity(0.1),
      title: Text(
        model.blockUserDetails?.name ?? "",
        style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
      ),
      leading: AppPlayerProfileWidget(
        profileURL: model.blockUserDetails?.profileImage ?? "",
      ),
      trailing: SizedBox(
          width: 90,
          height: 40,
          child: appGrayButton(
              title: "Unblock",
              onClick: () => onUnblock(model.blockUserId.toString(),
                  model.blockUserDetails?.name ?? ""))),
    );
  }
}
