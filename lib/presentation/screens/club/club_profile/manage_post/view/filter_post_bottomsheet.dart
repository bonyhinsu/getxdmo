import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_button_mixin.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:game_on_flutter/values/app_values.dart';
import 'package:get/get.dart';
import 'package:group_button/group_button.dart';

import '../../../../../../infrastructure/model/club/actiivty_filter_model.dart';
import '../../../../../../infrastructure/navigation/routes.dart';
import '../../../../../../values/app_colors.dart';
import '../../../../../app_widgets/base_bottomsheet.dart';
import '../controllers/post_filter_controller.dart';

class FilterPostBottomSheet extends StatefulWidget with AppButtonMixin {
  late PostFilterController _controller;
  Function(List<FilterItem> filterMenuList) onApplyFilter;

  FilterPostBottomSheet(
      {required List<FilterItem> filterMenuList,
      required this.onApplyFilter,
      Key? key})
      : super(key: key) {
    _controller = Get.find(tag: Routes.POST_FILTER_BOTTOMSHEET);
    _controller.setFilterMenuList(filterMenuList);
  }

  @override
  State<FilterPostBottomSheet> createState() => _FilterPostBottomSheetState();
}

class _FilterPostBottomSheetState extends State<FilterPostBottomSheet> {
  late TextTheme textTheme;

  @override
  void initState() {
    widget._controller.filterMenuList.forEachIndexed((index, element) {
      if (element.isSelected) {
        /// select controller index
        widget._controller.controller.selectIndex(index);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return BaseBottomsheet(
      title: AppString.strFilter,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        clearAllButton,
        const SizedBox(
          height: AppValues.size_15,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: GroupButton<FilterItem>(
            controller: widget._controller.controller,
            buttons: widget._controller.filterMenuList,
            enableDeselect: true,
            onSelected: (value, index, isSelected) {
              widget._controller.onItemClick(index, isSelected);
            },
            buttonTextBuilder: (_, model, ___) => model.title ?? "",
            options: GroupButtonOptions(
              crossGroupAlignment: CrossGroupAlignment.start,
              mainGroupAlignment: MainGroupAlignment.start,
              groupingType: GroupingType.row,
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
          ),
        ),
        Divider(
          height: 1,
          color: Colors.white.withOpacity(0.1),
        ),
        const SizedBox(
          height: AppValues.size_15,
        ),
        widget.appWhiteButton(
          title: AppString.applyFilter,
          onClick: () {
            widget.onApplyFilter(widget._controller.filterMenuList);
            Get.back();
          },
        ),
        const SizedBox(
          height: AppValues.size_15,
        ),
      ]),
    );
  }

  /// Build clear all button
  Widget get clearAllButton => Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
          onTap: () => widget._controller.clearAll(),
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
}
