import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:get/get.dart';

import '../../../../infrastructure/navigation/routes.dart';
import '../../../../values/app_colors.dart';
import '../../../../values/app_font_size.dart';
import '../../../../values/app_icons.dart';
import '../../../../values/app_values.dart';
import '../../../../values/common_utils.dart';
import '../../../app_widgets/app_shimmer.dart';
import '../../../app_widgets/club_profile_widget.dart';
import '../../../app_widgets/event_image_widget.dart';
import '../../../custom_widgets/post_edit_menu_widget.dart';
import 'controllers/result_detail.controller.dart';

class ResultDetailScreen extends GetView<ResultDetailController> {
  ResultDetailScreen({Key? key}) : super(key: key);

  final ResultDetailController _controller =
      Get.find(tag: Routes.RESULT_DETAIL);

  late TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return Obx(
      () => Scaffold(
        appBar: buildHeaderAppbar(),
        body: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppValues.screenMargin),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: AppValues.screenMargin,
                ),
                AnimatedSwitcher(
                  duration: const Duration(
                      milliseconds:
                          AppValues.shimmerWidgetChangeDurationInMillis),
                  child: _controller.isLoading.isTrue
                      ? AppShimmer(
                          child: Container(
                            height: AppValues.eventDetailPostImageHeight,
                            width: double.infinity,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        )
                      : (_controller.postModel.value.resultImage ?? "")
                              .isNotEmpty
                          ? EventImageWidget(
                              height: AppValues.eventDetailPostImageHeight,
                              isAssetUrl: false,
                              width: double.infinity,
                              profileURL:
                                  _controller.postModel.value.resultImage ?? "",
                            )
                          : Container(),
                ),
                const SizedBox(
                  height: AppValues.height_20,
                ),
                if (_controller.isLoading.isTrue ||
                    (_controller.postModel.value.time ?? "").isNotEmpty)
                  buildDateWidget(),
                if (_controller.isLoading.isTrue ||
                    (_controller.postModel.value.time ?? "").isNotEmpty)
                  const SizedBox(
                    height: AppValues.height_20,
                  ),
                if (_controller.isLoading.isTrue ||
                    (_controller.postModel.value.title ?? "").isNotEmpty)
                  buildTitle(),
                if (_controller.isLoading.isTrue ||
                    (_controller.postModel.value.title ?? "").isNotEmpty)
                  const SizedBox(
                    height: AppValues.height_10,
                  ),
                if (
                    (_controller.postModel.value.eventDate ?? "").isNotEmpty)
                  buildRowWidget(),
                if (_controller.isLoading.isTrue ||
                    _controller.postModel.value.teamA.isNotEmpty &&
                        _controller.postModel.value.teamB.isNotEmpty)
                  const SizedBox(
                    height: AppValues.height_16,
                  ),
                if (_controller.isLoading.isTrue ||
                    (_controller.postModel.value.teamA.isNotEmpty &&
                        _controller.postModel.value.teamB.isNotEmpty))
                  buildTeamText(),
                const SizedBox(
                  height: AppValues.height_16,
                ),
                buildDescriptionField(
                    title: AppString.highlights,
                    value: _controller.postModel.value.highlight ?? ""),
                const SizedBox(
                  height: AppValues.height_16,
                ),
                buildDescriptionField(
                    title: AppString.otherDetails,
                    value: _controller.postModel.value.otherDetails ?? ""),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build header app bar widget
  AppBar buildHeaderAppbar() => AppBar(
        elevation: 0,
        backgroundColor: AppColors.pageBackground,
        leadingWidth: AppValues.appbarBackButtonSize + AppValues.screenMargin,
        centerTitle: true,
        leading: FittedBox(
          fit: BoxFit.contain,
          child: buildIconButton(
              icon: AppIcons.backArrowIcon, onClick: _controller.onBackPressed),
        ),
        title: GestureDetector(
          onTap: _controller.onHeaderClick,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildClubProfilePicture(),
              const SizedBox(
                width: AppValues.height_12,
              ),
              Expanded(
                  child: buildTitleText(
                      title: _controller.postModel.value.clubName ?? "",
                      isMainTitle: true)),
            ],
          ),
        ),
        actions: [
          _controller.enableEdit
              ? Padding(
                  padding: const EdgeInsets.only(
                      top: AppValues.appbarTopMargin,
                      right: AppValues.screenMargin,
                      bottom: AppValues.appbarTopMargin),
                  child: PostEditMenuWidget(
                    onDelete: _controller.onDeletePost,
                    onEdit: _controller.onEditPost,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(
                      top: AppValues.appbarTopMargin,
                      right: AppValues.height_6,
                      bottom: AppValues.appbarTopMargin),
                  child: IconButton(
                    onPressed: _controller.onShare,
                    icon: SizedBox(
                      width: AppValues.iconSize_24,
                      height: AppValues.iconSize_24,
                      child: SvgPicture.asset(
                        AppIcons.iconShare,
                      ),
                    ),
                  ),
                )
        ],
      );

  /// Build club profile picture.
  Widget buildClubProfilePicture() {
    const editIconSize = 42.0;
    return Padding(
      padding: const EdgeInsets.only(
          top: AppValues.appbarTopMargin, bottom: AppValues.appbarTopMargin),
      child: ClubProfileWidget(
        profileURL: _controller.postModel.value.clubLogo ?? "",
        width: editIconSize,
        height: editIconSize,
      ),
    );
  }

