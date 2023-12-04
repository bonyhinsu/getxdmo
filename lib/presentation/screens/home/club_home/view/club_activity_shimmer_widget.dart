import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../values/app_colors.dart';
import '../../../../../values/app_icons.dart';
import '../../../../../values/app_values.dart';
import '../../../../app_widgets/app_shimmer.dart';

class ClubActivityShimmerWidget extends StatelessWidget {
  const ClubActivityShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, index) => const ClubActivitySingleWidget(),
          shrinkWrap: true,
          separatorBuilder: (_, ctx) => Container(
                height: AppValues.margin_10,
              ),
          itemCount: 10),
    );
  }
}

class ClubActivitySingleWidget extends StatelessWidget {
  const ClubActivitySingleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
          left: AppValues.mediumPadding,
          right: AppValues.mediumPadding,
          top: AppValues.mediumPadding,
          bottom: AppValues.padding_6),
      decoration: BoxDecoration(
          color: AppColors.appTileBackground.withOpacity(0.2),
          borderRadius: BorderRadius.circular(AppValues.roundedButtonRadius)),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(
          children: [
            buildPlayerProfileView(),
            const SizedBox(
              width: AppValues.margin_20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildNameView(),
                  const SizedBox(
                    height: AppValues.margin_10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: buildIconAndNameRow(
                            iconAsset: AppIcons.playerPosition, value: ""),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Expanded(
                        child: buildIconAndNameRow(
                            iconAsset: AppIcons.age, value: ""),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: buildIconAndNameRow(
                            iconAsset: AppIcons.locationIcon, value: ""),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Expanded(
                        child: buildIconAndNameRow(
                            iconAsset: AppIcons.iconMale, value: ""),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          color: Colors.white.withOpacity(0.5),
          height: 10,
          width: double.infinity,
        ),
        const SizedBox(
          height: 4,
        ),
        Container(
          color: Colors.white.withOpacity(0.5),
          height: 10,
          width: double.infinity,
        ),
        const SizedBox(
          height: 4,
        ),
        Container(
          color: Colors.white.withOpacity(0.5),
          height: 10,
          width: double.infinity,
        ),
        const SizedBox(
          height: 4,
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            color: Colors.white.withOpacity(0.5),
            height: 10,
            width: 80,
          ),
        )
      ]),
    );
  }

  /// build player details
  Widget buildIconAndNameRow(
      {required String iconAsset, required String value}) {
    return Row(
      children: [
        SvgPicture.asset(
          width: 14,
          height: 14,
          iconAsset,
        ),
        const SizedBox(
          width: 4,
        ),
        Container(
          color: Colors.white.withOpacity(0.5),
          height: 10,
          width: 50,
        ),
      ],
    );
  }

  Widget buildNameView() => Container(
        color: Colors.white.withOpacity(0.5),
        height: 20,
        width: 150,
      );

  /// build player profile view
  Widget buildPlayerProfileView() => Container(
        width: 55,
        height: 55,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            color: AppColors.inputFieldBorderColor,
            borderRadius: BorderRadius.circular(AppValues.fullRadius)),
      );
}
