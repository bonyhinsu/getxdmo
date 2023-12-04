import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:game_on_flutter/presentation/screens/club/signup/club_location/view/location_loading_shimmer_widget.dart';
import 'package:game_on_flutter/values/app_icons.dart';
import 'package:get/get.dart';

import '../../../../../infrastructure/model/club/signup/selection_model.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../values/app_colors.dart';
import '../../../../../values/app_string.dart';
import '../../../../../values/app_values.dart';
import '../../../../app_widgets/app_button_mixin.dart';
import '../../../../app_widgets/base_view.dart';
import '../../../../custom_widgets/single_selection_tile_widget.dart';
import 'controllers/club_location.controller.dart';

class ClubLocationScreen extends GetView<ClubLocationController>
    with AppBarMixin, AppButtonMixin {
  ClubLocationScreen({Key? key}) : super(key: key);

  final ClubLocationController _controller =
      Get.find(tag: Routes.CLUB_LOCATION);

  late TextTheme textTheme;
  late BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    textTheme = Theme.of(context).textTheme;
    return Obx(
      () => Scaffold(
        appBar: buildAppBar(
            title: _controller.isClubSignup.isTrue
                ? AppString.chooseYourClubLocation
                : AppString.chooseYourLocation,
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If user resumed to this app, check permission
    if (state == AppLifecycleState.resumed) {
      _controller.fetchCurrentLocation();
    }
  }

  /// Build body widget.
  Widget buildBody() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: AppColors.pageBackground,
            height: AppValues.extraLargePadding,
          ),
          if (_controller.isClubSignup.isFalse) buildCurrentLocationWidget(),
          Container(
            color: AppColors.pageBackground,
            height: AppValues.height_20,
          ),
          Expanded(
              child: RefreshIndicator(
            onRefresh: _controller.onRefresh,
            child: AnimatedSwitcher(
              duration: const Duration(
                  milliseconds: AppValues.shimmerWidgetChangeDurationInMillis),
              child: _controller.isLoading.isTrue
                  ? const LocationLoadingShimmerWidget()
                  : buildSingleSelectionList(),
            ),
          )),
          Container(
            color: AppColors.pageBackground,
            height: AppValues.height_8,
          ),
          buildBottomButton(),
          Container(
            color: AppColors.pageBackground,
            height: AppValues.screenMargin,
          ),
        ],
      );

  /// Build single selection widget.
  Widget buildSingleSelectionList() => ListView.separated(
      separatorBuilder: (_, index) => Container(
            height: AppValues.height_16,
            color: AppColors.pageBackground,
          ),
      itemBuilder: (_, index) {
        final obj = _controller.clubLocationList[index];
        obj.itemIndex = index;
        return SingleSelectionTileWidget(
            model: obj,
            onSelectTile: (SelectionModel model) {
              _controller.setSelectedField(model, index);
            });
      },
      itemCount: _controller.clubLocationList.length);

  /// Build bottom button.
  Widget buildBottomButton() => appWhiteButton(
      title: AppString.strNext,
      isValidate: _controller.isValid.value,
      onClick: _controller.navigateToNextScreen);

  /// Build current location widget.
  Widget buildCurrentLocationWidget() => !_controller.isLocationAvailabale.value
      ? InkWell(
          onTap: () => _controller.fetchCurrentLocation(),
          child: Container(
            decoration: BoxDecoration(
              color:  AppColors.fabButtonBackgroundChange,
              borderRadius: BorderRadius.circular(AppValues.smallRadius),
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: AppValues.height_16, vertical: AppValues.height_20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(AppIcons.gpsLocationIcon),
                const SizedBox(
                  width: AppValues.margin_10,
                ),
                Expanded(
                  child: Text(
                    AppString.currentLocation,
                    style: textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        )
      : Container(
          decoration: BoxDecoration(
           color:  AppColors.fabButtonBackgroundChange,
            borderRadius: BorderRadius.circular(AppValues.smallRadius),
            border: Border.all(color: AppColors.appWhiteButtonColor)
          ),
          padding: const EdgeInsets.symmetric(
              horizontal: AppValues.height_16, vertical: AppValues.height_20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // SvgPicture.asset(AppIcons.gpsLocationIcon),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${_controller.city},${_controller.state}, ${_controller.country}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: textTheme.bodyLarge
                            ?.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              getLocationWidget(),
              const SizedBox(
                width: 10,
              ),
              deleteLocationWidget(),
              const SizedBox(
                width: 10,
              )
            ],
          ),
        );

  Widget deleteLocationWidget() {
    return GestureDetector(
        onTap: () {
          _controller.deleteCurrentLocation();
        },
        child: SvgPicture.asset(AppIcons.iconDeleteRound));
  }

  Widget getLocationWidget() {
    return GestureDetector(
        onTap: () {
          _controller.fetchCurrentLocation();
        },
        child: SvgPicture.asset(AppIcons.gpsLocationIcon));
  }
}
