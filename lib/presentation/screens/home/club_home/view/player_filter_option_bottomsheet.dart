import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../infrastructure/model/club/actiivty_filter_model.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../values/app_colors.dart';
import '../../../../../values/app_string.dart';
import '../../../../../values/app_values.dart';
import '../../../../app_widgets/app_button_mixin.dart';
import '../../../../app_widgets/base_bottomsheet.dart';
import '../../../../custom_widgets/activity_filter_tile_widget.dart';
import '../../../subscription/add_new_card/controllers/add_new_card.controller.dart';
import '../controllers/activity_filter_sublist_controller.dart';
import '../controllers/club_activity_filter_option_controller.dart';

class PlayerFilterOptionBottomsheet extends StatelessWidget
    with AppButtonMixin {
  Function(List<ClubActivityFilter> filterMenuList) onApplyFilter;

  late ClubActivityFilterOptionController _controller;

  PlayerFilterOptionBottomsheet(
      {required List<ClubActivityFilter> filterMenuList,
      required this.onApplyFilter,
        bool requireClearAll=false,
      Key? key})
      : super(key: key) {
    _controller = Get.find(tag: Routes.CLUB_ACTIVITY_FILTER);
    _controller.setFilterMenuList(filterMenuList);
    if(requireClearAll){
      _controller.clearAll();
    }
  }

  late TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return  Obx(
            () =>BaseBottomsheet(
      title: AppString.strFilter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          clearAllButton,
          ListView.separated(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: _controller.filterMenuList.length,
            itemBuilder: (_, index) {
              Get.lazyPut<ActivityFilterSublistController>(
                      () => ActivityFilterSublistController(),
                  tag: 'filter_${_controller.filterMenuList[index].title}'
              );
              return ActivityFilterTileWidget(
                parentIndex: index,
                onItemChange: _controller.onItemClick,
                model: _controller.filterMenuList[index],
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                buildDivider,
          ),
          buildBottomWidget(),
          const SizedBox(
            height: AppValues.screenMargin,
          )
        ],
      ),
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

  /// Build divider widget
  Widget get buildDivider => const Divider(
        height: 1,
        color: AppColors.appWhiteButtonColorDisable,
      );

  /// Build apply filter button.
  Widget buildBottomWidget() => SizedBox(
        height: 50,
        child: appWhiteButton(
            title: AppString.applyFilter,
            onClick: () {
              onApplyFilter(_controller.filterMenuList);
              Get.back();
            }),
      );
}
