import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_button_mixin.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:get/get.dart';

import '../../../../../../../infrastructure/navigation/routes.dart';
import '../../../../../../../values/app_colors.dart';
import '../../../../../../../values/app_icons.dart';
import '../../../../../../../values/app_values.dart';
import '../../../../../../app_widgets/base_view.dart';
import '../../../../../../app_widgets/coach_tile_widget.dart';
import '../controller/club_coach.controller.dart';
import 'coach_loading_shimmer.dart';

class ClubCoachScreen extends StatelessWidget with AppBarMixin, AppButtonMixin {
  ClubCoachScreen({Key? key}) : super(key: key);

  final ClubCoachController _controller =
      Get.find(tag: Routes.CLUB_COACHING_STAFF);

  late TextTheme textTheme;
  late BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: buildAppBarWithActions(
        title: AppString.coachingStaff,
        actions: [if (!_controller.editDetails) buildSkipButton()],
      ),
      floatingActionButton: buildAddFab(),
      body: SafeArea(
        child: buildBody(context),
      ),
    );
  }

  /// Build skip button.
  Widget buildSkipButton() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(top: AppValues.appbarTopMargin),
        child: TextButton(
          onPressed: _controller.isValidField.isFalse
              ? () => _controller.skipToNextScreen()
              : null,
          child: Text(
            AppString.skip,
            style: textTheme.displaySmall?.copyWith(
                color: _controller.isValidField.isTrue
                    ? AppColors.appWhiteButtonColorDisable
                    : AppColors.appRedButtonColor),
          ),
        ),
      ),
    );
  }

  /// add floating action button.
  Widget buildAddFab() => Padding(
        padding: const EdgeInsets.only(
            bottom: AppValues.height_100, right: AppValues.height_4),
        child: FloatingActionButton(
          onPressed: () => _controller.addCoachBottomSheet(),
          backgroundColor: AppColors.fabButtonBackgroundChange,
          child: SvgPicture.asset(
            AppIcons.iconAdd,
            width: AppValues.iconSize_28,
            height: AppValues.iconSize_28,
            color: AppColors.textColorDarkGray,
          ),
        ),
      );

  /// Widget build body.
  Widget buildBody(BuildContext context) => Padding(
        padding: const EdgeInsets.all(AppValues.screenMargin),
        child: Obx(
          () => Column(
            children: [
              Expanded(
                  child: AnimatedSwitcher(
                switchOutCurve: Curves.easeOutExpo,
                switchInCurve: Curves.fastLinearToSlowEaseIn,
                duration: const Duration(
                    milliseconds:
                        AppValues.shimmerWidgetChangeDurationInMillis),
                child: RefreshIndicator(
                  onRefresh: _controller.refreshList,
                  child: _controller.isLoading.isTrue
                      ? const CoachLoadingShimmerWidget()
                      : _controller.coachList.isNotEmpty
                          ? buildDirectorList()
                          : buildNoDirectors(),
                ),
              )),
              const SizedBox(
                height: AppValues.height_8,
              ),
              appWhiteButton(
                  title: _controller.editDetails
                      ? AppString.strUpdate
                      : AppString.strNext,
                  isValidate: _controller.isValidField.value,
                  onClick: () => _controller.onSubmit()),
              const SizedBox(
                height: AppValues.height_20,
              ),
            ],
          ),
        ),
      );

  /// Widget build directors list.
  Widget buildDirectorList() => ListView.separated(
        itemBuilder: (_, index) {
          final obj = _controller.coachList[index];
          return CoachTileWidget(
            model: obj,
            onMessageClick: _controller.onMessageClick,
            swipeToDeleteEnable: true,
            onCallClick: _controller.onCallClick,
            index: index,
            onEditMember: _controller.editDirector,
            onDeleteMember: _controller.deleteCoach,
          );
        },
        itemCount: _controller.coachList.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(
          height: AppValues.margin_10,
          color: Colors.transparent,
        ),
      );

  /// Build no directors widget.
  Widget buildNoDirectors() {
    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        height: AppValues.margin_100,
        child: DottedBorder(
          dashPattern: const [6, 6, 6, 6],
          strokeWidth: 1,
          color: AppColors.textPlaceholderColor,
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SizedBox(
              width: 100,
              height: AppValues.margin_30,
              child: appWhiteButton(
                  title: AppString.strAdd,
                  isValidate: true,
                  onClick: () => _controller.addCoachBottomSheet()),
            ),
          ),
        ),
      ),
    );
  }
}