  /// Build player position text.
  Widget buildDateWidget() => AnimatedSwitcher(
        duration: const Duration(
            milliseconds: AppValues.shimmerWidgetChangeDurationInMillis),
        child: _controller.isLoading.isTrue
            ? AppShimmer(
                child: Container(
                  height: 16,
                  width: 80,
                  color: Colors.white.withOpacity(0.5),
                ),
              )
            : Text(
                CommonUtils.getRemainingDaysInWord(
                    _controller.postModel.value.time ?? "", isUTC: true),
                style: textTheme.headlineSmall
                    ?.copyWith(color: AppColors.textColorDarkGray),
              ),
      );

  /// Build league title.
  Widget buildTitle() => AnimatedSwitcher(
        duration: const Duration(
            milliseconds: AppValues.shimmerWidgetChangeDurationInMillis),
        child: _controller.isLoading.isTrue
            ? AppShimmer(
                child: Container(
                  height: 16,
                  width: 130,
                  color: Colors.white.withOpacity(0.5),
                ),
              )
            : Text(
                _controller.postModel.value.title ?? "",
                textAlign: TextAlign.start,
                style: textTheme.headlineMedium
                    ?.copyWith(color: AppColors.textColorSecondary),
              ),
      );

  /// Build row widget.
  Widget buildRowWidget() {
    final eventDate = CommonUtils.convertToUserReadableDateWithTimeZone(
        _controller.postModel.value.eventDate ?? "");
    return Row(
      children: [
        buildItemWidget(title: eventDate, icon: AppIcons.postDateIcon),
        buildItemWidget(
            title: _controller.postModel.value.location ?? "",
            icon: AppIcons.postLocationIcon,
            isLast: true),
      ],
    );
  }

  /// Build item widget.
  Widget buildItemWidget(
          {String title = "", String icon = "", bool isLast = false}) =>
      Padding(
        padding: EdgeInsets.only(
            right: isLast ? 0 : AppValues.height_20, top: AppValues.height_10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              color: AppColors.textColorSecondary,
              height: AppValues.iconSmallSize,
              width: AppValues.iconSmallSize,
            ),
            const SizedBox(
              width: 4,
            ),
            Flexible(
                child: AnimatedSwitcher(
              duration: const Duration(
                  milliseconds: AppValues.shimmerWidgetChangeDurationInMillis),
              child: _controller.isLoading.isTrue
                  ? AppShimmer(
                      child: Container(
                        height: 16,
                        width: 80,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    )
                  : Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.displaySmall?.copyWith(
                        color: AppColors.textColorDarkGray,
                      ),
                    ),
            )),
          ],
        ),
      );

  /// Build text content.
  Widget buildTeamText() => Text(
        "${_controller.postModel.value.teamA} VS ${_controller.postModel.value.teamB}",
        textAlign: TextAlign.start,
        style: textTheme.headlineSmall
            ?.copyWith(color: AppColors.textColorDarkGray, fontSize: 13),
      );

  /// Return back button widget.
  Widget buildIconButton({Function? onClick, required String icon}) =>
      GestureDetector(
        onTap: onClick == null ? () => Get.back() : () => onClick(),
        child: Container(
          margin: const EdgeInsets.only(
              left: AppValues.screenMargin,
              top: AppValues.appbarTopMargin,
              bottom: AppValues.appbarTopMargin),
          decoration: BoxDecoration(
              border:
                  Border.all(color: AppColors.inputFieldBorderColor, width: 1),
              color: AppColors.textColorSecondary.withOpacity(0.20),
              borderRadius: BorderRadius.circular(AppValues.smallRadius)),
          height: AppValues.appbarBackButtonSize,
          width: AppValues.appbarBackButtonSize,
          padding: const EdgeInsets.all(AppValues.smallPadding),
          child: SvgPicture.asset(icon),
        ),
      );

  /// Return title widget.
  Widget buildTitleText({required String title, bool isMainTitle = true}) {
    return Text(
      title,
      style: TextStyle(
          fontWeight: FontWeight.w600,
          fontFamily: FontConstants.poppins,
          fontSize: isMainTitle ? 18 : 16,
          color: AppColors.textColorSecondary),
    );
  }

  /// Build item widget.
  Widget buildDescriptionField({String title = "", String value = ""}) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: textTheme.headlineSmall?.copyWith(
                color: AppColors.textColorSecondary,
                fontWeight: FontWeight.w500,
                fontSize: 13),
          ),
          const SizedBox(
            height: 4,
          ),
          AnimatedSwitcher(
            duration: const Duration(
                milliseconds: AppValues.shimmerWidgetChangeDurationInMillis),
            child: _controller.isLoading.isTrue
                ? AppShimmer(
                    child: Column(
                      children: [
                        Container(
                          height: 16,
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 8),
                          color: Colors.white.withOpacity(0.5),
                        ),
                        Container(
                          height: 16,
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 8),
                          color: Colors.white.withOpacity(0.5),
                        ),
                        Container(
                          height: 16,
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 8),
                          color: Colors.white.withOpacity(0.5),
                        ),
                        Container(
                          height: 16,
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 8),
                          color: Colors.white.withOpacity(0.5),
                        ),
                        Container(
                          height: 16,
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 8),
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ],
                    ),
                  )
                : Text(
                    value,
                    style: textTheme.headlineSmall?.copyWith(
                        color: AppColors.textColorDarkGray, fontSize: 13),
                  ),
          ),
        ],
      );
}
