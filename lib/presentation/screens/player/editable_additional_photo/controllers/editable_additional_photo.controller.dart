import 'package:game_on_flutter/infrastructure/storage/preference_manager.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_loading_mixin.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../../infrastructure/navigation/route_config.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../values/app_constant.dart';
import '../../../../../values/app_string.dart';
import '../../../../../values/common_utils.dart';
import '../../../../app_widgets/image_capture_helper.dart';
import '../../../club/signup/register_club_details/controllers/register_club_details.controller.dart';
import '../../register_player_detail/controllers/register_player_detail.controller.dart';

class EditableAdditionalPhotoController extends GetxController
    with AppLoadingMixin {
  /// Store images.
  RxList<ClubProfileImage> images = RxList();

  RxBool enableAddIcon = RxBool(true);

  @override
  void onInit() {
    _getArguments();
    super.onInit();
  }

  /// get arguments.
  void _getArguments() {
    if (Get.arguments != null) {
      images = Get.arguments[RouteArguments.images] ?? [];
      _checkForMaxImageAllowed();
    }
  }

  /// Function to handle back pressed.
  void onBackPressed() async {
    Get.back();
  }

  /// Remove captured image from the list.
  void removeImageFromPosition(int index) {
    removeImageFromDetail(index);
    _checkForMaxImageAllowed();
  }

  /// Disable add image button if image max limit reached.
  void _checkForMaxImageAllowed() {
    enableAddIcon.value = getRemainingImageToFillCount() > 0;
  }

  /// return remaining images length count.
  int getRemainingImageToFillCount() {
    // MULTI_IMAGE_MAX_SIZE
    final imageLength = images.length;
    return AppConstants.MULTI_IMAGE_MAX_SIZE - imageLength;
  }

  /// on image click to preview image.
  void onImageClick(ClubProfileImage url, String heroTag, int index) {
    /* Get.toNamed(Routes.IMAGE_PREVIEW, arguments: {
      RouteArguments.imageURL: url,
      RouteArguments.imageList: images,
      RouteArguments.heroTag: heroTag,
      RouteArguments.index: index,
    });*/
  }

  /// capture images.
  void captureClubImage() async {
    final remainingImageToFill = getRemainingImageToFillCount();
    if (remainingImageToFill == 0) {
      CommonUtils.showInfoSnackBar(message: AppString.imageMaxLengthExceed);
      return;
    }

    final capturedImage = await ImageCaptureHelper().getMultipleImage();

    if (capturedImage.isEmpty) {
      return;
    }

    /// Check if user selected images are less or same to remaining size.
    if (remainingImageToFill >= capturedImage.length) {
      showGlobalLoading();
      if (capturedImage.isNotEmpty) {
        List<ClubProfileImage> clubProfileList = [];
        for (var element in capturedImage) {
          clubProfileList.add(ClubProfileImage(element, -1,false));
        }
        addImageToList(clubProfileList);
      }
      hideGlobalLoading();
      _checkForMaxImageAllowed();
    } else {
      CommonUtils.showInfoSnackBar(message: AppString.imageMaxLengthExceed);
      showGlobalLoading();

      /// split selected image list to new list.
      final splitCaptureImages = capturedImage.sublist(0, remainingImageToFill);

      if (splitCaptureImages.isNotEmpty) {
        List<ClubProfileImage> clubProfileList = [];
        for (var element in splitCaptureImages) {
          clubProfileList.add(ClubProfileImage(element,-1, false));
        }
        addImageToList(clubProfileList);
      }
      hideGlobalLoading();
      _checkForMaxImageAllowed();
    }

    _checkForMaxImageAllowed();
  }

  /// Remove image from detail
  void removeImageFromDetail(int index) {
    if (GetIt.I<PreferenceManager>().isClub) {
      final RegisterClubDetailsController controller =
          Get.find(tag: Routes.REGISTER_CLUB_DETAILS);
      controller.removeImageFromPosition(index);
    } else {
      final RegisterPlayerDetailController playerDetailcontroller0 =
          Get.find(tag: Routes.REGISTER_PLAYER_DETAIL);
      playerDetailcontroller0.removeImageFromPosition(index);
    }
  }

  /// Remove image from detail
  void addImageToList(List<ClubProfileImage> images) {
    if (GetIt.I<PreferenceManager>().isClub) {
      final RegisterClubDetailsController controller =
          Get.find(tag: Routes.REGISTER_CLUB_DETAILS);
      controller.addImageList(images);
    } else {
      final RegisterPlayerDetailController playerDetailcontroller0 =
          Get.find(tag: Routes.REGISTER_PLAYER_DETAIL);
      playerDetailcontroller0.addImageList(images);
    }
  }
}
