import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_button_mixin.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:get/get.dart';

import '../../infrastructure/navigation/routes.dart';
import '../../values/app_banner.dart';
import '../../values/app_values.dart';
import 'controllers/no_internet.controller.dart';

class NoInternetScreen extends GetView<NoInternetController>
    with AppButtonMixin {
  final NoInternetController _controller = Get.find(tag: Routes.NO_INTERNET);

  NoInternetScreen({Key? key}) : super(key: key);
  late TextTheme textTheme;
  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppValues.screenMargin,vertical: AppValues.margin_30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildNoConnectionLogo(),
          buildNoInternetText(),
          retryButton()
        ],
      ),
    ));
  }

  /// No connection text.
  Widget buildNoInternetText() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('No Internet Found!',style: textTheme.headlineLarge,),
          const SizedBox(height: AppValues.margin_12,),
          Text('Please check your internet connection.',style: textTheme.displaySmall,),
        ],
      );

  /// No connection logo.
  Widget buildNoConnectionLogo() {
    return SizedBox(
        width: double.infinity,
        height: AppValues.paymentMethodBannerHeight,
        child: SvgPicture.asset(AppBanner.questionBanner));
  }

  /// retry button.
  Widget retryButton() =>
      appRedButton(title: AppString.close, onClick: _controller.onRetryClick);
}
