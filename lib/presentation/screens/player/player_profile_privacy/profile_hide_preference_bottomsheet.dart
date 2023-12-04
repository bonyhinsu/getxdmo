import 'package:flutter/material.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_button_mixin.dart';
import 'package:game_on_flutter/presentation/screens/player/player_profile_privacy/profile_hide_preference_bottomsheet_controller.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:game_on_flutter/values/app_values.dart';
import 'package:get/get.dart';

import '../../../../infrastructure/navigation/routes.dart';
import '../../../../values/app_colors.dart';
import '../../../app_widgets/base_bottomsheet.dart';
import 'controllers/player_profile_privacy.controller.dart';

class ProfileHidePreferenceBottomsheet extends StatefulWidget
    with AppButtonMixin {
  final ProfileHidePreferenceBottomsheetController _controller =
      Get.find(tag: Routes.PROFILE_HIDE_PREFERENCE_BOTTOMSHEET);

  ProfileHidePreferenceBottomsheet(
      {required ProfilePrivacyEnum selectedValue}) {
    _controller.setResultEnum(selectedValue);
  }

  @override
  State<ProfileHidePreferenceBottomsheet> createState() =>
      _ProfileHidePreferenceBottomsheetState();
}

class _ProfileHidePreferenceBottomsheetState
    extends State<ProfileHidePreferenceBottomsheet> {
  late TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;

    return BaseBottomsheet(
      title: AppString.profileHidePreference,
      child: Obx(()=>Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: AppValues.size_15,
            ),
            buildProfileHidePreference(),
            const SizedBox(
              height: AppValues.size_30,
            ),
            widget.appWhiteButton(
              title: widget._controller.result.value ==
                      widget._controller.results[1]
                  ? AppString.strNext
                  : AppString.strSave,
              onClick: widget._controller.applyNext,
            ),
            const SizedBox(
              height: AppValues.size_15,
            ),
          ]),),
    );
  }

  /// build radio list button

  Widget buildProfileHidePreference() {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: widget._controller.results.length,
      itemBuilder: (_, index) => GestureDetector(
        onTap: () {
          setState(() {
            widget._controller.setResult(widget._controller.results[index]);
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            children: [
              Radio(
                key: Key(widget._controller.result.value),
                groupValue: widget._controller.result.value,
                value: widget._controller.results[index],
                visualDensity: VisualDensity.compact,
                fillColor: MaterialStateColor.resolveWith((states) =>
                    widget._controller.result.value ==
                            widget._controller.results[index]
                        ? AppColors.appRedButtonColor
                        : AppColors.textColorSecondary),
                //<-- SEE HERE
                onChanged: (value) {
                  setState(() {
                    widget._controller
                        .setResult(widget._controller.results[index]);
                  });
                },
              ),
              Text(
                widget._controller.results[index],
                style: textTheme.displaySmall?.copyWith(fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
