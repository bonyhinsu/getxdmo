import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:game_on_flutter/presentation/screens/club/add_result/providers/add_result_provider.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../../../../infrastructure/model/club/post/post_list_model.dart';
import '../../../../../infrastructure/model/club/post/post_model.dart';
import '../../../../../infrastructure/navigation/route_config.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../infrastructure/network/api_utils.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../values/app_colors.dart';
import '../../../../../values/app_string.dart';
import '../../../../../values/common_utils.dart';
import '../../../../app_widgets/app_dialog_widget.dart';
import '../../../../app_widgets/app_loading_mixin.dart';
import '../../../../app_widgets/form_validation_mixin.dart';
import '../../../../app_widgets/image_capture_helper.dart';
import '../../../../app_widgets/user_feature_mixin.dart';
import '../../club_profile/manage_post/controllers/manage_post.controller.dart';

class AddResultController extends GetxController
    with FormValidationMixin, UserFeatureMixin, AppLoadingMixin {
  /// Local Fields
  String _title = "";
  String _date = "";
  String _location = "";
  String _score = "";
  String _highlights = "";
  String _otherDetails = "";
  String _eventImage = "";
  RxString _teamA = "".obs;
  RxString _teamB = "".obs;

  /// Text Editing controller.
  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController scoreController = TextEditingController();
  TextEditingController highlightsController = TextEditingController();
  TextEditingController otherDetailsController = TextEditingController();
  TextEditingController teamAController = TextEditingController();
  TextEditingController teamBController = TextEditingController();

  /// Focus node
  FocusNode titleFocusNode = FocusNode();
  FocusNode dateFocusNode = FocusNode();
  FocusNode locationFocusNode = FocusNode();
  FocusNode scoreFocusNode = FocusNode();
  FocusNode highlightsFocusNode = FocusNode();
  FocusNode otherDetailsFocusNode = FocusNode();
  FocusNode teamAFocusNode = FocusNode();
  FocusNode teamBFocusNode = FocusNode();

  /// Error Text Fields.
  RxString titleError = "".obs;
  RxString dateError = "".obs;
  RxString locationError = "".obs;
  RxString teamAError = "".obs;
  RxString teamBError = "".obs;

  /// capture file
  Rx<PostImages> resultBannerImage = PostImages().obs;

  /// Initialise image capture helper
  final _imageHelper = ImageCaptureHelper();

  /// Form key
  final formKey = GlobalKey<FormState>();

  /// Provider
  final _provider = AddResultProvider();

  /// bool to check field are valid or not.
  ///
  /// if true then enable button.
  RxBool isValidField = RxBool(false);

  List<String> teamAParticipants = [];

  List<String> teamBParticipants = [];

  /// post model.
  PostModel? postModel;

  /// index of post which is edit from previous screen.
  int postIndex = -1;

  /// Post item id.
  String postItemId = '';

  @override
  void onInit() {
    listenForFieldFocus();
    _getArgumentsForEdit();
    super.onInit();
  }

  /// Receive arguments from previous screen.
  void _getArgumentsForEdit() {
    if (Get.arguments != null) {
      postModel = Get.arguments[RouteArguments.postDetail];
      postIndex = Get.arguments[RouteArguments.listItemIndex] ?? -1;
      postItemId = Get.arguments[RouteArguments.itemId] ?? '';
      _setDetailToFields();
    }
  }

  /// Set data to local fields.
  void _setDetailToFields() {
    String date = CommonUtils.convertToUserReadableDateWithTimeZone(
        postModel?.postDate ?? "",isUTC: true);

    titleController.text = postModel?.title ?? "";
    teamAController.text = postModel?.teamA ?? "";
    teamBController.text = postModel?.teamB ?? "";
    locationController.text = postModel?.location ?? "";
    otherDetailsController.text = postModel?.otherDetails ?? "";
    dateController.text = date;
    scoreController.text = postModel?.score ?? "";
    highlightsController.text = postModel?.highlight ?? "";

    setTitle(postModel?.title ?? "");
    setLocation(postModel?.location ?? "");
    setScore(postModel?.score ?? "");
    setTeamA(postModel?.teamA ?? "");
    setTeamB(postModel?.teamB ?? "");
    setHighlights(postModel?.highlight ?? "");
    setOtherDetails(postModel?.otherDetails ?? "");
    setDate(date);
    resultBannerImage.value =
        PostImages(image: postModel?.resultImage, isUrl: true);
  }

  /// on Submit called.
  void onSubmit() {
    if (formKey.currentState!.validate()) {
      if ((postModel?.index ?? -1) == -1) {
        addResultAPI();
      } else {
        updateResultAPI();
      }
    }
  }

  ///[OPEN] Image preview and crop
  void _cropImage(File newFile) async {
    final imageCropper = ImageCropper();

    CroppedFile? croppedFile = await imageCropper.cropImage(
      sourcePath: newFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 2, ratioY: 1),
      aspectRatioPresets: [
        CropAspectRatioPreset.ratio7x5,
      ],
      cropStyle: CropStyle.rectangle,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: AppColors.appWhiteButtonTextColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio7x5,
            lockAspectRatio: true),
        IOSUiSettings(
          minimumAspectRatio: 7.5,
          aspectRatioLockEnabled: true,
        )
      ],
    );
    if (croppedFile != null) {
      resultBannerImage.value =
          PostImages(image: croppedFile.path, isUrl: false);
      resultBannerImage.refresh();
    }
  }

  /// Clear all fields.
  void _clearFieldErrors() {
    titleError.value = "";
    dateError.value = "";
    teamBError.value = "";
    teamAError.value = "";
    dateError.value = "";
    locationError.value = "";
  }

  /// Clear fields.
  void _clearFields() {
    _clearFieldErrors();
    titleController.clear();
    dateController.clear();
    locationController.clear();
    scoreController.clear();
    highlightsController.clear();
    teamAController.clear();
    teamBController.clear();
  }

  void listenForFieldFocus() {
    // dateFocusNode.addListener(() {
    //   if (dateFocusNode.hasFocus) {
    //     dateFocusNode.unfocus();
    //     Future.delayed(const Duration(milliseconds: 400), () {
    //       openDatePicker();
    //     });
    //   }
    // });
  }

  /// set [_title] value
  void setTitle(String value) {
    _title = value;
    checkValidation();
  }

  /// set [_teamA] value
  void setTeamA(String value) {
    _teamA.value = value;
    checkValidation();
  }

  /// set [_teamB] value
  void setTeamB(String value) {
    _teamB.value = value;
    checkValidation();
  }

  /// set [_date] value
  void setDate(String value) {
    _date = value;
    checkValidation();
  }

  /// set [_location] value
  void setLocation(String value) {
    _location = value;
    checkValidation();
  }

  /// set [_score] value
  void setScore(String value) {
    _score = value;
  }

  /// set [_otherDetails] value
  void setOtherDetails(String value) {
    _otherDetails = value;
  }

  /// set [_highlights] value
  void setHighlights(String value) {
    _highlights = value;
  }

  /// set [_eventImage] value
  void setEventImage(String value) {
    _eventImage = value;
  }

  /// return [_title] text
  String get title => _title;

  /// return [_date] text
  String get date => _date;

  /// return [_location] text
  String get location => _location;

  /// return [_score] text
  String get score => _score;

  /// return [_teamA] text
  RxString get teamA => _teamA;

  /// return [_teamB] text
  RxString get teamB => _teamB;

  /// return [_highlights] text
  String get highLights => _highlights;

  /// return [_otherDetails] text
  String get otherDetails => _otherDetails;

  /// return [_eventImage] text
  String get eventImage => _eventImage;

  void checkValidation() {
    isValidField.value =
        title.isNotEmpty && date.isNotEmpty && location.isNotEmpty;
  }

  /// add result API.
  void addResultAPI() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showGlobalLoading();
      String convertedDate = CommonUtils.yyyymmddDate(date,isUTC: false);
      dio.Response? response = await _provider.addResult(
          title: title,
          date: convertedDate,
          location: location,
          score: score,
          participantsA: teamA.value,
          participantsB: teamB.value,
          highLights: highLights,
          otherDetails: otherDetails,
          eventImage: resultBannerImage.value);
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.created) {
          /// On success
          _addResultSuccess(response);
        } else {
          /// On Error
          _addResultError(response);
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

  /// Perform result api success
  void _addResultSuccess(dio.Response response) {
    hideGlobalLoading();
    addResultDataToField();
  }

  /// Perform api error.
  void _addResultError(dio.Response response) {
    hideGlobalLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }

  /// Add result to home and navigate back
  void addResultDataToField() {
    _clearFields();

    if (postModel == null) {
      CommonUtils.showSuccessSnackBar(
          message: AppString.addResultSuccessMessage);
    } else {
      CommonUtils.showSuccessSnackBar(
          message: AppString.updateResultSuccessMessage);
    }

    Future.delayed(const Duration(seconds: 2), () {
      if (postModel == null) {
        Get.until((route) => route.settings.name == Routes.CLUB_MAIN);
      } else {
        _setDataToPostModel();
        ManagePostController managePostController =
            Get.find(tag: Routes.MANAGE_POST);
        managePostController.updateItemToList(postIndex, postModel!);
        Get.until((route) => route.settings.name == Routes.MANAGE_POST);
      }
    });
  }

  /// Set user updated data to post model.
  void _setDataToPostModel() {
    postModel?.postDescription = otherDetails;
  }

  /// Open date picker.
  void openDatePicker() async {
    final currentDate = DateTime.now();
    final datetime = date.isEmpty
        ? DateTime.now()
        : DateTime.parse(CommonUtils.yyyymmddDate(date));
    final nextDate = DateTime(currentDate.year - 2);
    final DateTime? picked = await showDatePicker(
        context: Get.context!,
        initialDate: datetime,
        firstDate: nextDate,
        lastDate: DateTime.now());
    if (picked != null && picked != datetime) {
      final newFormattedDate = CommonUtils.ddmmmyyyyDate(picked.toString());
      dateController.text = newFormattedDate;
      setDate(newFormattedDate);
      dateFocusNode.unfocus();

      if (score.isEmpty) {
        scoreFocusNode.requestFocus();
      }
    }
  }

  /// Capture image from internal storage.
  void captureImageFromInternal() async {
    // Unfocused current object.
    FocusManager.instance.primaryFocus?.unfocus();

    final capturedImage =
        await _imageHelper.getImage(onRemoveImage: removePicture);
    if (capturedImage.isNotEmpty) {
      _cropImage(File(capturedImage));
    }
  }

  ///Remove user profile
  void removePicture() {
    // remove user profile which is picked by the user.
    if ((resultBannerImage.value.image ?? "").isNotEmpty) {
      resultBannerImage.value.convertToDelete();
      resultBannerImage.refresh();
    }
  }

  /// Return true if any of field has value.
  bool checkForNonEmptyField() => postModel != null
      ? false
      : title.isNotEmpty ||
          date.isNotEmpty ||
          location.isNotEmpty ||
          otherDetails.isNotEmpty;

  /// Shows confirmation dialog
  Future<bool> showConfirmationDialog() {
    return Future.value(Get.dialog(AppDialogWidget(
      onDone: () {
        Get.back(result: true);
      },
      dialogText: AppString.discardResultMessage,
    )).then((value) {
      return false;
    }));
  }

  /// add event API.
  void updateResultAPI() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showGlobalLoading();
      String convertedDate = CommonUtils.yyyymmddDate(date,isUTC: false);
      dio.Response? response = await _provider.updateResult(
          title: title,
          date: convertedDate,
          location: location,
          score: score,
          participantsA: teamA.value,
          participantsB: teamA.value,
          highLights: highLights,
          otherDetails: otherDetails,
          eventImage: resultBannerImage.value,
          itemId: postItemId);
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _addResultSuccess(response);
        } else {
          /// On Error
          _addResultError(response);
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
}
