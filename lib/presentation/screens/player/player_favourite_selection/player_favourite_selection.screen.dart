import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_on_flutter/infrastructure/navigation/routes.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_button_mixin.dart';
import 'package:game_on_flutter/presentation/app_widgets/base_view.dart';
import 'package:game_on_flutter/presentation/screens/player/player_favourite_selection/view/favourite_shimmer_list.dart';
import 'package:game_on_flutter/values/app_colors.dart';
import 'package:game_on_flutter/values/app_icons.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:game_on_flutter/values/app_values.dart';
import 'package:get/get.dart';

import '../../../custom_widgets/favourite_selection_tile_widget.dart';
import 'controllers/player_favourite_selection.controller.dart';

class PlayerFavouriteSelectionScreen
    extends GetView<PlayerFavouriteSelectionController>
    with AppBarMixin, AppButtonMixin {
  PlayerFavouriteSelectionScreen({Key? key}) : super(key: key);

  final PlayerFavouriteSelectionController _controller =
      Get.find(tag: Routes.PLAYER_FAVOURITE_SELECTION);

  late TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: buildAppBar(title: AppString.strFavouriteTo),
      floatingActionButton: buildAddFab(),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppValues.screenMargin),
          child: Obx(
            () => Column(
              children: [
                Expanded(
                    child: RefreshIndicator(
                        onRefresh: _controller.refreshScreen,
                        child: AnimatedSwitcher(
                          duration: const Duration(
                              milliseconds: AppValues
                                  .shimmerWidgetChangeDurationInMillis),
                          child: _controller.isLoading.isTrue
                              ? const FavouriteItemShimmerWidget()
                              : _controller.favouriteTypeList.isNotEmpty
                                  ? buildUserFavoriteList()
                                  : buildNoDataWidget(),
                        ))),
                Container(
                  height: AppValues.height_10,
                  color: AppColors.pageBackground,
                ),
                buildButton(),
                Container(
                  height: AppValues.screenMargin,
                  color: AppColors.pageBackground,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// listview builder.
  Widget buildUserFavoriteList() => ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 10),
        separatorBuilder: (_, index) {
          return const Divider(
            color: Colors.transparent,
          );
        },
        itemBuilder: (_, index) {
          return FavouriteSelectionTileWidget(
              index: index,
              swipeToDeleteEnable: true,
              onEditMember: _controller.editFavouriteItem,
              onDeleteMember: _controller.deleteFavouriteItem,
              onChange: _controller.setSelectedItems,
              model: _controller.favouriteTypeList[index]);
        },
        itemCount: _controller.favouriteTypeList.length,
      );

  /// no data widget.
  Widget buildNoDataWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: AppValues.padding_18),
      child: SizedBox(
        height: AppValues.height_100,
        child: DottedBorder(
          dashPattern: const [6, 6, 6, 6],
          strokeWidth: 1,
          color: AppColors.textPlaceholderColor,
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              AppString.noFavouriteAdded,
              textAlign: TextAlign.center,
              style: textTheme.displaySmall
                  ?.copyWith(color: AppColors.inputFieldBorderColor),
            ),
          ),
        ),
      ),
    );
  }

  /// add floating action button.
  Widget buildAddFab() => Padding(
        padding: const EdgeInsets.only(
            bottom: AppValues.height_80, right: AppValues.height_6),
        child: FloatingActionButton(
          onPressed: () => _controller.openAddFilterBottomSheet(),
          backgroundColor: AppColors.fabButtonBackgroundChange,
          child: SvgPicture.asset(
            AppIcons.iconAdd,
            width: AppValues.iconSize_28,
            height: AppValues.iconSize_28,
            color: AppColors.textColorDarkGray,
          ),
        ),
      );

  /// Build save button
  Widget buildButton() => appWhiteButton(
      isValidate: _controller.validField.isTrue,
      title: AppString.strSave,
      onClick: () => _controller.onSubmit());
}
