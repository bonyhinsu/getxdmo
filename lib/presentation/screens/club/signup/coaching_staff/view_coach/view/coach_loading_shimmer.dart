import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../../values/app_colors.dart';
import '../../../../../../../values/app_icons.dart';
import '../../../../../../../values/app_values.dart';
import '../../../../../../app_widgets/app_shimmer.dart';

class CoachLoadingShimmerWidget extends StatelessWidget {
  const CoachLoadingShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, index) => const CoachItemShimmerTileWidget(),
          shrinkWrap: true,
          separatorBuilder: (_, ctx) =>
              Container(
                height: AppValues.margin_10,
              ),
          itemCount: 15),
    );
  }
}

class CoachItemShimmerTileWidget extends StatelessWidget {
  const CoachItemShimmerTileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.textColorSecondary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppValues.smallRadius)),
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2),
              decoration: BoxDecoration(
                  color: AppColors.appRedButtonColor.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(AppValues.smallRadius),
                      bottomRight: Radius.circular(AppValues.smallRadius))),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    AppIcons.iconMale,
                    width: AppValues.size_14,
                    height: AppValues.size_14,
                    color: AppColors.appRedButtonColor,
                  ),
                  const SizedBox(
                    width: AppValues.height_4,
                  ),
                 Container(
                   height: 15,
                   width: 100,
                   color: AppColors.textColorSecondary.withOpacity(0.5),
                 )
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppValues.mediumPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            AppIcons.iconDefence,
                            width: AppValues.size_14,
                            height: AppValues.size_14,
                            color: AppColors.appRedButtonColor,
                          ),
                          const SizedBox(
                            width: AppValues.height_6,
                          ),
                          Container(
                            height: 15,
                            width: 100,
                            color: AppColors.textColorSecondary.withOpacity(0.5),
                          ),
                          Container(
                            height: 15,
                            width: 100,
                            color: AppColors.textColorSecondary.withOpacity(0.5),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: AppValues.height_10,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            AppIcons.calenderIcon,
                            width: AppValues.size_14,
                            height: AppValues.size_14,
                            color: AppColors.appRedButtonColor,
                          ),
                          const SizedBox(
                            width: AppValues.height_8,
                          ),
                          Flexible(
                            child: Container(
                              height: 15,
                              width: 100,
                              color: AppColors.textColorSecondary.withOpacity(0.5),
                            )
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // buildCallWidget(),
              // buildMessageWidget()
            ],
          ),
        ],
      ),
    );
  }
}
