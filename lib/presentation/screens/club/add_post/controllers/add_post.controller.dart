import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:game_on_flutter/infrastructure/storage/preference_manager.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_loading_mixin.dart';
import 'package:game_on_flutter/presentation/screens/club/club_profile/manage_post/controllers/manage_post.controller.dart';
import 'package:game_on_flutter/values/app_colors.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:logger/logger.dart';

import '../../../../../infrastructure/model/club/post/post_list_model.dart';
import '../../../../../infrastructure/model/club/post/post_model.dart';
import '../../../../../infrastructure/navigation/route_config.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../infrastructure/network/api_utils.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../values/app_constant.dart';
import '../../../../../values/app_string.dart';
import '../../../../../values/common_utils.dart';
import '../../../../app_widgets/app_dialog_widget.dart';
import '../../../../app_widgets/image_capture_helper.dart';
import '../providers/add_post_provider.dart';

class AddPostController extends GetxController with AppLoadingMixin {
  TextEditingController postController = TextEditingController();

  FocusNode postFocusNode = FocusNode();

  RxBool enableAddIcon = RxBool(true);

  // Rx<String> postImageUrl = "".obs;

  /// Initialise image capture helper
  final _imageHelper = ImageCaptureHelper();

  /// bool to check field are valid or not.
  ///
  /// if true then enable button.
  RxBool isValidField = RxBool(false);

  /// add post provides
  final _provider = AddPostProvider();

  /// post text value.
  String _postText = "";
  String _clubProfile = "";
  String _clubName = "";

  /// post model.
  Rx<PostModel?> postModel = PostModel.forLoading(isLoading: false).obs;

  final logger = Logger();

  /// index of post which is edit from previous screen.
  int postIndex = -1;

  RxList<PostImages> postImageUrl = RxList();

  final pagerController = PageController(
    initialPage: 0,
  );

  @override
  void onInit() {
    _getArgumentsForEdit();
    super.onInit();
  }

  @override
  void onClose() {
    pagerController.dispose();
    super.onClose();
  }

  /// Receive arguments from previous screen.
  void _getArgumentsForEdit() {
    if (Get.arguments != null) {
      postModel.value = Get.arguments[RouteArguments.postDetail];
      postIndex = Get.arguments[RouteArguments.listItemIndex] ?? -1;
      _setDetailToFields();
    }

    setClubProfile(GetIt.I<PreferenceManager>().userProfilePicture);
    setClubName(GetIt.I<PreferenceManager>().userName);
    postFocusNode.requestFocus();
  }

  String get postText => _postText;

  /// Build club profile
  String get clubProfile => _clubProfile;

  /// Get club Name
  String get clubName => _clubName;

  /// Set data to local fields.
  void _setDetailToFields() {
    postController.text = postModel.value?.postDescription ?? "";
    postImageUrl.value = postModel.value?.postImage ?? [];

    setText(postModel.value?.postDescription ?? "");
  }

  /// Set club profile
  void setClubProfile(String value) {
    _clubProfile = value;
  }

  /// Set club name
  void setClubName(String value) {
    _clubName = value;
  }

  /// Set Post Text
  void setText(String value) {
    _postText = value;
    validate();
  }

  /// Clear fields
  void _clearFields() {
    postController.clear();
  }

  /// Validate fields.
  void validate() {
    isValidField.value = _postText.trim().isNotEmpty;
  }

  /// Capture image from internal storage.
  void captureImageFromInternal() async {
    // Unfocused current object.
    FocusManager.instance.primaryFocus?.unfocus();

    // Get remaining image to fill count.
    final remainingImageToFill = getRemainingImageToFillCount();
    if (remainingImageToFill == 0) {
      CommonUtils.showInfoSnackBar(message: AppString.imageMaxLengthExceed);
      return;
    }

    // Capture multiple image.
    final capturedImage = await _imageHelper.getMultipleImage();
    List<String> remainingImages = [];

    /// Check if user selected images are less or same to remaining size.
    if (remainingImageToFill >= capturedImage.length) {
      showGlobalLoading();
      if (capturedImage.isNotEmpty) {
        for (var element in capturedImage) {
          remainingImages.add(element);
        }
      }
      hideGlobalLoading();
      _checkForMaxImageAllowed();
    } else {
      CommonUtils.showInfoSnackBar(message: AppString.imageMaxLengthExceed);
      showGlobalLoading();

      /// split selected image list to new list.
      final splitCaptureImages = capturedImage.sublist(0, remainingImageToFill);
      if (splitCaptureImages.isNotEmpty) {
        for (var element in splitCaptureImages) {
          remainingImages.add(element);
        }
      }
      hideGlobalLoading();
      _checkForMaxImageAllowed();
    }

    _checkForMaxImageAllowed();

    if (remainingImages.isNotEmpty) {
      for (var element in remainingImages) {
        final croppedFile = await showPreview(File(element));
        postImageUrl
            .add(PostImages(image: File(croppedFile ?? "").path, isUrl: false));
      }
    }
  }

  /// animate view pager
  void animateViewPagerToNewlyAddedFile() {
    pagerController.nextPage(
      duration: const Duration(milliseconds: 600),
      curve: Curves.fastOutSlowIn,
    );
  }

  ///Remove user profile
  void removeProfile(int index) {
    // remove user profile which is picked by the user.
    if (postImageUrl.isNotEmpty) {
      if (postImageUrl[index].isUrl) {
        deletePostImageAPI(postImageUrl[index].id ?? -1, index);
      } else {
        postImageUrl.removeAt(index);
      }
    }

    _checkForMaxImageAllowed();
  }

