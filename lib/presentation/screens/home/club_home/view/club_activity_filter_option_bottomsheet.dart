import 'package:flutter/material.dart';
import 'package:game_on_flutter/infrastructure/navigation/routes.dart';
import 'package:game_on_flutter/presentation/app_widgets/base_bottomsheet.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:game_on_flutter/values/app_values.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../../infrastructure/model/club/actiivty_filter_model.dart';
import '../../../../../infrastructure/storage/preference_manager.dart';
import '../../../../../values/app_colors.dart';
import '../../../../app_widgets/app_button_mixin.dart';
import '../../../../custom_widgets/activity_filter_tile_widget.dart';
import '../controllers/activity_filter_sublist_controller.dart';
import '../controllers/club_activity_filter_option_controller.dart';

class ClubActivityFilterOptionBottomSheet extends StatelessWidget
    with AppButtonMixin {
  bool requiredFullHeight;
  bool clearAllRequired;

  Function(List<ClubActivityFilter> filterMenuList) onApplyFilter;

  late ClubActivityFilterOptionController _controller;

  ClubActivityFilterOptionBottomSheet(
      {required List<ClubActivityFilter> filterMenuList,
      this.requiredFullHeight = true,
      this.clearAllRequired = false,
      bool requireClearAll = false,
      required this.onApplyFilter,
      Key? key})
      : super(key: key) {
    _controller = Get.find(tag: Routes.CLUB_ACTIVITY_FILTER);
    _controller.setFilterMenuList(filterMenuList);

    if (requireClearAll) {
      _controller.clearAll();
    }
  }

  late TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    textTheme = Theme.of(context).textTheme;
    num screenHeightRatio =GetIt.I<PreferenceManager>().isClub? 0.70:0.60;
    return BaseBottomsheet(
      title: AppString.strFilter,
      child: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            clearAllButton,
            SizedBox(
              width: double.infinity,
              height: deviceHeight * screenHeightRatio,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: _controller.filterMenuList.length,
                itemBuilder: (_, index) {
                  Get.lazyPut<ActivityFilterSublistController>(
                      () => ActivityFilterSublistController(),
                      tag: 'filter_${_controller.filterMenuList[index].title}',
                      fenix: true);

                  return ActivityFilterTileWidget(
                    parentIndex: index,
                    onItemChange: _controller.onItemClick,
                    model: _controller.filterMenuList[index],
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    buildDivider,
              ),
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
              onApplyFilter(_controller.filterMenuList.value);
              Get.back();
            }),
      );
}
