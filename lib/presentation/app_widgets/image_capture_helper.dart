import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_dialog_with_title_widget.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../values/app_colors.dart';
import '../custom_widgets/upload_profile_options_bottomsheet.dart';

class ImageCaptureHelper {
  bool isProfileAvailable = false;
  bool isProfilePicked = false;

  final logger = Logger();

  Future<String> getImage({required Function onRemoveImage}) async {
    String filePath = "";

    /// Open bottomsheet menu for selecting change image or remove image options.
    /// Wait for the result from the bottomSheet
    ///
    /// 1. Get the image from gallery.
    /// 2. Capture image from camera.
    /// 3. Remove selected image.
    final result = await Get.bottomSheet(
      UploadProfileOptionsBottomSheet(
        isProfileAvailable: isProfileAvailable,
        isProfileSelected: isProfilePicked,
      ),
      barrierColor: AppColors.bottomSheetBgBlurColor,
    );
    if (result is int) {
      switch (result) {
        case 1:

          /// case 1. Get the image from gallery.
          filePath = await _imgFromGallery();
          break;
        case 2:

          /// case 2. Capture image from camera.
          filePath = await _imgCaptureFromCamera();
          break;
        case 3:

          ///case 3. Remove selected image.
          onRemoveImage();
          filePath = "";
          break;
      }
    }
    return filePath;
  }

  /// Method for Capture and load image from gallery.
  Future<String> _imgFromGallery() async {
    if (GetPlatform.isIOS) {
      /// Check for photo permission in IOS.
      final status = await Permission.photos.request();
      if (status.isGranted || status.isLimited) {
        /// Open image picker when permission is granted.
        return _pickFileFromGallery();
      } else if (status.isDenied || status.isPermanentlyDenied) {
        /// Show Enable permission dialogue if user has permanently denied permission.
        _showPermissionDialog();
        return "";
      } else {
        return "";
      }
    } else {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;
      Permission permissionStatus;
      if ((sdkInt ?? 32) < 33) {
        permissionStatus = Permission.storage;
      } else {
        permissionStatus = Permission.photos;
      }

      /// Check for photo permission in Android.
      final status = await permissionStatus.request();
      if (status.isGranted || status.isLimited) {
        /// Open image picker when permission is granted.
        return _pickFileFromGallery();
      } else if (status.isDenied || status.isPermanentlyDenied) {
        /// Show Enable permission dialogue if user has permanently denied permission.
        _showPermissionDialog();
        return "";
      } else {
        return "";
      }
    }
  }

  Future<List<String>> getMultipleImage() async {
    List<String> filePath = [];

    /// Open bottomsheet menu for selecting change image or remove image options.
    /// Wait for the result from the bottomSheet
    ///
    /// 1. Get the image from gallery.
    /// 2. Capture image from camera.
    /// 3. Remove selected image.
    final result = await Get.bottomSheet(
      UploadProfileOptionsBottomSheet(
        isProfileAvailable: isProfileAvailable,
        isProfileSelected: isProfilePicked,
      ),
      barrierColor: AppColors.bottomSheetBgBlurColor,
    );
    if (result is int) {
      switch (result) {
        case 1:

          /// case 1. Get the image from gallery.
          filePath = await _imgMultipleFromGallery();
          break;
        case 2:

          /// case 2. Capture image from camera.
          String _filePath = await _imgCaptureFromCamera();
          filePath = _filePath.isNotEmpty ? [_filePath] : [];
          break;
      }
    }
    return filePath;
  }

  /// Method for Capture and load image from gallery.
  Future<List<String>> _imgMultipleFromGallery() async {
    if (GetPlatform.isIOS) {
      /// Check for photo permission in IOS.
      final status = await Permission.photos.request();
      if (status.isGranted || status.isLimited) {
        /// Open image picker when permission is granted.
        return _pickMultipleFileFromGallery();
      } else if (status.isDenied || status.isPermanentlyDenied) {
        /// Show Enable permission dialogue if user has permanently denied permission.
        _showPermissionDialog();
        return [];
      } else {
        return [];
      }
    } else {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;
      Permission permissionStatus;
      if ((sdkInt ?? 32) < 33) {
        permissionStatus = Permission.storage;
      } else {
        permissionStatus = Permission.photos;
      }

      /// Check for photo permission in Android.
      final status = await permissionStatus.request();
      if (status.isGranted || status.isLimited) {
        /// Open image picker when permission is granted.
        return _pickMultipleFileFromGallery();
      } else if (status.isDenied || status.isPermanentlyDenied) {
        /// Show Enable permission dialogue if user has permanently denied permission.
        _showPermissionDialog();
        return [""];
      } else {
        return [""];
      }
    }
  }

  /// Open image picker when permission is granted.
  Future<List<String>> _pickMultipleFileFromGallery() async {
    final ImagePicker picker = ImagePicker();
    try {
      List<XFile?> images = await picker.pickMultiImage(imageQuality: 50);
      if (images.isNotEmpty) {
        List<String> imagePathList = [];
        for (var element in images) {
          if ((element?.path ?? "").isNotEmpty) {
            imagePathList.add((element?.path ?? ""));
          }
        }
        return imagePathList;
      } else {
        return [];
      }
    } on Exception catch (ex, stacktrace) {
      logger.e(ex, stacktrace);
      return [];
    }
  }

