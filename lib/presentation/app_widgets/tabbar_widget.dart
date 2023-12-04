import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:game_on_flutter/values/app_colors.dart';
import 'package:game_on_flutter/values/app_icons.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../infrastructure/navigation/routes.dart';
import '../../values/app_values.dart';
import '../screens/home/club_player_detail/controllers/club_player_detail.controller.dart';

class TabbarWidget extends StatefulWidget {
  @override
  _TabbarWidgetState createState() => _TabbarWidgetState();
}

class _TabbarWidgetState extends State<TabbarWidget> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ClubPlayerDetailController _controller =
  Get.find(tag: Routes.CLUB_PLAYER_DETAIL);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          indicatorSize: TabBarIndicatorSize.label,
          controller: _tabController,
          indicatorPadding:const EdgeInsets.all(-10),
          unselectedLabelColor: Colors.white,
          labelColor: AppColors.appRedButtonColor,
          indicatorColor: AppColors.appRedButtonColor, // Customize the indicator color
          tabs:  [
            SvgPicture.asset(AppIcons.photo),
            SvgPicture.asset(AppIcons.video,color: Colors.white,),
          ],
        ),
        const SizedBox(height: AppValues.height_20),
        Container(
          height: 200,
          child: TabBarView(
            controller: _tabController,
            children:  [
              // Content for Tab 1
              Container(child: buildImageList()),buildVideoList(),
              // Content for Tab 2
           ]
          ),
        ),
      ],
    );
  }
  /// Build list widget.
  Widget buildImageList() => ListView.separated(
    itemBuilder: (_, index) {
      return Container(
        child: Column(
          children: [
            SizedBox(
              height: 100,
                width: 100,
                child: Image.network(_controller.image[index].video!))
          ],
        ),
      );
    },
    shrinkWrap: true,
    scrollDirection: Axis.horizontal,
    separatorBuilder: (_, index) {
      return Container(
        height: AppValues.margin_10,
      );
    },
    itemCount: _controller.image.length,
  );

  /// Build list widget.
  Widget buildVideoList() => ListView.separated(
    itemBuilder: (_, index) {
      return Container(
        child: Column(
          children: [
            SizedBox(
              height: 100,
                width: double.maxFinite,
                child: Image.network(_controller.image[index].video!,fit: BoxFit.fill,))
          ],
        ),
      );
    },
    shrinkWrap: true,
    scrollDirection: Axis.vertical,
    separatorBuilder: (_, index) {
      return Container(
        height: AppValues.margin_10,
      );
    },
    itemCount: _controller.image.length,
  );

}
