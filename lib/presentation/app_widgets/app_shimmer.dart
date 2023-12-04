import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppShimmer extends StatelessWidget {
  Widget child;
  bool enabled;

  AppShimmer({required this.child, this.enabled = true,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade700,
      highlightColor: Colors.grey.shade300,
      enabled: enabled,
      period: const Duration(milliseconds: 600),
      child: child,
    );
  }
}
