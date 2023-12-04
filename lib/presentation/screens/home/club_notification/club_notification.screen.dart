import 'package:flutter/material.dart';
import 'package:game_on_flutter/infrastructure/model/club/home/notification_model.dart';
import 'package:game_on_flutter/presentation/screens/home/club_notification/view/notification_shimmer.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../infrastructure/navigation/routes.dart';
import '../../../../values/app_colors.dart';
import '../../../../values/app_values.dart';
import '../../../app_widgets/app_loading_mixin.dart';
import '../../../app_widgets/app_shimmer.dart';
import '../../../app_widgets/base_view.dart';
import '../../../custom_widgets/notification_tile_widget.dart';
import '../../club/club_profile/manage_post/view/post_shimmer_widget.dart';
import 'controllers/club_notification.controller.dart';

class ClubNotificationScreen extends GetView<ClubNotificationController>
    with AppBarMixin, AppLoadingMixin {
  ClubNotificationScreen({Key? key}) : super(key: key);

  final ClubNotificationController _controller =
      Get.find(tag: Routes.CLUB_NOTIFICATION);

  late TextTheme textTheme;
  late BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    textTheme = Theme.of(context).textTheme;
    return buildBody(context);
  }

  /// Build club main screen.
  Widget buildBody(BuildContext context) {
    return Obx(
      () => Scaffold(
          backgroundColor: AppColors.pageBackground,
          appBar: buildAppBarWithActions(
              backEnable: true,
              title: AppString.notification,
              actions: [
                if (_controller.enableReadAll.isTrue)
                  InkWell(
                      onTap: () => _controller.readNotification(),
                      child: buildReadAllText())
              ]),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppValues.screenMargin),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Flexible(
                      child: _controller.isLoading.isTrue
                          ? const NotificationShimmer()
                          : buildNotificationListWidget())
                ],
              ),
            ),
          )),
    );
  }

  /// build buildNotificationButton
  Padding buildReadAllText() {
    return Padding(
      padding: const EdgeInsets.only(
          right: AppValues.screenMargin, top: AppValues.appbarTopMargin),
      child: Center(
        child: Text(AppString.readAll,
            style: textTheme.displaySmall
                ?.copyWith(color: AppColors.appRedButtonColor)),
      ),
    );
  }

  /// Build list widget.
  Widget buildNotificationListWidget() =>
      PagedListView<int, NotificationData>.separated(
        separatorBuilder: (_, ctx) => Container(
          height: AppValues.margin_10,
        ),
        pagingController: _controller.pagingController,
        shrinkWrap: true,
        primary: true,
        physics: const NeverScrollableScrollPhysics(),
        builderDelegate: PagedChildBuilderDelegate<NotificationData>(
            animateTransitions: true,
            noItemsFoundIndicatorBuilder: (_) => _buildNoNotification(),
            firstPageProgressIndicatorBuilder: (_) =>
                const NotificationShimmer(),
            newPageProgressIndicatorBuilder: (_) =>
                AppShimmer(child: const SinglePostShimmerWidget()),
            itemBuilder: (context, item, index) {
              return NotificationTileWidget(
                postModel: item,
                onReadChange: _controller.onReadChanged,
                index: index,
              );
            }),
      );

  /// Build no notification.
  Widget _buildNoNotification() {
    return SizedBox(
      height: 300,
      child: Center(
        child: Text(AppString.noNotificationAvailable,
            style: textTheme.displaySmall?.copyWith()),
      ),
    );
  }
}
