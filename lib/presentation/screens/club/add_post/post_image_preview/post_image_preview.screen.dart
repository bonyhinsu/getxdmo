import 'dart:io';

import 'package:flutter/material.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_button_mixin.dart';
import 'package:game_on_flutter/values/app_colors.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:game_on_flutter/values/app_values.dart';
import 'package:get/get.dart';

import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../app_widgets/base_view.dart';
import 'controllers/post_image_preview.controller.dart';

class PostImagePreviewScreen extends GetView<PostImagePreviewController>
    with AppBarMixin, AppButtonMixin {
  final PostImagePreviewController _controller =
      Get.find(tag: Routes.POST_IMAGE_PREVIEW);

  late BuildContext buildContext;

  PostImagePreviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return Obx(
      () => Scaffold(
        body: Stack(
          children: [
            buildAppBar(title: AppString.preview),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 420, child: buildImageView()),
              ],
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(AppValues.margin_20),
                  child: appRedButton(
                      title: AppString.strDone, onClick: _controller.onSubmit),
                ))
          ],
        ),
      ),
    );
  }

  /// Build image preview widget.
  Widget buildImageView() => PageView.builder(
        itemCount: _controller.selectedImages.length,
        controller: _controller.pagerController,
        itemBuilder: (BuildContext context, int itemIndex) {
          return buildSingleImageView(
              (_controller.selectedImages ?? [])[itemIndex], itemIndex);
        },
      );

  /// Build single imageview to store.
  ///
  /// required[url]
  Widget buildSingleImageView(File url, int index) {
    final width = MediaQuery.of(buildContext).size.width * 0.75;
    return Container(
      width: width,
      height: 250,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Stack(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              const Center(child: CircularProgressIndicator()),
              Center(
                child: Image(
                  image: FileImage(url),
                  fit: BoxFit.fitWidth,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      debugPrint('image loading null');
                      return child;
                    }
                    debugPrint('image loading...');
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.white,
                    ));
                  },
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () => _controller.onEditImage(index),
              child: Container(
                  height: 40,
                  width: 40,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: AppColors.bottomSheetBackground.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(AppValues.radius_2)),
                  child: const Icon(
                    Icons.edit,
                    color: AppColors.textColorPrimary,
                    size: 20,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
