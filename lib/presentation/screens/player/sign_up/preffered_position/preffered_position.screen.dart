import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../infrastructure/model/club/signup/selection_model.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../values/app_string.dart';
import '../../../../../values/app_values.dart';
import '../../../../app_widgets/app_button_mixin.dart';
import '../../../../app_widgets/base_view.dart';
import '../../../../custom_widgets/single_selection_tile_widget.dart';
import '../../../club/signup/club_location/view/location_loading_shimmer_widget.dart';
import 'controllers/preffered_position.controller.dart';

class PrefferedPositionScreen extends GetView<PrefferedPositionController>
    with AppBarMixin, AppButtonMixin {
  PrefferedPositionScreen({Key? key}) : super(key: key);

  final PrefferedPositionController _controller =
      Get.find(tag: Routes.PREFFERED_POSITION);

  late TextTheme textTheme;
  late BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return Obx(
      () => Scaffold(
        appBar:
            buildAppBar(title: AppString.preferredPosition, centerTitle: true),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppValues.screenMargin),
            child: buildBody(),
          ),
        ),
      ),
    );
  }

  /// Build single selection widget.
  Widget buildSingleSelectionList() => ListView.separated(
      separatorBuilder: (_, index) => const Divider(
            height: AppValues.height_16,
            color: Colors.transparent,
          ),
      itemBuilder: (_, index) {
        final obj = _controller.playerPositionList[index];
        obj.itemIndex = index;
        return SingleSelectionTileWidget(
            model: obj,
            index: index,
            enableInfo: true,
            onInfoClick: _controller.onInfoClick,
            onSelectTile: (SelectionModel model) {
              _controller.setSelectedField(model, index);
            });
      },
      itemCount: _controller.playerPositionList.length);

  /// Build body widget.
  Widget buildBody() => Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _controller.onRefresh,
              child: _controller.isLoading.isTrue
                  ? const LocationLoadingShimmerWidget()
                  : _controller.isLoading.isFalse &&
                          _controller.playerPositionList.isEmpty
                      ? _buildNoWidget()
                      : buildSingleSelectionList(),
            ),
          ),
          buildBottomButton(),
        ],
      );

  /// Build bottom button.
  Widget buildBottomButton() => appWhiteButton(
      title: AppString.strNext,
      isValidate: _controller.isValid.value,
      onClick: _controller.navigateToNextScreen);

  /// Build no data widget.
  Widget _buildNoWidget() {
    return Container();
  }
}
