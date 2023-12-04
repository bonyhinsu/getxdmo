import 'package:flutter/material.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:game_on_flutter/values/app_values.dart';

import '../../../../../values/app_colors.dart';
import '../../../../app_widgets/coach_tile_widget.dart';
import '../../../../app_widgets/user_contact_tile_widget.dart';
import '../../../club/signup/club_board_members/model/club_member_model.dart';

class ClubBoardMemberWidget extends StatelessWidget {
  Function(ClubMemberModel model) onCallClick;
  Function(ClubMemberModel model) onMessageClick;
  List<ClubMemberModel> presidentList;
  List<ClubMemberModel> directorList;
  List<ClubMemberModel> boardMembers;
  List<ClubMemberModel> coachingStaff;

  /// text theme
  late TextTheme textTheme;

  ClubBoardMemberWidget(
      {required this.presidentList,
      required this.directorList,
      required this.boardMembers,
      required this.coachingStaff,
      required this.onCallClick,
      required this.onMessageClick,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(top: AppValues.height_16),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Administration title.
            buildTitle(),

            /// President list.
            if (presidentList.isNotEmpty)
              buildSection(
                  title: AppString.presidentName,
                  memberList: presidentList ?? []),

            /// Club directors list.
            if (directorList.isNotEmpty)
              buildSection(
                  title: AppString.directors, memberList: directorList ?? []),

            /// Club other member list.
            if (boardMembers.isNotEmpty)
              buildSection(
                  title: AppString.otherContactInformation,
                  requiredRole: true,
                  memberList: boardMembers ?? []),

            /// Club coach member list.
            if (coachingStaff.isNotEmpty)
              buildSection(
                  title: AppString.coachingStaff,
                  memberList: coachingStaff ?? [],
                  coachList: true),

            if (presidentList.isEmpty &&
                directorList.isEmpty &&
                boardMembers.isEmpty &&
                coachingStaff.isEmpty)
              _noMemberAvailableWidget()
          ],
        ),
      ),
    );
  }

  /// build title button.
  Widget buildTitle() => Padding(
        padding: const EdgeInsets.only(top: AppValues.height_20),
        child: Text(
          AppString.administration,
          textAlign: TextAlign.start,
          overflow: TextOverflow.ellipsis,
          style: textTheme.headlineMedium
              ?.copyWith(color: AppColors.textColorWhite),
        ),
      );

  /// Build section widget.
  Widget buildSection(
      {required String title,
      required List<ClubMemberModel> memberList,
      bool requiredRole = false,
      bool coachList = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: AppValues.height_20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          buildTitleWidget(title),
          const SizedBox(
            height: AppValues.height_10,
          ),
          coachList
              ? buildCoachingList(coachingStaff)
              : buildMemberList(memberList, requiredRole: requiredRole),
        ],
      ),
    );
  }

  /// Club section title widget.
  Widget buildTitleWidget(String title) => Text(
        title,
        style: textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textColorSecondary.withOpacity(0.8)),
      );

  /// Club member list.
  Widget buildMemberList(List<ClubMemberModel> memberList,
          {bool requiredRole = false}) =>
      ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) {
          final obj = memberList[index];
          return UserContactTileWidget(
            index: index,
            model: obj,
            onMessageClick: onMessageClick,
            onCallClick: onCallClick,
            requireRole: requiredRole,
            onEditMember: (_, __) {},
            onDeleteMember: (_, __) {},
            swipeToDeleteEnable: false,
          );
        },
        itemCount: memberList.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(
          height: AppValues.margin_10,
          color: Colors.transparent,
        ),
      );

  /// Club coach member list.
  Widget buildCoachingList(List<ClubMemberModel> memberList) =>
      ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) {
          final obj = memberList[index];
          return CoachTileWidget(
            model: obj,
            onMessageClick: onMessageClick,
            swipeToDeleteEnable: false,
            onCallClick: onCallClick,
            index: index,
            onEditMember: (_, __) {},
            onDeleteMember: (_, __) {},
          );
        },
        itemCount: memberList.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(
          height: AppValues.margin_10,
          color: Colors.transparent,
        ),
      );

  /// No members available
  Widget _noMemberAvailableWidget() {
    return SizedBox(
      height: 100,
      child: Center(
          child: Text('No members available.',
              style: textTheme.displaySmall
                  ?.copyWith(color: AppColors.textColorTernary))),
    );
  }
}
