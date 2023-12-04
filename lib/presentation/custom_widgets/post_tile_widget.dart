import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:game_on_flutter/infrastructure/model/common/app_fields.dart';
import 'package:game_on_flutter/presentation/custom_widgets/post_club_detail_sharable_widget.dart';
import 'package:game_on_flutter/presentation/custom_widgets/post_club_detail_widget.dart';
import 'package:get/get.dart';

import '../../infrastructure/model/club/post/post_model.dart';
import '../../values/app_colors.dart';
import '../../values/app_values.dart';
import '../app_widgets/event_image_widget.dart';
import '../app_widgets/slider_indicator_widget.dart';
import '../screens/player/player_home/controllers/player_home.controller.dart';

class PostTileWidget extends StatelessWidget {
  PostModel postModel;

  Function(PostModel postModel, int index) onEdit;

  Function(PostModel postModel, int index) onDelete;

  Function(PostModel postModel) onPostClick;
  Function(PostModel postModel,int index) onClubClick;

  bool postShareEnable;

  int index;

  Function(PostModel postModel)? onShare;

  final pagerController = PageController(
    initialPage: 0,
  );

  RxInt dotIndex = 0.obs;

  PostTileWidget(
      {required this.postModel,
      required this.onEdit,
      required this.onDelete,
      required this.onPostClick,
      required this.onClubClick,
      this.onShare,
      required this.index,
      this.postShareEnable = false,
      Key? key})
      : super(key: key);

  late TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return ListTile(
      onTap: () => onPostClick(postModel),
      contentPadding: const EdgeInsets.only(
          left: AppValues.mediumPadding,
          right: AppValues.mediumPadding,
          top: AppValues.mediumPadding,
          bottom: AppValues.padding_6),
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.transparent, width: 1),
          borderRadius: BorderRadius.circular(AppValues.roundedButtonRadius)),
      tileColor: AppColors.textColorSecondary.withOpacity(0.1),
      autofocus: true,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          postModel.viewType == PostViewType.post
              ? buildPostMultipleImageSlider()
              : buildPostImage(),
          if((postModel.postDescription ?? "").isNotEmpty)
          const SizedBox(
            height: 8,
          ),
          if((postModel.postDescription ?? "").isNotEmpty)
          buildText(),
          !postShareEnable
              ? PostClubDetailWidget(
                  postModel: postModel,
                  onEdit: () => onEdit(postModel, index),
                  onDelete: () => onDelete(postModel, index),
                  onClubClick: () => onClubClick(postModel, index),
                )
              : PostClubDetailSharableWidget(
                  postModel: postModel,
                  onShare: onShare!,
                  onClubClick: () => onClubClick(postModel, index),
                ),
        ],
      ),
    );
  }

  Widget buildPostMultipleImageSlider() {
    return ((postModel.postImage ?? []).isNotEmpty)?Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ExpandablePageView.builder(
          itemCount: (postModel.postImage ?? []).length,
          onPageChanged: (int page) {
            dotIndex.value = page;
          },
          controller: pagerController,
          itemBuilder: (BuildContext context, int itemIndex) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(AppValues.smallRadius),
              child: CachedNetworkImage(
                imageUrl: '${AppFields.instance.imagePrefix}${(postModel.postImage ?? [])[itemIndex].image??""}',
                fit: BoxFit.fitWidth,
                fadeOutDuration: const Duration(seconds: 1),
                fadeInDuration: const Duration(seconds: 1),
                errorWidget: (_, __, ___) {
                  if ((((postModel.postImage ?? [])[itemIndex]).image??"")
                      .contains('assets/image/')) {
                    return Image.asset(
                      (postModel.postImage ?? [])[itemIndex].image??"",
                      fit: BoxFit.fitWidth,
                    );
                  }
                  return Container();
                },
                placeholder: (context, url) {
                  return const SizedBox(
                    height: 185,
                    width: 150,
                    child: Center(
                        child: SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 2,
                            ))),
                  );
                },
              ),
            );
          },
        ),
        if((postModel.postImage ?? []).length>1)
        Obx(
          () => Padding(
            padding: const EdgeInsets.only(top: AppValues.height_8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicator(),
            ),
          ),
        ),
      ],
    ):Container();
  }

  /// build page indicator for paged view.
  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < (postModel.postImage ?? []).length; i++) {
      list.add(i == dotIndex.value
          ? SliderIndicatorWidget(
              isActive: true,
            )
          : SliderIndicatorWidget(isActive: false));
    }
    return list;
  }

  Widget buildPostImage() {
    return EventImageWidget(
      height: AppValues.eventPostImageHeight,
      isAssetUrl: false,
      width: double.infinity,
      profileURL: postModel.viewType == PostViewType.event
          ? postModel.eventImage ?? ""
          : postModel.resultImage ?? "",
    );
  }

  /// Build text content.
  Widget buildText() => Text(
    postModel.postDescription ?? "",
    textAlign: TextAlign.start,
    maxLines: 3,
    overflow: TextOverflow.ellipsis,
    style: textTheme.headlineSmall
        ?.copyWith(color: AppColors.textColorWhiteDescription.withOpacity(0.8),fontSize: 13),
  );
}
