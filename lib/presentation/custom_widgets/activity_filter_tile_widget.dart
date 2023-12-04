import 'package:flutter/material.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_shimmer.dart';
import 'package:game_on_flutter/values/app_values.dart';
import 'package:get/get.dart';
import 'package:group_button/group_button.dart';

import '../../infrastructure/model/club/actiivty_filter_model.dart';
import '../../infrastructure/model/club/post/post_filter_model.dart';
import '../../values/app_colors.dart';
import '../screens/home/club_home/controllers/activity_filter_sublist_controller.dart';

class ActivityFilterTileWidget extends StatefulWidget {
  /// model
  ClubActivityFilter model;

  /// parent index
  int parentIndex;

  /// on filter click
  Function(int parentIndex, int childIndex, bool isSelected) onItemChange;

  late ActivityFilterSublistController activityFilterSublistController;

  ActivityFilterTileWidget(
      {required this.model,
      required this.onItemChange,
      required this.parentIndex,
      Key? key})
      : super(key: key) {
    activityFilterSublistController = Get.find(tag: "filter_${model.title}");
    activityFilterSublistController.setInitialData(
        model.filterSubItems, model.isRadio, model.canBeDisabled);
  }

  @override
  State<ActivityFilterTileWidget> createState() =>
      _ActivityFilterTileWidgetState();
}

class _ActivityFilterTileWidgetState extends State<ActivityFilterTileWidget> {
  late TextTheme textTheme;

  @override
  void initState() {
    if(widget.parentIndex==4) {
      widget.activityFilterSublistController.filterSelectedSport();
    }
    super.initState();
  }
    @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;

    return Obx(
      () => widget.activityFilterSublistController.showSection.isTrue
          ? SizedBox(
        width: double.infinity,
              child: AnimatedSwitcher(
                switchOutCurve: Curves.easeOutExpo,
                switchInCurve: Curves.fastLinearToSlowEaseIn,
                duration: const Duration(
                    milliseconds:
                        AppValues.shimmerWidgetChangeDurationInMillis),
                child: widget.model.title.isNotEmpty
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: AppValues.height_20,
                          ),
                          Text(
                            widget.model.title,
                            style: textTheme.labelMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: AppValues.height_20,
                          ),
                          widget.activityFilterSublistController.isLoading
                                  .isFalse
                              ? buildRadioButtonRow()
                              : buildButtonShimmerWidget(),
                          const SizedBox(
                            height: AppValues.height_20,
                          ),
                        ],
                      )
                    : buildRadioButtonRow(),
              ),
            )
          : Container(),
    );
  }

  /// build button shimmer widget.
  Widget buildButtonShimmerWidget() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Row(
        children: [
          buildLoadingSingleButtonWidget(),
          buildLoadingSingleButtonWidget(),
          buildLoadingSingleButtonWidget(),
          buildLoadingSingleButtonWidget(),
          buildLoadingSingleButtonWidget(),
          buildLoadingSingleButtonWidget(),
          buildLoadingSingleButtonWidget(),
        ],
      ),
    );
  }

  Widget buildLoadingSingleButtonWidget() => Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: AppShimmer(
          child: Container(
            height: 36,
            width: 150,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(AppValues.radius_4)),
          ),
        ),
      );

  /// Build radio button row widget.
  Widget buildRadioButtonRow() => Container(
        width: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: GroupButton<PostFilterModel>(
            controller: widget.activityFilterSublistController.controller,
            buttons: widget.activityFilterSublistController.subItemList,
            enableDeselect: true,

            onSelected: (value, index, isSelected) {
              if (widget
                  .activityFilterSublistController.subItemList[index].enable) {
                setState(() {
                  widget.activityFilterSublistController.subItemList[index]
                      .isSelected = isSelected;
                  widget.activityFilterSublistController.selectedValue.value =
                      widget.model.filterSubItems[index].title ?? "";
                });
                widget.onItemChange(
                    widget.parentIndex,
                    index,
                    widget.activityFilterSublistController.subItemList[index]
                        .isSelected);
              }
            },
            buttonIndexedBuilder: !widget.model.isRadio
                ? null
                : (_, index1, ___) => Opacity(
                    opacity:
                    widget.activityFilterSublistController.subItemList[index1].enable ? 1.0 : 0.5,
                    child: buildRowWidget(
                        widget.activityFilterSublistController.subItemList[index1], index1)),
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
            isRadio: !widget.model.multiSelection,
          ),
        ),
      );

  /// Build Radio button
  Widget buildRowWidget(PostFilterModel model, int i1) => GestureDetector(
        onTap: () {
          if (widget.activityFilterSublistController.subItemList[i1].enable) {
            setState(() {
              final isSelected = widget.activityFilterSublistController.subItemList[i1].isSelected;
              widget.activityFilterSublistController.subItemList[i1].isSelected = !isSelected;

              widget.activityFilterSublistController.selectedValue.value =
                  widget.activityFilterSublistController.subItemList[i1].title ?? "";
            });
            widget.onItemChange(widget.parentIndex, i1,
                widget.activityFilterSublistController.subItemList[i1].isSelected);
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(right: AppValues.margin_12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: Radio(
                  key: Key(model.title ?? ""),
                  groupValue: widget
                      .activityFilterSublistController.selectedValue.value,
                  value: widget.activityFilterSublistController.subItemList[i1].title,
                  visualDensity: VisualDensity.compact,
                  fillColor: MaterialStateColor.resolveWith(
                      (states) => AppColors.appRedButtonColor),
                  onChanged: (value) {
                    if (widget.activityFilterSublistController.subItemList[i1].enable) {
                      setState(() {
                        final isSelected =
                            widget.activityFilterSublistController.subItemList[i1].isSelected;
                        widget.activityFilterSublistController.subItemList[i1].isSelected =
                            !isSelected;

                        widget.activityFilterSublistController.selectedValue
                                .value =
                            widget.model.filterSubItems[i1].isSelected
                                ? model.title ?? ""
                                : "";
                      });
                      widget.onItemChange(widget.parentIndex, i1,
                          widget.activityFilterSublistController.subItemList[i1].isSelected);
                    }
                  },
                ),
              ),
              const SizedBox(
                width: AppValues.margin_6,
              ),
              Text(
                widget.activityFilterSublistController.subItemList[i1].title ?? "",
                style: textTheme.displaySmall,
              ),
            ],
          ),
        ),
      );
}
