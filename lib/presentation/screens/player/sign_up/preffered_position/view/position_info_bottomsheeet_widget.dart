import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_button_mixin.dart';
import 'package:game_on_flutter/values/app_colors.dart';
import 'package:game_on_flutter/values/app_values.dart';
import 'package:get/get.dart';

import '../../../../../../values/app_string.dart';

class PositionInfoBottomsheetWidget extends StatelessWidget
    with AppButtonMixin {
  String? description;

  PositionInfoBottomsheetWidget({this.description, Key? key}) : super(key: key);
  late TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: AppValues.height_20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppValues.screenMargin),
                child: HtmlWidget(
                  description ?? "",
                  textStyle: textTheme.displaySmall
                      ?.copyWith(color: AppColors.textColorDarkGray),
                ),
              ),
              const SizedBox(
                height: AppValues.height_20,
              )
            ],
          ),
          buildBottomButton(),
          const SizedBox(
            height: AppValues.screenMargin,
          ),
        ],
      ),
    );
  }

  /// Build bottom button.
  Widget buildBottomButton() =>
      appWhiteButton(title: AppString.strOkay, onClick: () => Get.back());
}
