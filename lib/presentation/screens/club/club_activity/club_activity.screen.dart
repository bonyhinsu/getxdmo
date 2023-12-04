import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/club_activity.controller.dart';

class ClubActivityScreen extends GetView<ClubActivityController> {
  ClubActivityScreen({Key? key}) : super(key: key);

  late TextTheme textTheme;
  late BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          'Club Main is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
