import 'dart:io';

import 'package:flutter/material.dart';
import 'package:game_on_flutter/infrastructure/navigation/route_config.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../../../../../values/app_colors.dart';

class PostImagePreviewController extends GetxController {
  RxList<File> selectedImages = RxList();

  late PageController pagerController;

  @override
  void onInit() {
    _getMultipleImages();
    pagerController = PageController(initialPage: 0, viewportFraction: 0.8);
    super.onInit();
  }

  /// Get multiple images from previous screen
  void _getMultipleImages() {
    if (Get.arguments != null) {
      List<String> imageList = Get.arguments[RouteArguments.images] ?? [];
      for (var element in imageList) {
        final fileObj = File(element);
        selectedImages.add(fileObj);
      }
    }
  }

  /// on submit.
  void onSubmit() {
    final selectedImage =
        selectedImages.map((element) => element.path).toList();
    Get.back(result: selectedImage);
  }

  void onEditImage(int index) {
    showPreview(selectedImages[index]).then((value) {
      if ((value ?? "").isNotEmpty) {
        selectedImages[index] = File(value!);
        selectedImages.refresh();
      }
    });
  }

  ///[OPEN] Image preview and crop
  Future<String?> showPreview(File newFile) async {
    final imageCropper = ImageCropper();

    CroppedFile? croppedFile = await imageCropper.cropImage(
      sourcePath: newFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio5x4,
        CropAspectRatioPreset.ratio16x9,
        CropAspectRatioPreset.ratio7x5,
      ],
      cropStyle: CropStyle.rectangle,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: AppColors.appWhiteButtonTextColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        IOSUiSettings(
            minimumAspectRatio: 1.0,
            aspectRatioLockDimensionSwapEnabled: false,
            aspectRatioLockEnabled: true)
      ],
    );
    if (croppedFile != null) {
      return croppedFile.path;
    } else {
      return '';
    }
  }
}
