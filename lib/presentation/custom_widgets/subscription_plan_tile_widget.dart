import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../infrastructure/model/subscription/subscription_plan_model.dart';
import '../../values/app_colors.dart';
import '../../values/app_icons.dart';
import '../../values/app_values.dart';

class SubscriptionPlanTileWidget extends StatefulWidget {
  SubscriptionPlanModel model;
  int index;
  int selectedIndex;
  GlobalKey expandKey;
  Function(SubscriptionPlanModel model, int index) selectedTile;

  SubscriptionPlanTileWidget(
      {required this.model,
      required this.selectedTile,
      required this.selectedIndex,
      required this.index,
      required this.expandKey,
      Key? key})
      : super(key: key);

  @override
  State<SubscriptionPlanTileWidget> createState() =>
      _SubscriptionPlanTileWidgetState();
}

class _SubscriptionPlanTileWidgetState extends State<SubscriptionPlanTileWidget>
    with SingleTickerProviderStateMixin {
  late TextTheme textTheme;

  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      upperBound: 0.5,
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return buildExpansionTile();
  }

  /// Build expansion tile widget
  Widget buildExpansionTile() => Stack(
        children: [
          if (widget.index == widget.selectedIndex)
            Container(
              height: 370,
              padding: const EdgeInsets.all(20),
              child: Stack(
                children: [
                  Positioned(
                    right: 13,
                    top: 50,
                    child: Container(
                      height: 109,
                      width: 109,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppColors.appRedButtonColor.withOpacity(0.2),
                              spreadRadius: 12,
                              blurRadius: 18,
                            ),
                          ],
                          borderRadius:
                              BorderRadius.circular(AppValues.fullRadius)),
                    ),
                  ),
                  Positioned(
                    left: 14,
                    bottom: 40,
                    child: Container(
                      height: 168,
                      width: 168,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppColors.appRedButtonColor.withOpacity(0.2),
                              spreadRadius: 12,
                              blurRadius: 18,
                            ),
                          ],
                          // color: AppColors.appRedButtonColor.withOpacity(0.2),
                          borderRadius:
                              BorderRadius.circular(AppValues.fullRadius)),
                    ),
                  )
                ],
              ),
            ),
          ExpansionTile(
            key: GlobalKey(),
            clipBehavior: Clip.hardEdge,
            onExpansionChanged: (val) {
              widget.selectedTile(widget.model, widget.index);
            },
            collapsedBackgroundColor:
                AppColors.textColorSecondary.withOpacity(0.1),
            backgroundColor:
                AppColors.appRedButtonColorDisable.withOpacity(0.1),
            tilePadding: const EdgeInsets.symmetric(
              vertical: AppValues.margin_6,
            ),
            collapsedShape: RoundedRectangleBorder(
                side: const BorderSide(
                    width: 2,
                    color: Colors.transparent,
                    style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(AppValues.radius_10)),
            leading: Padding(
              padding: const EdgeInsets.only(left: AppValues.margin_15),
              child: Text(
                widget.model.planTitle ?? "",
                style: textTheme.headlineLarge?.copyWith(
                    color: AppColors.textColorSecondary,
                    fontWeight: FontWeight.w500),
              ),
            ),
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: 2,
                    color: AppColors.appRedButtonColor.withOpacity(0.5),
                    style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(AppValues.smallRadius)),
            initiallyExpanded: widget.index == widget.selectedIndex,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "\$${widget.model.planAmount ?? ""}",
                  style: textTheme.headlineLarge?.copyWith(
                      color: AppColors.textColorSecondary,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  width: AppValues.margin_15,
                ),
                RotationTransition(
                    turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
                    child: widget.index == widget.selectedIndex
                        ? RotatedBox(
                            quarterTurns: 2,
                            child: SvgPicture.asset(AppIcons.downArrow))
                        : SvgPicture.asset(AppIcons.downArrow)),
              ],
            ),
            trailing: const SizedBox(),
            childrenPadding: const EdgeInsets.only(
                bottom: AppValues.margin_15,
                left: AppValues.margin_15,
                right: AppValues.margin_15),
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Features:",
                      style: textTheme.labelMedium?.copyWith(
                          color: AppColors.textColorDarkGray,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: AppValues.height_10,
                    ),
                    Text(
                      widget.model.planFeatures ?? "",
                      style: textTheme.displaySmall
                          ?.copyWith(color: AppColors.textColorDarkGray),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      );
}
