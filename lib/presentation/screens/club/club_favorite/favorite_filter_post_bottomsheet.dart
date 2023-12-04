import 'package:flutter/material.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_button_mixin.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:game_on_flutter/values/app_values.dart';
import 'package:get/get.dart';
import 'package:group_button/group_button.dart';

import '../../../../infrastructure/model/club/post/post_filter_model.dart';
import '../../../../infrastructure/navigation/routes.dart';
import '../../../../values/app_colors.dart';
import '../../../app_widgets/base_bottomsheet.dart';
import 'favorite_bottomsheet_controller.dart';

class FavoriteFilterPostBottomSheet extends StatefulWidget
    with AppButtonMixin, AppButtonMixin {
  int index;

  /// on filter click
  Function(int childIndex, bool isSelected) onItemChange;

  late FavoriteBottomsheetController controller;

  FavoriteFilterPostBottomSheet(
      {required this.onItemChange,
      required List<PostFilterModel> list,
      required this.index,
      Key? key})
      : super(key: key) {
    controller = Get.find(tag: Routes.FAVORITE_FILTER);
    controller.setMenuList(list);
  }

  @override
  State<FavoriteFilterPostBottomSheet> createState() =>
      _FavoriteFilterPostBottomSheetState();
}

class _FavoriteFilterPostBottomSheetState
    extends State<FavoriteFilterPostBottomSheet> {
  late TextTheme textTheme;

  final FavoriteBottomsheetController _controller =
      Get.find(tag: Routes.FAVORITE_FILTER);

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return BaseBottomsheet(
      title: AppString.strFilter,
      child: Obx(
        () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_controller.filterData.isNotEmpty) clearAllButton,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: AppValues.height_10,
                  ),
                  buildTextHeader(),
                  widget.controller.filterData.isNotEmpty
                      ? buildGroupChips()
                      : _buildNoFavourites(),
                ],
              ),
              const SizedBox(
                height: AppValues.size_15,
              ),
              widget.appWhiteButton(
                title: AppString.applyFilter,
                isValidate: _controller.enableApplyButton.value,
                onClick: () => {_controller.applyFilter()},
              ),
              const SizedBox(
                height: AppValues.size_15,
              ),
            ]),
      ),
    );
  }

  /// Build clear all button
  Widget get clearAllButton => Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
          onTap: () => _controller.clearAll(),
          child: Padding(
            padding: const EdgeInsets.only(
              top: AppValues.margin_10,
              left: AppValues.margin_10,
            ),
            child: Text(
              AppString.strClearAll,
              style: textTheme.displaySmall
                  ?.copyWith(color: AppColors.appRedButtonColor),
            ),
          )));

  /// Build button UI.
  Widget buildGroupChips() {
    Get.log("widget.controller.filterData${widget.controller.filterData}");
    return GroupButton<PostFilterModel>(
      controller: _controller.groupButtonController,
      buttons: widget.controller.filterData,
      enableDeselect: true,
      onSelected: (value, index, isSelected) {
        _controller.setSelectedField(
            widget.controller.filterData[index], index);
      },
      buttonTextBuilder: (_, model, ___) => model.title ?? "",
      options: GroupButtonOptions(
        crossGroupAlignment: CrossGroupAlignment.start,
        mainGroupAlignment: MainGroupAlignment.start,
        groupingType: GroupingType.column,
        borderRadius: BorderRadius.circular(AppValues.radius_5),
        selectedColor: AppColors.appRedButtonColor.withOpacity(0.1),
        unselectedColor: AppColors.choiceUnselectedColor,
        unselectedTextStyle:
            textTheme.displaySmall?.copyWith(color: Colors.white),
        selectedTextStyle: textTheme.displaySmall
            ?.copyWith(color: AppColors.appRedButtonColor),
        runSpacing: AppValues.margin_5,
        spacing: AppValues.margin_5,
      ),
      isRadio: false,
    );
  }

  /// build header text
  Widget buildTextHeader() {
    return Text(AppString.favoriteList,
        textAlign: TextAlign.start,
        style: textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textColorSecondary,
        ));
  }

  Widget _buildNoFavourites() {
    return Container(
      height: 100,
      child: Center(
        child: Text('No favourites are available.',
            style: textTheme.displaySmall
                ?.copyWith(color: AppColors.textColorTernary)),
      ),
    );
  }
}
