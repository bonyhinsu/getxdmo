import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../values/app_icons.dart';
import '../../../../../values/app_values.dart';
import '../../../../app_widgets/app_shimmer.dart';

class UserSearchShimmerWidget extends StatelessWidget {
  const UserSearchShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, index) => const UserShimmerSingleShimmerWidget(),
          shrinkWrap: true,
          separatorBuilder: (_, ctx) => Container(
                height: AppValues.margin_10,
              ),
          itemCount: 15),
    );
  }
}

class UserShimmerSingleShimmerWidget extends StatelessWidget {
  const UserShimmerSingleShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Row(
        children: [
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(100)),
          ),
          const SizedBox(
            width: AppValues.size_15,
          ),
          Row(
            children: [
              Container(
                height: 20,
                width: 80,
                color: Colors.white.withOpacity(0.2),
              ),
              Container(
                width: 8,
              ),
              Container(
                height: 20,
                width: 100,
                color: Colors.white.withOpacity(0.2),
              ),
            ],
          ),
          const Spacer(),
          SvgPicture.asset(AppIcons.arrowIcon)
        ],
      ),
    );
  }
}
