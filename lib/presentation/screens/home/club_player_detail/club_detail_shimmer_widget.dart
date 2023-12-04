import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_shimmer.dart';

mixin ClubDetailShimmerWidget {
  Widget get buiShimmerWidget => AppShimmer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 13,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(
              height: 4,
            ),
            Container(
              width: double.infinity,
              height: 13,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(
              height: 4,
            ),
            Container(
              width: double.infinity,
              height: 13,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(
              height: 4,
            ),
            Container(
              width: double.infinity,
              height: 13,
              color: Colors.white.withOpacity(0.5),
            )
          ],
        ),
      );
}
