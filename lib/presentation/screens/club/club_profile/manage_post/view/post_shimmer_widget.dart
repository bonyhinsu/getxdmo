import 'package:flutter/material.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_shimmer.dart';
import 'package:game_on_flutter/values/app_colors.dart';

import '../../../../../../values/app_values.dart';

class PostShimmerWidget extends StatelessWidget {
  const PostShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          primary: false,
          itemBuilder: (_, index) => const SinglePostShimmerWidget(),
          shrinkWrap: true,
          separatorBuilder: (_, ctx) => Container(
                height: AppValues.margin_10,
              ),
          itemCount: 15),
    );
  }
}

class SinglePostShimmerWidget extends StatelessWidget {
  const SinglePostShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(
          left: AppValues.mediumPadding,
          right: AppValues.mediumPadding,
          top: AppValues.mediumPadding,
          bottom: AppValues.padding_6),
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.transparent, width: 1),
          borderRadius: BorderRadius.circular(AppValues.roundedButtonRadius)),
      tileColor: AppColors.textColorSecondary.withOpacity(0.1),
      title: Column(
        children: [
          Container(
            height: 165,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.textColorDarkGray.withOpacity(0.15),
              borderRadius: BorderRadius.circular(AppValues.smallRadius),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            height: AppValues.normalTextHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.textColorDarkGray.withOpacity(0.15),
            ),
          ),
          const SizedBox(
            height: AppValues.height_8,
          ),
          Container(
            height: AppValues.normalTextHeight,
            width: double.infinity,
            margin: const EdgeInsets.only(right: 50),
            decoration: BoxDecoration(
              color: AppColors.textColorDarkGray.withOpacity(0.15),
            ),
          ),
          const SizedBox(
            height: AppValues.margin_10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: AppValues.size_30,
                height: AppValues.size_30,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    color: AppColors.textColorDarkGray.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(AppValues.fullRadius)),
              ),
              size10,
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: AppValues.normalTextHeight,
                      width: 200,
                      decoration: BoxDecoration(
                        color: AppColors.textColorDarkGray.withOpacity(0.15),
                      ),
                    ),
                    const SizedBox(
                      height: AppValues.margin_4,
                    ),
                    Container(
                      height: AppValues.normalTextHeight,
                      width: 100,
                      decoration: BoxDecoration(
                        color: AppColors.textColorDarkGray.withOpacity(0.15),
                      ),
                    ),
                  ],
                ),
              ),
              size10,
              // buildPostOptions()
            ],
          ),
        ],
      ),
    );
  }

  /// Build margin 10.
  Widget get size10 => const SizedBox(
        width: AppValues.margin_10,
      );
}
