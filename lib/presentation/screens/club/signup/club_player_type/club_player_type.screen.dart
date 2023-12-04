import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../infrastructure/model/club/signup/selection_model.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../values/app_string.dart';
import '../../../../../values/app_values.dart';
import '../../../../app_widgets/app_button_mixin.dart';
import '../../../../app_widgets/base_view.dart';
import '../../../../custom_widgets/single_selection_tile_widget.dart';
import '../club_location/view/location_loading_shimmer_widget.dart';
import 'controllers/club_player_type.controller.dart';

class ClubPlayerTypeScreen extends GetView<ClubPlayerTypeController>
    with AppBarMixin, AppButtonMixin {
  ClubPlayerTypeScreen({Key? key}) : super(key: key);

  final ClubPlayerTypeController _controller =
      Get.find(tag: Routes.CLUB_PLAYER_TYPE);

  late TextTheme textTheme;
  late BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: buildAppBar(title: AppString.whoCanPlay, centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppValues.screenMargin),
          child: Obx(
            () => buildBody(),
          ),
        ),
      ),
    );
  }

  /// Build body widget.
  Widget buildBody() => Column(
        children: [
          Expanded(
              child: RefreshIndicator(
                onRefresh: _controller.onRefresh,
                child: _controller.isLoading.isTrue
                    ? const LocationLoadingShimmerWidget()
                    : _controller.isLoading.isFalse &&
                            _controller.playerTypeList.isEmpty
                        ? _buildNoWidget()
                        : buildSingleSelectionList(),
              )),
          buildBottomButton(),
        ],
      );

  /// Build single selection widget.
  Widget buildSingleSelectionList() => ListView.separated(
    padding: const EdgeInsets.only(top: AppValues.height_20),
      separatorBuilder: (_, index) => const Divider(
            height: AppValues.height_16,
            color: Colors.transparent,
          ),
      itemBuilder: (_, index) {
        final obj = _controller.playerTypeList[index];
        obj.itemIndex = index;
        return SingleSelectionTileWidget(
            model: obj,
            onSelectTile: (SelectionModel model) {
              _controller.setSelectedField(model, index);
            });
      },
      itemCount: _controller.playerTypeList.length);

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
