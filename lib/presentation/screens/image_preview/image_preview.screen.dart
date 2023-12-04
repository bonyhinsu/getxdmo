import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_on_flutter/infrastructure/model/common/app_fields.dart';
import 'package:game_on_flutter/infrastructure/navigation/routes.dart';
import 'package:game_on_flutter/presentation/app_widgets/base_view.dart';
import 'package:game_on_flutter/values/app_colors.dart';
import 'package:get/get.dart';

import '../../../values/app_images.dart';
import '../../../values/app_values.dart';
import 'controllers/image_preview.controller.dart';

class ImagePreviewScreen extends GetView<ImagePreviewController>
    with AppBarMixin {
  ImagePreviewScreen({Key? key}) : super(key: key);

  final ImagePreviewController _controller =
      Get.find(tag: Routes.IMAGE_PREVIEW);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Stack(
          fit: StackFit.expand,
          children: [
            _controller.urlToPreview.isNotEmpty
                ? buildSingleImageView(_controller.urlToPreview)
                : Align(
                    alignment: Alignment.center,
                    child: buildImageView(_controller.urlToPreview),
                  ),
          ],
        ),
        Container(
            margin: EdgeInsets.only( top: 30),
            child: buildBackButton(backgroundColor: AppColors.appTileBackground))
      ],
    ));
  }

  /// Build image preview widget.
  Widget buildImageView(String imageURL) => ExpandablePageView.builder(
        itemCount: (_controller.images ?? []).length,
        controller: _controller.pagerController,
        itemBuilder: (BuildContext context, int itemIndex) {
          return buildSingleImageView(
              '${AppFields.instance.imagePrefix}${(_controller.images ?? [])[itemIndex].image}');
        },
      );

  /// player blank icon.
  SvgPicture get blankClubIcon => SvgPicture.asset(
        AppImages.planBackground,
      );

  /// Build single imageview to store.
  ///
  /// required[url]
  Widget buildSingleImageView(String url) => ClipRRect(
        borderRadius: BorderRadius.circular(AppValues.smallRadius),
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.fitWidth,
          fadeOutDuration: const Duration(seconds: 1),
          fadeInDuration: const Duration(seconds: 1),
          errorWidget: (_, __, ___) {
            if ((url).contains("assets/")) {
              return Image.asset(
                url,
                fit: BoxFit.fitWidth,
              );
            }
            return Container();
          },
          placeholder: (context, url) {
            return const SizedBox(
              height: AppValues.height_150,
              width: AppValues.height_150,
              child: Center(
                child: SizedBox(
                  height: AppValues.iconDefaultSize,
                  width: AppValues.iconDefaultSize,
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 2,
                  ),
                ),
              ),
            );
          },
        ),
      );
}
