import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_loading_mixin.dart';
import 'package:game_on_flutter/presentation/screens/club/add_event/providers/add_add_event_provider.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../../../../infrastructure/model/club/post/post_list_model.dart';
import '../../../../../infrastructure/model/club/post/post_model.dart';
import '../../../../../infrastructure/navigation/route_config.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../infrastructure/network/api_utils.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../values/app_colors.dart';
import '../../../../../values/app_constant.dart';
import '../../../../../values/common_utils.dart';
import '../../../../app_widgets/app_dialog_widget.dart';
import '../../../../app_widgets/form_validation_mixin.dart';
import '../../../../app_widgets/image_capture_helper.dart';
import '../../../../app_widgets/user_feature_mixin.dart';
import '../../club_profile/manage_post/controllers/manage_post.controller.dart';

class AddEventController extends GetxController
    with FormValidationMixin, UserFeatureMixin, AppLoadingMixin {
  /// Local Fields
  String _title = "";
  String _time = "";
  String _date = "";
  String _location = "";
  String _typeOfEvent = "";
  RxString _participantsA = "".obs;
  RxString _participantsB = "".obs;
  String _otherDetails = "";
  String _clubAddress = "";
  String _eventImage = "";

  /// Text Editing controller.
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController eventTypeController = TextEditingController();
  TextEditingController otherDetailsController = TextEditingController();
  late TextEditingController clubAddressController;

  /// Focus node
  FocusNode titleFocusNode = FocusNode();
  FocusNode timeFocusNode = FocusNode();
  FocusNode dateFocusNode = FocusNode();
  FocusNode locationFocusNode = FocusNode();
  FocusNode eventTypeFocusNode = FocusNode();
  FocusNode otherDetailsFocusNode = FocusNode();
  late FocusNode clubAddressFocusNode;

  /// Error Text Fields.
  RxString titleError = "".obs;
  RxString timeError = "".obs;
  RxString dateError = "".obs;
  RxString locationError = "".obs;

  /// capture file
  Rx<PostImages> eventBannerImage = PostImages().obs;

  /// Initialise image capture helper
  final _imageHelper = ImageCaptureHelper();

  /// Form key
  final formKey = GlobalKey<FormState>();

  /// Provider
  final _provider = AddAddEventProvider();

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
    clubAddressController = TextEditingController(text: "");
    clubAddressFocusNode = FocusNode();
    clubAddressFocusNode.addListener(() {
      if (clubAddressFocusNode.hasFocus) {
        enableGooglePlaces();
      }
    });
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
        postModel?.eventDate ?? "");
    String time = CommonUtils.convertToHHMM2(postModel?.eventTime ?? "");

    titleController.text = postModel?.title ?? "";
    timeController.text = time;
    locationController.text = postModel?.location ?? "";
    eventTypeController.text = postModel?.eventType ?? "";
    otherDetailsController.text = postModel?.postDescription ?? "";
    dateController.text = date;

    setTitle(postModel?.title ?? "");
    setTime(time);
    setDate(date);
    setLocation(postModel?.location ?? "");
    setTypeOfEvent(postModel?.eventType ?? "");
    setOtherDetails(postModel?.postDescription ?? "");

    if ((postModel?.eventImage ?? "").isNotEmpty) {
      eventBannerImage.value = PostImages(
        image: (postModel?.eventImage ?? ""),
        isUrl: true,
      );
    }

    eventBannerImage.refresh();
  }

  /// Set user updated data to post model.
  void _setDataToPostModel() {
    postModel?.clubName = title;
    postModel?.time = CommonUtils.convertDateAndTimeToTimestamp(date, time);
    postModel?.location = _location;
    postModel?.eventType = typeOfEvent;
    postModel?.otherDetails = otherDetails;
  }

  /// on Submit called.
  void onSubmit() {
    if (formKey.currentState!.validate()) {
      if ((postModel?.index ?? -1) == -1) {
        addEventAPI();
      } else {
        updateEventAPI();
      }
    }
  }

  /// Clear all fields.
  void _clearFieldErrors() {
    titleError.value = "";
    dateError.value = "";
    timeError.value = "";
    locationError.value = "";
  }

  /// Clear fields.
  void _clearFields() {
    _clearFieldErrors();
    titleController.clear();
    dateController.clear();
    timeController.clear();
    locationController.clear();
    eventTypeController.clear();
    otherDetailsController.clear();
    eventBannerImage.value = PostImages();
  }

  /// set [_title] value
  void setTitle(String value) {
    _title = value;
    checkValidation();
  }

  /// set [_time] value
  void setTime(String value) {
    _time = value;
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

  /// set [_typeOfEvent] value
  void setTypeOfEvent(String value) {
    _typeOfEvent = value;
  }

  /// set [_participantsA] value
  void setParticipantsA(String value) {
    _participantsA.value = value;
  }

  /// set [_participantsB] value
  void setParticipantsB(String value) {
    _participantsB.value = value;
  }

  /// set [_otherDetails] value
  void setOtherDetails(String value) {
    _otherDetails = value;
  }

  /// set [_eventImage] value
  void setEventImage(String value) {
    _eventImage = value;
  }

  /// return [_title] text
  String get title => _title;

  /// return [_time] text
  String get time => _time;

  /// return [_date] text
  String get date => _date;

  /// return [_location] text
  String get location => _location;

  /// return [_typeOfEvent] text
  String get typeOfEvent => _typeOfEvent;

  /// return [_participantsA] text
  RxString get participantsA => _participantsA;

  /// return [_participantsB] text
  RxString get participantsB => _participantsB;

  /// return [_otherDetails] text
  String get otherDetails => _otherDetails;

  /// return [_eventImage] text
  String get eventImage => _eventImage;

  void checkValidation() {
    isValidField.value = title.isNotEmpty &&
        date.isNotEmpty &&
        time.isNotEmpty &&
        location.isNotEmpty;
  }

  /// add event API.
  void addEventAPI() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showGlobalLoading();

      String convertedDate = CommonUtils.yyyymmddDate(date);
      String convertedTime = CommonUtils.convertToHHMM(time);
      dio.Response? response = await _provider.addEvent(
          title: title,
          time: convertedTime,
          date: convertedDate,
          location: location,
          typeOfEvent: typeOfEvent,
          otherDetails: otherDetails,
          eventImage: eventBannerImage.value);
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.created) {
          /// On success
          _addEventSuccess(response);
        } else {
          /// On Error
          _addEventError(response);
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

  /// add event API.
  void updateEventAPI() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showGlobalLoading();

      String convertedDate = CommonUtils.yyyymmddDate(date);
      String convertedTime = CommonUtils.convertToHHMM(time);

      dio.Response? response = await _provider.updateEvent(
          title: title,
          time: convertedTime,
          date: convertedDate,
          location: location,
          typeOfEvent: typeOfEvent,
          otherDetails: otherDetails,
          eventImage: eventBannerImage.value,
          itemId: postItemId);
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _addEventSuccess(response);
        } else {
          /// On Error
          _addEventError(response);
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

  /// Perform event api success
  void _addEventSuccess(dio.Response response) {
    hideGlobalLoading();
    addEventToHome();
  }

  /// Perform api error.
  void _addEventError(dio.Response response) {
    hideGlobalLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }

  /// Add event to home and navigate back
  void addEventToHome() {
    _clearFields();

    if (postModel == null) {
      CommonUtils.showSuccessSnackBar(
          message: AppString.addEventSuccessMessage);
    } else {
      CommonUtils.showSuccessSnackBar(
          message: AppString.updatePostSuccessMessage);
    }

    Future.delayed(const Duration(seconds: 2), () {
      if (postModel != null) {
        _setDataToPostModel();
        ManagePostController managePostController =
            Get.find(tag: Routes.MANAGE_POST);
        managePostController.updateItemToList(postIndex, postModel!);
        Get.until((route) => route.settings.name == Routes.MANAGE_POST);
      } else {
        Get.until((route) => route.settings.name == Routes.CLUB_MAIN);
      }
    });
  }

  /// Open time picker
  void openTimePicker() async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: Get.context!,
    );
    if (pickedTime != null) {
      String formattedTime = CommonUtils.convertPickedTimeToHour(
          '${pickedTime.hour}:${pickedTime.minute}:00');
      timeController.text = formattedTime;
      setTime(formattedTime);

      timeFocusNode.unfocus();
      if (date.isEmpty) {
        dateFocusNode.requestFocus();
      }
    }
  }

  /// Open date picker.
  void openDatePicker() async {
    final currentDate = DateTime.now();
    final datetime = date.isEmpty
        ? DateTime.now()
        : DateTime.parse(CommonUtils.yyyymmddDate(date));
    final nextDate = postModel == null
        ? DateTime(currentDate.year + 2)
        : DateTime(currentDate.year + 20);
    final DateTime? picked = await showDatePicker(
        context: Get.context!,
        initialDate: datetime,
        firstDate:
            postModel == null ? currentDate : DateTime(currentDate.year - 20),
        lastDate: nextDate);
    if (picked != null && picked != datetime) {
      final newFormattedDate = CommonUtils.ddmmmyyyyDate(picked.toString());
      dateController.text = newFormattedDate;
      setDate(newFormattedDate);
      dateFocusNode.unfocus();

      if (location.isEmpty) {
        locationFocusNode.requestFocus();
      }
    }
  }

  /// Capture image from internal storage.
  void captureImageFromInternal() async {
    // Unfocused current object.
    FocusManager.instance.primaryFocus?.unfocus();
    _imageHelper.isProfilePicked =
        (eventBannerImage.value.image ?? "").isNotEmpty;

    /// If profile is available then remove profile.
    if (_imageHelper.isProfilePicked) {
      eventBannerImage.value = PostImages();
      return;
    }

    final capturedImage =
        await _imageHelper.getImage(onRemoveImage: removePicture);
    if (capturedImage.isNotEmpty) {
      _cropImage(File(capturedImage));
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
      eventBannerImage.value =
          PostImages(isUrl: false, image: croppedFile.path);
      eventBannerImage.refresh();
    }
  }

  ///Remove user profile
  void removePicture() {
    // remove user profile which is picked by the user.
    if ((eventBannerImage.value.image ?? "").isNotEmpty) {
      // if (eventBannerImage.value.isUrl) {
      //   deletePostImageAPI(eventBannerImage.value.id ?? -1);
      // } else {
        eventBannerImage.value = PostImages();
      // }
    }
  }

  /// Return true if any of field has value.
  bool checkForNonEmptyField() => postModel != null
      ? false
      : title.isNotEmpty ||
          time.isNotEmpty ||
          date.isNotEmpty ||
          location.isNotEmpty ||
          (eventBannerImage.value.image ?? "").isNotEmpty ||
          otherDetails.isNotEmpty;

  /// Shows confirmation dialog
  Future<bool> showConfirmationDialog() async {
    return Future.value(Get.dialog(AppDialogWidget(
      onDone: () {
        Get.back(result: true);
      },
      dialogText: AppString.discardEventMessage,
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
      FocusScope.of(Get.context!).requestFocus(FocusNode());
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

  /// Enable google places API.
  Future<void> enableGooglePlaces() async {
    clubAddressFocusNode.unfocus();
    Prediction? p = await PlacesAutocomplete.show(
      context: Get.context!,
      apiKey: AppConstants.kGoogleApiKey,
      mode: Mode.overlay,
      hint: AppString.searchAddress,
    );

    displayPrediction(p);
  }

  /// Display prediction
  Future<Null> displayPrediction(
    Prediction? p,
  ) async {
    if (p != null) {
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: AppConstants.kGoogleApiKey,
      );
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId ?? "");
      final lat = detail.result.geometry?.location.lat;
      final lng = detail.result.geometry?.location.lng;

      clubAddressController.text = p.description ?? "";
    }
  }

  /// Set club address.
  setClubAddress(String value) {
    _clubAddress = value;
    // _checkValidation();
  }

  /// delete post image api
  void deletePostImageAPI(int imageId) async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showGlobalLoading();
      dio.Response? response =
          await _provider.deletePostImageAPI(postId: imageId.toString());
      if (response.statusCode == NetworkConstants.deleteSuccess) {
        /// On success
        _deletePostImageSuccess(response);
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
  void _deletePostImageSuccess(dio.Response response) {
    hideGlobalLoading();
    eventBannerImage.value = PostImages();
  }
}
