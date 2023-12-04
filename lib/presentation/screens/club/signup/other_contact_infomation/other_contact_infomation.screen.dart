import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../presentation/app_widgets/app_button_mixin.dart';
import '../../../../../presentation/app_widgets/app_text_mixin.dart';
import '../../../../../presentation/app_widgets/base_view.dart';
import '../../../../../presentation/app_widgets/user_contact_tile_widget.dart';
import '../../../../../presentation/screens/club/signup/club_board_members/controllers/club_board_members.controller.dart';
import '../../../../../values/app_colors.dart';
import '../../../../../values/app_icons.dart';
import '../../../../../values/app_string.dart';
import '../../../../../values/app_values.dart';
import '../club_board_members/model/club_member_model.dart';
import 'controllers/other_contact_infomation.controller.dart';

class OtherContactInformationScreen
    extends GetView<OtherContactInfomationController>
    with AppBarMixin, AppButtonMixin {
  OtherContactInformationScreen({Key? key}) : super(key: key);

  final OtherContactInfomationController _controller =
      Get.find(tag: Routes.OTHER_CONTACT_INFORMATION);

  late TextTheme textTheme;
  late BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: buildAppBarWithActions(
        title: AppString.clubContactInformation,
        actions: [if (!_controller.editDetails) buildSkipButton()],
      ),
      floatingActionButton: buildAddFab(),
      body: SafeArea(
        child: Obx(() => buildBody(context)),
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
          onPressed: () => _controller.addDirectorBottomSheet(),
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
  Widget buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppValues.screenMargin),
      child: Column(
        children: [
          Expanded(child: buildScrollableFields()),
          const SizedBox(
            height: 8,
          ),
          appWhiteButton(
              title: _controller.editDetails
                  ? AppString.strUpdate
                  : AppString.strNext,
              isValidate: _controller.isValidField.value,
              onClick: () => _controller.onSubmit()),
          const SizedBox(
            height: AppValues.screenMargin,
          ),
        ],
      ),
    );
  }

  /// Build scrollable fields.
  Widget buildScrollableFields() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if(_controller.isLoading.isFalse)
          _OtherMembersWidget(
            controller: _controller,
          ),
        ],
      ),
    );
  }

  /// Build title row.
  Widget buildTitleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        clubBoardMemberText,
        InkWell(
          onTap: () => _controller.addDirectorBottomSheet(),
          child: Text(
            AppString.plusAdd,
            style: textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.w400,
              color: AppColors.textColorSecondary.withOpacity(0.3),
            ),
          ),
        ),
      ],
    );
  }

  /// Build club board member text.
  Text get clubBoardMemberText => Text(
        AppString.clubOtherInformation,
        style: textTheme.bodyLarge,
      );
}

class _OtherMembersWidget extends StatelessWidget with AppTextMixin,AppButtonMixin {
  final OtherContactInfomationController controller;

  late TextTheme textTheme;

  _OtherMembersWidget({required this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return controller.groupMemberList.isNotEmpty
        ? buildMemberListGroup()
        : buildNoDirectors();
  }

  /// Build title row.
  Widget buildTitleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        screenTitle(
          textTheme: textTheme,
          value: AppString.directors,
        ),
        InkWell(
          onTap: () => controller.addDirectorBottomSheet(),
          child: Text(
            AppString.plusAdd,
            style: textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.w400,
              color: AppColors.textColorSecondary.withOpacity(0.3),
            ),
          ),
        ),
      ],
    );
  }

  /// Widget build directors list.
  Widget buildMemberListGroup() => ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) {
          final obj = controller.groupMemberList[index];
          if ((obj.memberList ?? []).isEmpty) {
            return Container();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              clubBoardMemberText(obj.role ?? ""),
              const SizedBox(
                height: AppValues.margin_10,
              ),
              buildMemberList(obj.memberList ?? [], index),
            ],
          );
        },
        itemCount: controller.groupMemberList.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(
          height: AppValues.margin_10,
          color: Colors.transparent,
        ),
      );

  /// Widget build directors list.
  Widget buildMemberList(List<ClubMemberModel> membersList, int roleIndex) =>
      ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) {
          final obj = membersList[index];
          return UserContactTileWidget(
            model: obj,
            onMessageClick: controller.onMessageClick,
            swipeToDeleteEnable: true,
            onCallClick: controller.onCallClick,
            index: index,
            onEditMember: (obj, index) =>
                controller.editDirector(obj, index, roleIndex),
            onDeleteMember: (obj, index) =>
                controller.deleteDirector(obj, index, roleIndex),
          );
        },
        itemCount: membersList.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(
          height: AppValues.margin_10,
          color: Colors.transparent,
        ),
      );

  /// Build club board member text.
  Text clubBoardMemberText(String title) => Text(
        title,
        style: textTheme.bodyLarge,
      );

  /// Build no directors widget.
  Widget buildNoDirectors() {
    return SizedBox(
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
                onClick: () => controller.addDirectorBottomSheet()),
          ),
        ),
      ),
    );
  }
}