  /// Method for Capture and load image from camera.
  Future<String> _imgCaptureFromCamera() async {
    if (GetPlatform.isIOS) {
      /// Check for photo permission in IOS.
      final status = await Permission.camera.request();
      if (status.isGranted || status.isLimited) {
        /// Open image picker when permission is granted.
        return _captureFileFromCamera();
      } else if (status.isDenied || status.isPermanentlyDenied) {
        /// Show Enable permission dialogue if user has permanently denied permission.
        _showiOSCameraPermissionDialog();
        return "";
      } else {
        return "";
      }
    } else {
      /// Check for photo permission in Android.
      final status = await Permission.camera.request();
      if (status.isGranted || status.isLimited) {
        /// Open image picker when permission is granted.
        return _captureFileFromCamera();
      } else if (status.isDenied || status.isPermanentlyDenied) {
        /// Show Enable permission dialogue if user has permanently denied permission.
        _showAndroidPermissionDialog();
        return "";
      } else {
        return "";
      }
    }
  }

  /// Open image picker when permission is granted.
  Future<String> _pickFileFromGallery() async {
    final ImagePicker picker = ImagePicker();
    try {
      XFile? image =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
      if (image != null) {
        return image.path;
      } else {
        return "";
      }
    } on Exception catch (ex, stacktrace) {
      logger.e(ex, stacktrace);
      return "";
    }
  }

  /// Open image picker when permission is granted.
  Future<String> _captureFileFromCamera() async {
    final ImagePicker picker = ImagePicker();
    try {
      XFile? image = await picker.pickImage(
          preferredCameraDevice: CameraDevice.front,
          source: ImageSource.camera,
          imageQuality: 50);
      if (image != null) {
        return image.path;
      } else {
        return "";
      }
    } on Exception catch (ex, stacktrace) {
      logger.e(ex, stacktrace);
      return "";
    }
  }

  void _showiOSCameraPermissionDialog() {
    Get.dialog(AppDialogWithTitleWidget(
      dialogText: AppString.enableCameraPermissionFromPhoneSetting,
      dialogTitle: AppString.cameraPermission,
      onDone: onDone,
      doneButtonText: AppString.settings,
    ));
    // /// Show Enable permission dialogue if user has permanently denied permission.
    // showDialog(
    //     context: Get.context!,
    //     builder: (context) => CupertinoAlertDialog(
    //           title: const Text(AppString.cameraPermission),
    //           content:
    //               const Text(AppString.enableCameraPermissionFromPhoneSetting),
    //           actions: <Widget>[
    //             CupertinoDialogAction(
    //               child: const Text(AppString.cancel),
    //               onPressed: () {
    //                 Get.back();
    //               },
    //             ),
    //             CupertinoDialogAction(
    //               isDefaultAction: true,
    //               child: const Text(AppString.openSettings),
    //               onPressed: () async {
    //                 await openAppSettings();
    //                 Get.back();
    //               },
    //             ),
    //           ],
    //         ));
  }

  void _showAndroidPermissionDialog() {
    Get.dialog(AppDialogWithTitleWidget(
      dialogText: AppString.enableCameraPermissionFromPhoneSetting,
      dialogTitle: AppString.cameraPermission,
      cancelButtonText: AppString.cancel,
      onDone: onDone,
      doneButtonText: AppString.settings,
    ));
    // /// Show Enable permission dialogue if user has permanently denied permission.
    // final themeData = Theme.of(Get.context!);
    // Get.defaultDialog(
    //   radius: 8.0,
    //   titlePadding: const EdgeInsets.only(top: 16.0),
    //   title: AppString.cameraPermission,
    //   backgroundColor: AppColors.bottomSheetBackground,
    //   titleStyle: themeData.textTheme.displayLarge,
    //   middleText: AppString.enableCameraPermissionFromPhoneSetting,
    //   middleTextStyle: themeData.textTheme.bodyMedium,
    //   actions: [
    //     Row(
    //       mainAxisSize: MainAxisSize.max,
    //       mainAxisAlignment: MainAxisAlignment.end,
    //       children: [
    //         TextButton(
    //             child: Text(
    //               AppString.cancel,
    //               style: themeData.textTheme.bodyMedium,
    //             ),
    //             onPressed: () => Get.back()),
    //         TextButton(
    //           child: Text(
    //             AppString.openSettings,
    //             style: themeData.textTheme.bodyMedium,
    //           ),
    //           onPressed: () async {
    //             await openAppSettings();
    //             Get.back();
    //           },
    //         ),
    //       ],
    //     ),
    //   ],
    // );
  }

  void _showPermissionDialog() {
    Get.dialog(AppDialogWithTitleWidget(
      dialogText: AppString.enablePhotoPermissionFromPhoneSettings,
      dialogTitle: AppString.photoPermission,
      onDone: onDone,
      doneButtonText: AppString.settings,
    ));

    // /// Show Enable permission dialogue if user has permanently denied permission.
    // final themeData = Theme.of(Get.context!);
    // Get.defaultDialog(
    //     radius: 8.0,
    //     titleStyle: themeData.textTheme.headline2!
    //         .copyWith(fontWeight: FontWeight.bold),
    //     titlePadding: const EdgeInsets.only(top: 8.0),
    //     title: AppString.photoPermission,
    //     middleText: AppString.enablePhotoPermissionFromPhoneSettings,
    //     middleTextStyle: themeData.textTheme.bodyText2,
    //     actions: [
    //       Row(
    //         mainAxisSize: MainAxisSize.max,
    //         mainAxisAlignment: MainAxisAlignment.end,
    //         children: [
    //           TextButton(
    //             child: const Text(AppString.cancel),
    //             onPressed: () => Get.back(),
    //           ),
    //           TextButton(
    //             child: const Text(AppString.openSettings),
    //             onPressed: () async {
    //               await openAppSettings();
    //               Get.back();
    //             },
    //           ),
    //         ],
    //       ),
    //     ]);
  }

  onDone() {
    openAppSettings();
    //               Get.back();
  }
}
