import 'package:autoscale_tabbarview/autoscale_tabbarview.dart';
import 'package:flutter/material.dart';
import 'package:game_on_flutter/values/app_string.dart';

import '../../../../../infrastructure/model/user_info_model.dart';
import '../../../../../values/app_colors.dart';
import '../../../../../values/app_icons.dart';
import '../../../player/club_detail/view/club_detail_video_container.dart';
import '../../../player/club_detail/view/detail_tab_icon_widget.dart';
import '../../../player/club_detail/view/image_grid_container.dart';

class PlayerDetailTabWidget extends StatelessWidget {
  int selectedIndex;

  UserDetails clubListModel;

  Function() onImageViewAll;

  Function() onVideoClick;

  Function(int pos) onTabClick;

  Function(UserPhotos imageUrl, String heroTag, int index) onImageClick;

  PlayerDetailTabWidget(
      {required this.tabController,
      required this.onTabClick,
      required this.clubListModel,
      required this.selectedIndex,
      required this.onVideoClick,
      required this.onImageViewAll,
      required this.onImageClick,
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
            unselectedLabelColor: Colors.white,
            labelColor: AppColors.appRedButtonColor,
            indicatorColor: AppColors.appRedButtonColor,
            // Customize the indicator color
            tabs: [
              /// club images grid tab container
              DetailTabIconWidget(
                iconName: AppIcons.photo,
                menuTitle: AppString.photos,
                isSelected: selectedIndex == 0,
              ),

              /// club video tab.
              DetailTabIconWidget(
                iconName: AppIcons.video,
                menuTitle: AppString.video,
                isSelected: selectedIndex == 1,
                darkColorRequired: true,
              ),
            ],
          ),
        ),
        AutoScaleTabBarView(controller: tabController, children: [
          /// club images grid tab container
          ImageGridContainer(
            requireViewAll: true,
            onClick: onImageClick,
            onImageViewAll: onImageViewAll,
            images: clubListModel.userPhotos ?? [],
            preTag: 'player',
          ),

          /// club video tab container.
          ClubDetailVideoContainer(
            onVideoClick: onVideoClick,
            thumbnailURL: clubListModel.video ?? "",
          ),
        ]),
      ],
    );
  }
}
