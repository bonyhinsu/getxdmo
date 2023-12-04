import 'package:flutter/material.dart';
import 'package:game_on_flutter/presentation/app_widgets/base_view.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../infrastructure/model/common/block_unblock_response.dart';
import '../../../../infrastructure/navigation/routes.dart';
import '../../../../values/app_colors.dart';
import '../../../../values/app_values.dart';
import '../../../app_widgets/app_shimmer.dart';
import '../../../custom_widgets/blocked_user_list_tile_widget.dart';
import '../../club/club_user_search/view/user_search_shimmer_widget.dart';
import '../../home/club_home/view/club_activity_shimmer_widget.dart';
import 'controllers/blocked_users.controller.dart';

class BlockedUsersScreen extends GetView<BlockedUsersController>
    with AppBarMixin {
  BlockedUsersScreen({Key? key}) : super(key: key);

  final BlockedUsersController _controller =
      Get.find(tag: Routes.BLOCKED_USERS);

  late TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: buildAppBar(title: AppString.blockedUsers),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppValues.screenMargin),
          child: _buildBlockedUserList(),
        ),
      ),
    );
  }

  /// Build list widget.
  Widget _buildBlockedUserList() =>
      PagedListView<int, BlockUnblockUserResponseData>.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: AppValues.screenMargin),
        separatorBuilder: (_, ctx) => Container(
          height: AppValues.margin_10,
        ),
        pagingController: _controller.pagingController,
        builderDelegate:
            PagedChildBuilderDelegate<BlockUnblockUserResponseData>(
                animateTransitions: true,
                firstPageErrorIndicatorBuilder: (_) => buildNoUserFoundWidget(),
                noItemsFoundIndicatorBuilder: (_) => buildNoUserFoundWidget(),
                firstPageProgressIndicatorBuilder: (_) =>
                    const ClubActivityShimmerWidget(),
                newPageProgressIndicatorBuilder: (_) =>
                    AppShimmer(child: const UserSearchShimmerWidget()),
                itemBuilder: (context, item, index) {
                  return BlockedUserListTileWidget(
                      model: item, onUnblock: _controller.onUnblockUser);
                }),
      );

  /// Build no directors widget.
  Widget buildNoUserFoundWidget() {
    return SizedBox(
      height: 100,
      child: Center(
        child: Text(
          AppString.noClubFound,
          style: textTheme.displaySmall
              ?.copyWith(color: AppColors.inputFieldBorderColor),
        ),
      ),
    );
  }
}
