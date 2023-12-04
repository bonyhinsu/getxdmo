import 'package:autoscale_tabbarview/autoscale_tabbarview.dart';
import 'package:flutter/material.dart';
import 'package:game_on_flutter/presentation/screens/player/club_detail/view/map_container_widget.dart';

import '../../../../../infrastructure/model/club/home/club_list_model.dart';
import '../../../../../infrastructure/model/user_info_model.dart';
import '../../../../../values/app_colors.dart';
import '../../../../../values/app_icons.dart';
import '../../../club/signup/club_board_members/controllers/club_board_members.controller.dart';
import '../../../club/signup/club_board_members/model/club_member_model.dart';
import 'club_board_member_tab_widget.dart';
import 'club_detail_video_container.dart';
import 'detail_tab_icon_widget.dart';
import 'image_grid_container.dart';

class ClubDetailTabWidget extends StatelessWidget {
  int selectedIndex;
  UserDetails clubListModel;
  Function() onImageViewAll;
  Function() onVideoClick;
  Function(ClubMemberModel model) onCallClick;
  Function(ClubMemberModel model) onMessageClick;
  Function(UserPhotos imageUrl, String heroTag, int index) onImageClick;
  Function(int pos) onTabClick;

  /// President list
  List<ClubMemberModel> presidentList = [];

  /// Director list
  List<ClubMemberModel> directorList = [];

  /// Other board member list
  List<ClubMemberModel> otherBoardMemberList = [];

  /// Coaching staff list.
  List<ClubMemberModel> coachingStaffList = [];

  ClubDetailTabWidget(
      {required this.tabController,
      required this.onTabClick,
      required this.clubListModel,
      required this.selectedIndex,
      required this.onImageViewAll,
      required this.onVideoClick,
      required this.onCallClick,
      required this.onMessageClick,
      required this.onImageClick,
      required this.presidentList,
      required this.directorList,
      required this.otherBoardMemberList,
      required this.coachingStaffList,
      Key? key})
      : super(key: key);

  late TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: AppColors.textFieldBackgroundColor, width: 0.5)),
          ),
          child: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            controller: tabController,
            onTap: (index) => onTabClick(index),
            indicatorPadding: const EdgeInsets.all(-10),
            unselectedLabelColor: Colors.white,
            labelColor: AppColors.appRedButtonColor,
            indicatorColor: AppColors.appRedButtonColor,
            // Customize the indicator color
            tabs: [
              /// club location tab.
              DetailTabIconWidget(
                iconName: AppIcons.locationIcon,
                isSelected: selectedIndex == 0,
                darkColorRequired: true,
              ),

              /// club images grid tab container
              DetailTabIconWidget(
                iconName: AppIcons.photo,
                isSelected: selectedIndex == 1,
              ),

              /// club video tab.
              DetailTabIconWidget(
                iconName: AppIcons.video,
                isSelected: selectedIndex == 2,
                darkColorRequired: true,
              ),

              /// Club board member tab.
              DetailTabIconWidget(
                iconName: AppIcons.profileIcon,
                isSelected: selectedIndex == 3,
              ),
            ],
          ),
        ),
        AutoScaleTabBarView(controller: tabController, children: [
          /// club location tab container.
          MapContainerWidget(
            mapUrl: "",
          ),

          /// club images grid tab container
          ImageGridContainer(
            requireViewAll: true,
            onClick: onImageClick,
            onImageViewAll: onImageViewAll,
            images: clubListModel.userPhotos ?? [],
            preTag: 'club',
          ),

          /// club video tab container.
          ClubDetailVideoContainer(
            thumbnailURL: clubListModel.video ?? "",
            onVideoClick: onVideoClick,
          ),

          /// Club board member tab container.
          ClubBoardMemberWidget(
            onCallClick: onCallClick,
            onMessageClick: onMessageClick,
            boardMembers: otherBoardMemberList,
            coachingStaff: coachingStaffList,
            directorList: directorList,
            presidentList: presidentList,
          ),
        ]),
      ],
    );
  }
}
