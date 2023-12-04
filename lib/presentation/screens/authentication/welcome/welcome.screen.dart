import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_button_mixin.dart';
import 'package:game_on_flutter/values/app_colors.dart';
import 'package:game_on_flutter/values/app_images.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../infrastructure/model/common/app_fields.dart';
import '../../../../values/app_values.dart';
import 'controllers/welcome.controller.dart';

// ignore: must_be_immutable
class WelcomeScreen extends GetView<WelcomeController> with AppButtonMixin {
  @override
  WelcomeController controller = Get.find();

  WelcomeScreen({Key? key}) : super(key: key);

  late TextTheme _textTheme;

  @override
  Widget build(BuildContext context) {
    _textTheme = Theme.of(context).textTheme;

    return Scaffold(
        appBar: AppBar(backgroundColor: AppColors.pageBackground),
        backgroundColor: AppColors.pageBackground,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppValues.screenMargin,
                vertical: AppValues.screenMargin),
            child: Column(
              children: [
                Expanded(child: buildCenterContent()),
                buildBottomButtons()
              ],
            ),
          ),
        ));
  }

  /// Build center logo widget.
  Widget buildCenterLogoWidget() {
    return Hero(
      tag: 'app_logo',
      child: SvgPicture.asset(
        AppImages.gameLogoIcon,
        height: AppValues.splashLogoWidth,
        width: AppValues.splashLogoWidth,
      ),
    );
  }

  /// Build center content of welcome screen.
  Widget buildCenterContent() {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildCenterLogoWidget(),
          const SizedBox(
            height: 30,
          ),
          Text(
            AppString.welcomeMessage,
            style: _textTheme.headlineLarge?.copyWith(fontSize: 22),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            GetIt.instance<AppFields>().welcomeContent,
            textAlign: TextAlign.center,
            style: _textTheme.headlineSmall?.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }

  /// Build bottom button for welcome screen.
  Widget buildBottomButtons() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          appRedButton(
              title: AppString.strSignUp,
              onClick: () => controller.onButtonClick(isSignUp: true)),
          const SizedBox(
            height: 16,
          ),
          appWhiteButton(
              title: AppString.strLogin,
              onClick: () => controller.onButtonClick(isSignUp: false))
        ],
      ),
    );
  }
}
