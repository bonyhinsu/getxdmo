import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:game_on_flutter/infrastructure/model/club/home/notification_model.dart';
import 'package:game_on_flutter/presentation/app_widgets/club_profile_widget.dart';
import 'package:game_on_flutter/values/app_icons.dart';
import 'package:get/get.dart';

import '../../infrastructure/navigation/routes.dart';
import '../../values/app_colors.dart';
import '../../values/app_values.dart';
import '../../values/common_utils.dart';
import '../screens/home/club_notification/controllers/club_notification.controller.dart';

class NotificationTileWidget extends StatelessWidget {
  NotificationData postModel;
  int index;
  Function(int index, NotificationData postModel) onReadChange;
  final ClubNotificationController _controller =
      Get.find(tag: Routes.CLUB_NOTIFICATION);

  NotificationTileWidget(
      {required this.postModel,
      required this.index,
      Key? key,
      required this.onReadChange})
      : super(key: key);

  late TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return ListTile(
      contentPadding: const EdgeInsets.only(
          left: AppValues.mediumPadding,
          right: AppValues.mediumPadding,
          top: AppValues.halfPadding,
          bottom: AppValues.halfPadding),
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.transparent, width: 1),
          borderRadius: BorderRadius.circular(AppValues.roundedButtonRadius)),
      tileColor: AppColors.appTileBackground,
      onTap: () {
        onReadChange(index, postModel);
      },
      title: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: AppValues.height_4,
                    horizontal: AppValues.height_6),
                child: ClubProfileWidget(
                  isAssetUrl: false,
                  width: AppValues.size_55,
                  height: AppValues.size_55,
                  profileURL: postModel.fromUserDetails!.profileImage ?? "",
                ),
              ),
              const SizedBox(
                width: AppValues.height_6,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    nameWidget(),
                    const SizedBox(
                      height: 2,
                    ),
                    messageWidget(),
                  ],
                ),
              ),
              timeWidget(),
            ],
          ),
          Visibility(
            visible: postModel.isRead != "y",
            child: Row(children: [
              SvgPicture.asset(AppIcons.dot),
            ]),
          ),
        ],
      ),
    );
  }

  /// build name textview

  Widget nameWidget() {
    return Text(postModel.fromUserDetails!.name ?? "",
        textAlign: TextAlign.center,
        style: textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textColorSecondary,
        ));
  }

  /// build message textview

  Widget messageWidget() {
    return Text(postModel.description ?? "",
        textAlign: TextAlign.start,
        maxLines: 2,
        style: textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w400,
          color: AppColors.textColorWhite.withOpacity(0.7),
          fontSize: 13,
        ));
  }

  /// build time textview
  Widget timeWidget() {
    return Text(
        CommonUtils.getRemainingDaysInWord(postModel.createdAt ?? "",
            isUTC: true),
        textAlign: TextAlign.start,
        style: textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w400,
          color: AppColors.textColorWhite,
        ));
  }
}
