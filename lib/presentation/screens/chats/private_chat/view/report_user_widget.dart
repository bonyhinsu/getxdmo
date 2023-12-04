import 'package:flutter/material.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_button_mixin.dart';
import 'package:game_on_flutter/presentation/app_widgets/user_feature_mixin.dart';
import 'package:game_on_flutter/values/app_values.dart';
import 'package:get/get.dart';

import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../values/app_string.dart';
import '../../../../app_widgets/app_input_field.dart';
import '../../../../custom_widgets/report_user_tile_widget.dart';
import '../controllers/report_user.controller.dart';

class ReportUserWidget extends StatelessWidget
    with AppButtonMixin, UserFeatureMixin {
  Function(int reportId, String description) onReportClick;

  ReportUserWidget({required this.onReportClick, Key? key}) : super(key: key);

  final ReportUserController _controller = Get.find(tag: Routes.REPORT_USER);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
                duration: const Duration(seconds: 1),
                height: isKeyboardHidden(context) ? null : 150,
                child: Flexible(child: _buildListViewWidget())),
            _buildCustomViewWidget,
            appWhiteButton(
                title: "Report",
                onClick: () {
                  if (_controller.validFields()) {
                    onReportClick(_controller.selectedIndex.value,
                        _controller.customDescription.trim());
                  }
                })
          ],
        ));
  }

  /// Build list view widget.
  Widget _buildListViewWidget() {
    return ListView.separated(
        itemBuilder: (_, index) {
          final reportUserObj = _controller.reportUserList[index];
          return ReportUserTileWidget(
              isSelected: _controller.selectedIndex.value == reportUserObj.id,
              model: reportUserObj,
              index: index,
              onSelect: _controller.onSelectionUpdate);
        },
        shrinkWrap: true,
        separatorBuilder: (_, index) {
          return const Divider(
            height: 2,
            color: Colors.transparent,
          );
        },
        itemCount: _controller.reportUserList.length);
  }

  /// Build custom view widget
  Widget get _buildCustomViewWidget => AnimatedContainer(
        duration: const Duration(seconds: 1),
        margin: const EdgeInsets.only(left: 70, bottom: 20),
        height: _controller.selectedIndex.value == -1 ? null : 0,
        padding: const EdgeInsets.only(bottom: AppValues.margin_14),
        child: AppInputField(
          ignoreTopPadding: true,
          label: AppString.reason,
          controller: _controller.reportReason,
          focusNode: _controller.reportFocusNode,
          onChange: _controller.setDescription,
        ),
      );
}
