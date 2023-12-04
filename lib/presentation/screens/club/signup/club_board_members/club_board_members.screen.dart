import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:get/get.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';

import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../values/app_colors.dart';
import '../../../../../values/app_values.dart';
import '../../../../app_widgets/app_button_mixin.dart';
import '../../../../app_widgets/app_shimmer.dart';
import '../../../../app_widgets/app_text_mixin.dart';
import '../../../../app_widgets/base_view.dart';
import '../../../../app_widgets/user_contact_tile_widget.dart';
import 'controllers/club_board_members.controller.dart';

class ClubBoardMembersScreen extends StatelessWidget
    with AppBarMixin, AppButtonMixin {
  ClubBoardMembersScreen({Key? key}) : super(key: key);

  final ClubBoardMembersController _controller =
      Get.find(tag: Routes.CLUB_BOARD_MEMBERS_PRESIDENT);

  late TextTheme textTheme;
  late BuildContext buildContext;
  HawkFabMenuController hawkFabMenuController = HawkFabMenuController();

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    textTheme = Theme.of(context).textTheme;
    final _key = GlobalKey<ExpandableFabState>();

    return Obx(
      () => Scaffold(
        appBar: buildAppBar(
          centerTitle: true,
          title: AppString.administration,
          backEnable: _controller.enableBack,
        ),
        body: SafeArea(
          child: Stack(
            children: [buildBody(context), buildMultiFabButton()],
          ),
        ),
        // floatingActionButtonLocation: ExpandableFab.location,
        // floatingActionButton: Padding(
        //   padding: EdgeInsets.only(bottom:110),
        //   child: ExpandableFab(
        //     key: _key,
        //     type: ExpandableFabType.up,
        //     // duration: const Duration(milliseconds: 500),
        //     distance: 75.0,
        //     // type: ExpandableFabType.up,
        //     // pos: ExpandableFabPos.left,
        //
        //     // fanAngle: 40,
        //     // openButtonBuilder: RotateFloatingActionButtonBuilder(
        //     //   child: const Icon(Icons.abc),
        //     //   fabSize: ExpandableFabSize.large,
        //     //   foregroundColor: Colors.amber,
        //     //   backgroundColor: Colors.green,
        //     //   shape: const CircleBorder(),
        //     //   angle: 3.14 * 2,
        //     // ),
        //     // closeButtonBuilder: FloatingActionButtonBuilder(
        //     //   size: 56,
        //     //   builder: (BuildContext context, void Function()? onPressed,
        //     //       Animation<double> progress) {
        //     //     return IconButton(
        //     //       onPressed: onPressed,
        //     //       icon: const Icon(
        //     //         Icons.check_circle_outline,
        //     //         size: 40,
        //     //       ),
        //     //     );
        //     //   },
        //     // ),
        //     overlayStyle: ExpandableFabOverlayStyle(
        //       color: Colors.black.withOpacity(0.5),
        //       // blur: 5,
        //     ),
        //
        //     children: [
        //       FloatingActionButton.small(
        //         // shape: const CircleBorder(),
        //         heroTag: null,
        //         backgroundColor: AppColors.fabButtonBackgroundChange,
        //         child: const Icon(Icons.add,color: AppColors.textColorDarkGray,),
        //         onPressed: () {
        //           ScaffoldMessenger.of(buildContext).hideCurrentSnackBar();
        //           _controller.addPresidentBottomSheet();
        //         },
        //       ),
        //       FloatingActionButton.small(
        //         // shape: const CircleBorder(),
        //         heroTag: null,
        //         backgroundColor: AppColors.fabButtonBackgroundChange,
        //         child: Row(children: [,const Icon(Icons.add,color: AppColors.textColorDarkGray)],
        //             ),
        //         onPressed: () {
        //           ScaffoldMessenger.of(buildContext).hideCurrentSnackBar();
        //           _controller.addDirectorBottomSheet();
        //         },
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }

  /// Widget build body.
  Widget buildBody(BuildContext context) => Padding(
        padding: const EdgeInsets.all(AppValues.screenMargin),
        child: Column(
          children: [
            Expanded(child: buildScrollableFields()),
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
      );

  /// Build scrollable fields.
  Widget buildScrollableFields() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 24,
          ),
          _PresidentNameWidget(),
          const SizedBox(
            height: 20,
          ),
          _DirectorsWidget(),
        ],
      ),
    );
  }

  /// Build multi fab button.
  Widget buildMultiFabButton() => Padding(
        padding: const EdgeInsets.only(
          bottom: AppValues.height_100,
          right: AppValues.height_10,
        ),
        child: HawkFabMenu(
          fabColor: AppColors.fabButtonBackgroundChange,
          iconColor: AppColors.textColorDarkGray,
          hawkFabMenuController: hawkFabMenuController,
          openIcon: Icons.add,
          closeIcon: Icons.close_rounded,
          blur: 0.0,
          items: [
            if ((_controller.presidentObj.value.userName ?? "").isEmpty)
              HawkFabMenuItem(
                label: AppString.addPresident,
                labelBackgroundColor: Colors.transparent,
                labelColor: AppColors.textColorDarkGray,
                color: AppColors.fabButtonBackgroundChange,
                ontap: () {
                  ScaffoldMessenger.of(buildContext).hideCurrentSnackBar();
                  _controller.addPresidentBottomSheet();
                },
                icon: const Icon(
                  Icons.add,
                  color: AppColors.textColorDarkGray,
                ),
              ),
            HawkFabMenuItem(
              label: AppString.addDirectors,
              ontap: () {
                ScaffoldMessenger.of(buildContext).hideCurrentSnackBar();
                _controller.addDirectorBottomSheet();
              },
              labelBackgroundColor: Colors.transparent,
              labelColor: AppColors.textColorDarkGray,
              color: AppColors.fabButtonBackgroundChange,
              icon: const Icon(
                Icons.add,
                color: AppColors.textColorDarkGray,
              ),
            ),
          ],
          body: Container(),
        ),
      );

  /// Build club board member text.
  Text get clubBoardMemberText => Text(
        AppString.clubBoardMembers,
        style: textTheme.bodyLarge,
      );

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
}