  /// Update club detail API.
  void addPostAPI() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showGlobalLoading();
      dio.Response? response = await _provider.addClubPost(
          otherDetails: _postText, postImages: postImageUrl.value);
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.created) {
          /// On success
          _addPostAPISuccess(response);
        } else {
          /// On Error
          _addPostAPIError(response);
        }
      } else {
        hideGlobalLoading();
        GetIt.I<CommonUtils>().showServerDownError();
      }
    } else {
      hideGlobalLoading();
      GetIt.I<CommonUtils>().showNetworkError();
    }
  }

  /// Update club detail API.
  void updatePostAPI() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showGlobalLoading();
      dio.Response? response = await _provider.updateClubPost(
          otherDetails: _postText,
          postImages: postImageUrl.value,
          id: (postModel.value?.index ?? 0).toString());
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _updatePostAPISuccess(response);
        } else {
          /// On Error
          _addPostAPIError(response);
        }
      } else {
        hideGlobalLoading();
        GetIt.I<CommonUtils>().showServerDownError();
      }
    } else {
      hideGlobalLoading();
      GetIt.I<CommonUtils>().showNetworkError();
    }
  }

  /// Remove club profile confirmation.
  void removeProfileConfirmationDialog() {
    Get.dialog(AppDialogWidget(
      onDone: onRemoveApprove,
      dialogText: AppString.removeClubProfileConfirmation,
    ));
  }

  /// Remove club logo profile
  void onRemoveApprove() {
    // pickedFile.value = File("");
  }

  /// Perform add post api success
  void _addPostAPISuccess(dio.Response response) {
    hideGlobalLoading();

    CommonUtils.showSuccessSnackBar(message: AppString.addPostSuccessMessage);
    addPostToList();
  }

  /// Perform update post api success
  void _updatePostAPISuccess(dio.Response response) {
    hideGlobalLoading();
    isValidField.value = false;
    CommonUtils.showSuccessSnackBar(
        message: AppString.updatePostSuccessMessage);

    addPostToList();
  }

  /// Perform api error.
  void _addPostAPIError(dio.Response response) {
    hideGlobalLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }

  /// on post click
  void submit() {
    if (postModel.value?.postDescription != null) {
      updatePostAPI();
    } else {
      addPostAPI();
    }
  }

  /// Add post to activity listing.
  void addPostToList() {
    _clearFields();
    Future.delayed(const Duration(seconds: 2), () {
      if (postModel.value?.postDescription != null) {
        _setDataToPostModel();
        ManagePostController managePostController =
            Get.find(tag: Routes.MANAGE_POST);
        managePostController.updateItemToList(postIndex, postModel.value!);
        Get.until((route) => route.settings.name == Routes.MANAGE_POST);
      } else {
        Get.until((route) => route.settings.name == Routes.CLUB_MAIN);
      }
    });
  }

  /// Set user updated data to post model.
  void _setDataToPostModel() {
    postModel.value?.postDescription = postText;
  }

  /// Return true if any of field has value.
  bool checkForNonEmptyField() =>
      postModel.value != null ? false : postText.isNotEmpty;

  /// Shows confirmation dialog
  Future<bool> showConfirmationDialog() {
    return Future.value(Get.dialog(AppDialogWidget(
      onDone: () {
        Get.back(result: true);
      },
      dialogText: AppString.discardPostMessage,
    )).then((value) {
      return false;
    }));
  }

  /// Check if user enters any value or not before back.
  ///
  /// if user enters any field then system ask for confirmation dialog.
  ///
  /// otherwise to back.
  Future<bool> willPopCallback() async {
    final value = checkForNonEmptyField();

    if (value) {
      return showConfirmationDialog();
    } else {
      return Future.value(true);
    }
  }

  /// Function to handle back pressed.
  void onBackPressed() async {
    await willPopCallback().then((value) {
      if (value) {
        Get.back();
      }
    });
  }

  /// return remaining images length count.
  int getRemainingImageToFillCount() {
    // MULTI_IMAGE_MAX_SIZE
    final imageLength = postImageUrl.length;
    return AppConstants.MULTI_IMAGE_MAX_SIZE - imageLength;
  }

  /// Disable add image button if image max limit reached.
  void _checkForMaxImageAllowed() {
    enableAddIcon.value = getRemainingImageToFillCount() > 0;
  }

  ///[OPEN] Image preview and crop
  Future<String?> showPreview(File newFile) async {
    final imageCropper = ImageCropper();

    CroppedFile? croppedFile = await imageCropper.cropImage(
      sourcePath: newFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      cropStyle: CropStyle.rectangle,
      maxHeight: 200,
      maxWidth: 250,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: AppColors.appWhiteButtonTextColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
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

  /// delete post image api
  void deletePostImageAPI(int imageId, int deletedAt) async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showGlobalLoading();
      dio.Response? response =
          await _provider.deletePostImageAPI(postId: imageId.toString());
      if (response.statusCode == NetworkConstants.deleteSuccess) {
        /// On success
        _deletePostImageSuccess(response, deletedAt);
      } else {
        /// On Error
        _deletePostImageAPIError(response);
      }
    } else {
      hideGlobalLoading();
      GetIt.I<CommonUtils>().showNetworkError();
    }
  }

  /// Perform api error.
  void _deletePostImageAPIError(dio.Response response) {
    hideGlobalLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }

  /// Perform login api success
  void _deletePostImageSuccess(dio.Response response, int index) {
    hideGlobalLoading();
    removePostAtIndex(index);
  }

  /// remove post at index.
  void removePostAtIndex(int index) {
    postImageUrl.removeAt(index);
    postImageUrl.refresh();
  }
}
