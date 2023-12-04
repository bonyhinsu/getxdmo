import 'package:flutter/material.dart';
import 'package:game_on_flutter/presentation/screens/club/signup/sports_selection/view/sport_type_shimmer_widget.dart';
import 'package:game_on_flutter/values/app_colors.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:get/get.dart';

import '../../../../../infrastructure/model/club/signup/selection_model.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../values/app_values.dart';
import '../../../../app_widgets/app_button_mixin.dart';
import '../../../../app_widgets/base_view.dart';
import '../../../../custom_widgets/single_selection_tile_widget.dart';
import 'controllers/sports_selection.controller.dart';

class SportsSelectionScreen extends GetView<SportsSelectionController>
    with AppBarMixin, AppButtonMixin {
  final SportsSelectionController _controller =
      Get.find(tag: Routes.SPORT_TYPE);

  SportsSelectionScreen({Key? key}) : super(key: key);

  late TextTheme textTheme;
  late BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    textTheme = Theme.of(context).textTheme;
    return Obx(
      () => Scaffold(
        appBar: buildAppBar(
            title: _controller.isClub.isTrue
                ? AppString.chooseYourClubSport
                : AppString.chooseYourSport,
            centerTitle: true),
        body: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppValues.screenMargin),
            child: buildBody(),
          ),
        ),
      ),
    );
  }

  /// Build body widget.
  Widget buildBody() => Column(
        children: [
          Container(
            height: AppValues.screenMargin,
            color: AppColors.pageBackground,
          ),
          Expanded(
              child: RefreshIndicator(
            onRefresh: _controller.onRefresh,
            child: AnimatedSwitcher(
              duration: const Duration(
                  milliseconds: AppValues.shimmerWidgetChangeDurationInMillis),
              child: _controller.isLoading.isTrue
                  ? const SportTypeShimmerWidget()
                  : _controller.isLoading.isFalse && _controller.sportsTypeList.isNotEmpty?buildSingleSelectionList():_buildNoSportAdded(),
            ),
          )),
          Container(
            height: AppValues.smallPadding,
            color: AppColors.pageBackground,
          ),
          buildBottomButton(),
          Container(
            height: AppValues.screenMargin,
            color: AppColors.pageBackground,
          )
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
        final obj = _controller.sportsTypeList[index];
        obj.itemIndex = index;
        return SingleSelectionTileWidget(
            model: obj,
            onSelectTile: (SelectionModel model) {
              _controller.setSelectedField(model, index);
            });
      },
      itemCount: _controller.sportsTypeList.length);

  /// Build bottom button.
  Widget buildBottomButton() => appWhiteButton(
      title: AppString.strNext,
      isValidate: _controller.isValid.value,
      onClick: _controller.navigateToNextScreen);

  /// Build no sport added
  Widget _buildNoSportAdded()=>Center(child: Text(AppString.noSportAvailable,style: textTheme.displaySmall?.copyWith()));
}
