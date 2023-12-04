import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:game_on_flutter/values/app_values.dart';
import 'package:get/get.dart';

import '../../../../values/app_icons.dart';
import '../../../../values/app_images.dart';
import '../../../app_widgets/base_view.dart';
import 'controllers/role_selection.controller.dart';

// ignore: must_be_immutable
class RoleSelectionScreen extends StatefulWidget with AppBarMixin {
  RoleSelectionScreen({Key? key}) : super(key: key);

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with SingleTickerProviderStateMixin {
  final RoleSelectionController _controller = Get.find();

  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 2000,
      ),
    );
    animation = controller
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reset();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  late TextTheme textTheme;

  late BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: widget.buildAppBar(
          title: AppString.whoAreYou, backEnable: true, centerTitle: true),
      body: Center(
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildPlayerBox(),
              const SizedBox(
                height: 30,
              ),
              buildClubBox(),
            ],
          ),
        ),
      ),
    );
  }

  /// Build player box
  Widget buildPlayerBox() {
    return GestureDetector(
      onTap: () => _controller.onSelectPlayer(),
      onLongPress: () => _controller.onSelectPlayer(),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
            borderRadius: BorderRadius.circular(20)),
        height: AppValues.roleSelectionSectionSize,
        width: AppValues.roleSelectionSectionSize,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Image.asset(
                _controller.selectedIndex.value == 1
                    ? AppImages.roleSelectionPlayerBackgroundSelectedImage
                    : AppImages.roleSelectionPlayerBackgroundImage,
                fit: BoxFit.fill,
                height: AppValues.roleSelectionSectionSize,
                width: AppValues.roleSelectionSectionSize,
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 19.0),
                  child: Text(
                    AppString.player,
                    style: textTheme.bodyLarge,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: SvgPicture.asset(
                    AppIcons.playerIcon,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build club box
  Widget buildClubBox() {
    return GestureDetector(
      onTap: () => _controller.onSelectClub(),
      onLongPress: () => _controller.onSelectClub(),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
            borderRadius: BorderRadius.circular(20)),
        height: AppValues.roleSelectionSectionSize,
        width: AppValues.roleSelectionSectionSize,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Image.asset(
                _controller.selectedIndex.value == 2
                    ? AppImages.roleSelectionClubBackgroundSelectedImage
                    : AppImages.roleSelectionClubBackgroundImage,
                fit: BoxFit.fill,
                height: AppValues.roleSelectionSectionSize,
                width: AppValues.roleSelectionSectionSize,
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 19.0),
                  child: Text(
                    AppString.club,
                    style: textTheme.bodyLarge,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SvgPicture.asset(
                  AppIcons.clubIcon,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