class _PresidentNameWidget extends StatelessWidget
    with AppTextMixin, AppButtonMixin {
  final ClubBoardMembersController _controller =
      Get.find(tag: Routes.CLUB_BOARD_MEMBERS_PRESIDENT);

  _PresidentNameWidget({Key? key}) : super(key: key);

  late TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          buildTitleRow(),
          const SizedBox(
            height: AppValues.margin_10,
          ),
          _controller.isLoading.isTrue
              ? AppShimmer(
                  child: Container(
                    color: Colors.white.withOpacity(0.4),
                    height: 44,
                  ),
                )
              : (_controller.presidentObj.value.userName ?? "").isNotEmpty
                  ? UserContactTileWidget(
                      model: _controller.presidentObj.value,
                      onCallClick: _controller.onCallClick,
                      onEditMember: _controller.editPresident,
                      onMessageClick: _controller.onMessageClick,
                      index: 0,
                      swipeToDeleteEnable: true,
                      enableDelete: false,
                      onDeleteMember: _controller.deletePresident,
                    )
                  : buildNoPresident()
        ],
      ),
    );
  }

  /// Build title row.
  Widget buildTitleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        screenTitle(
            textTheme: textTheme,
            value: AppString.presidentName,
            isMandatory: true),
      ],
    );
  }

  /// Build no directors widget.
  Widget buildNoPresident() {
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
                onClick: () => _controller.addPresidentBottomSheet()),
          ),
        ),
      ),
    );
  }
}

class _DirectorsWidget extends StatelessWidget
    with AppTextMixin, AppButtonMixin {
  final ClubBoardMembersController _controller =
      Get.find(tag: Routes.CLUB_BOARD_MEMBERS_DIRECTORS);

  late TextTheme textTheme;

  _DirectorsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return Obx(
      () => Column(
        children: [
          buildTitleRow(),
          const SizedBox(
            height: AppValues.margin_10,
          ),
          if(_controller.isLoading.isFalse)
          _controller.directorsList.isNotEmpty
              ? buildDirectorList()
              : buildNoDirectors()
        ],
      ),
    );
  }

  /// Build title row.
  Widget buildTitleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        screenTitle(
          textTheme: textTheme,
          value: AppString.directors,
        ),
        /*InkWell(
          onTap: () => _controller.addDirectorBottomSheet(),
          child: Text(
            AppString.plusAdd,
            style: textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.w400,
              color: AppColors.textColorSecondary.withOpacity(0.3),
            ),
          ),
        ),*/
      ],
    );
  }

  /// Widget build directors list.
  Widget buildDirectorList() => ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) {
          final obj = _controller.directorsList[index];
          return UserContactTileWidget(
            model: obj,
            onMessageClick: _controller.onMessageClick,
            swipeToDeleteEnable: true,
            onCallClick: _controller.onCallClick,
            index: index,
            onEditMember: _controller.editDirector,
            onDeleteMember: _controller.deleteDirector,
          );
        },
        itemCount: _controller.directorsList.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(
          height: AppValues.margin_10,
          color: Colors.transparent,
        ),
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
                onClick: () => _controller.addDirectorBottomSheet()),
          ),
        ),
      ),
    );
  }
}
