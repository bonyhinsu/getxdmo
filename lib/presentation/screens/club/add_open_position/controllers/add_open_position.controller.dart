import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:game_on_flutter/infrastructure/model/club/signup/selection_model.dart';
import 'package:game_on_flutter/infrastructure/navigation/route_config.dart';
import 'package:game_on_flutter/presentation/screens/club/add_open_position/providers/add_open_position_provider.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../../infrastructure/model/club/post/post_model.dart';
import '../../../../../infrastructure/model/common/sportstype_response_model.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../infrastructure/network/api_utils.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../values/app_string.dart';
import '../../../../../values/common_utils.dart';
import '../../../../app_widgets/app_dialog_widget.dart';
import '../../../../app_widgets/app_loading_mixin.dart';
import '../../../../app_widgets/form_validation_mixin.dart';
import '../../../../app_widgets/user_feature_mixin.dart';
import '../../club_profile/manage_post/controllers/manage_post.controller.dart';

class AddOpenPositionController extends GetxController
    with FormValidationMixin, UserFeatureMixin, AppLoadingMixin {
  /// Local Fields
  String _positionName = "";
  String _age = "";
  RxString gender = "".obs;
  String _location = "";
  RxString _level = "".obs;
  String _details = "";
  String _reference = "";
  String _skills = "";

  /// Text Editing controller.
  TextEditingController positionController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController referenceController = TextEditingController();
  TextEditingController skillController = TextEditingController();

  /// Focus node
  FocusNode positionFocusNode = FocusNode();
  FocusNode ageFocusNode = FocusNode();
  FocusNode locationFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();
  FocusNode referenceFocusNode = FocusNode();
  FocusNode skillsFocusNode = FocusNode();

  /// Error Text Fields.
  RxString positionError = "".obs;
  RxString ageError = "".obs;
  RxString locationError = "".obs;

  /// Form key
  final formKey = GlobalKey<FormState>();

  /// Provider
  final _provider = AddOpenPositionProvider();

  /// bool to check field are valid or not.
  ///
  /// if true then enable button.
  RxBool isValidField = RxBool(false);

  /// Level list for dropdown.
  List<String> listLevel = [];

  /// Gender list
  List<String> genders = [AppString.male, AppString.female];

  /// post model.
  PostModel? postModel;

  /// index of post which is edit from previous screen.
  int postIndex = -1;

  /// Post item id.
  String postItemId = '';

  @override
  void onInit() {
    setGender(genders.first);
    _getArgumentsForEdit();
    super.onInit();
  }

  /// Add dummy data
  void addDummyData() {
    final playerLevel = DataProvider().getPlayerLevel();
    for (var element in playerLevel) {
      listLevel.add(element.title ?? "");
    }
    setLevel(listLevel.first);
  }

  /// Receive arguments from previous screen.
  void _getArgumentsForEdit() {
    if (Get.arguments != null) {
      postModel = Get.arguments[RouteArguments.postDetail];
      postIndex = Get.arguments[RouteArguments.listItemIndex] ?? -1;
      postItemId = Get.arguments[RouteArguments.itemId] ?? '';
      getLevelAPI();
    }
  }

  /// on Submit called.
  void onSubmit() {
    if (formKey.currentState!.validate()) {
      if (postModel != null) {
        updateOpenPositionAPI();
      } else {
        addOpenPositionAPI();
      }
    }
  }

  /// Set data to local fields.
  void _setDetailToFields() {
    positionController.text = postModel?.positionName ?? "";
    ageController.text = postModel?.age ?? "";
    locationController.text = postModel?.location ?? "";
    skillController.text = postModel?.skill ?? "";
    referenceController.text = postModel?.level ?? "";
    descriptionController.text = postModel?.postDescription ?? "";

    setPositionName(postModel?.positionName ?? "");
    setAge(postModel?.age ?? "");
    setLocation(postModel?.location ?? "");
    setDetails(postModel?.postDescription ?? "");
    setSkills(postModel?.skill ?? "");
    setLevel(postModel?.level ?? "");
    setReference(postModel?.references ?? "");

    gender.value = genders.firstWhere((element) =>
        element.toLowerCase() == (postModel?.gender ?? "male").toLowerCase());
  }

  /// Clear all fields.
  void _clearFieldErrors() {
    positionError.value = "";
    ageError.value = "";
    locationError.value = "";
  }

  /// Clear fields.
  void _clearFields() {
    _clearFieldErrors();
    positionController.clear();
    ageController.clear();
    locationController.clear();
    descriptionController.clear();
    referenceController.clear();
    skillController.clear();
  }

  /// set [_positionName] value
  void setPositionName(String value) {
    _positionName = value;
    checkValidation();
  }

  /// set [_location] value
  void setLocation(String value) {
    _location = value;
    checkValidation();
  }

  /// set [_details] value
  void setDetails(String value) {
    _details = value;
  }

  /// set [_age] value
  void setAge(String value) {
    _age = value;
    checkValidation();
  }

  /// set [_gender] value
  void setGender(String value) {
    gender.value = value;
  }

  /// set [_reference] value
  void setReference(String value) {
    _reference = value;
  }

  /// set [_level] value
  void setLevel(String value) {
    _level.value = value;
  }

  /// set [_skills] value
  void setSkills(String value) {
    _skills = value;
  }

  /// return [_positionName] text
  String get positionName => _positionName;

  /// return [_age] text
  String get age => _age;

  /// return [_level] text
  RxString get level => _level;

  /// return [_reference] text
  String get reference => _reference;

  /// return [_skills] text
  String get skills => _skills;

  /// return [_location] text
  String get location => _location;

  /// return [_details] text
  String get details => _details;

  /// Check validation field.
  void checkValidation() {
    isValidField.value =
        positionName.isNotEmpty && age.isNotEmpty && location.isNotEmpty;
  }

  /// add open position API.
  void addOpenPositionAPI() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showGlobalLoading();
      dio.Response? response = await _provider.addOpenPosition(
          positionName: positionName,
          age: age,
          gender: gender.value,
          location: location,
          level: level.value,
          description: details,
          reference: reference,
          skill: skills,
          eventImage: '');
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.created) {
          /// On success
          _addOpenPositionSuccess(response);
        } else {
          /// On Error
          _addOpenPositionError(response);
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

  /// update open position API.
  void updateOpenPositionAPI() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showGlobalLoading();
      dio.Response? response = await _provider.updateOpenPosition(
          positionName: positionName,
          age: age,
          gender: gender.value,
          location: location,
          level: level.value,
          description: details,
          reference: reference,
          skill: skills,
          itemId: postItemId,
          eventImage: '');
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _updateOpenPositionSuccess(response);
        } else {
          /// On Error
          _addOpenPositionError(response);
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

  /// Perform update open position api success
  void _updateOpenPositionSuccess(dio.Response response) {
    hideGlobalLoading();

    CommonUtils.showSuccessSnackBar(
        message: AppString.updatePositionSuccessMessage);

    Future.delayed(const Duration(seconds: 2), () {
      _setDataToPostModel();
      ManagePostController managePostController =
          Get.find(tag: Routes.MANAGE_POST);
      managePostController.updateItemToList(postIndex, postModel!);
      Get.until((route) => route.settings.name == Routes.MANAGE_POST);
    });
  }

  /// Perform add open position api success
  void _addOpenPositionSuccess(dio.Response response) {
    hideGlobalLoading();
    _clearFields();
    CommonUtils.showSuccessSnackBar(
        message: AppString.addPositionSuccessMessage);
    Future.delayed(const Duration(seconds: 2), () {
      Get.until((route) => route.settings.name == Routes.CLUB_MAIN);
    });
  }

  /// Perform api error.
  void _addOpenPositionError(dio.Response response) {
    hideGlobalLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }

  /// Add event to home and navigate back
  void addOpenPositionToClubActivity() {
    CommonUtils.showSuccessSnackBar(
        message: AppString.addPositionSuccessMessage);

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
    postModel?.positionName = positionName;
    postModel?.age = age;
    postModel?.location = location;
    postModel?.level = level.value;
    postModel?.skill = skills;
    postModel?.otherDetails = details;
    postModel?.references = reference;
  }

  /// Return true if any of field has value.
  bool checkForNonEmptyField() => postModel != null
      ? false
      : positionName.isNotEmpty ||
          location.isNotEmpty ||
          reference.isNotEmpty ||
          skills.isNotEmpty ||
          details.isNotEmpty;

  /// Shows confirmation dialog
  Future<bool> showConfirmationDialog() {
    return Future.value(Get.dialog(AppDialogWidget(
      onDone: () {
        Get.back(result: true);
      },
      dialogText: AppString.discardPosition,
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
      FocusScope.of(Get.context!).requestFocus(new FocusNode());
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

  /// get level type API.
  void getLevelAPI() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showGlobalLoading();

      dio.Response? response = await _provider.getLevel();

      if (response.statusCode == NetworkConstants.success) {
        /// On success
        _getLevelSuccess(response);
      } else {
        /// On Error
        _getLevelError(response);
      }
    } else {
      hideGlobalLoading();
      GetIt.I<CommonUtils>().showNetworkError();
    }
  }

  /// Perform level api success
  void _getLevelSuccess(dio.Response response) {
    hideGlobalLoading();

    SportTypeListResponseModel model =
        SportTypeListResponseModel.fromJson(response.data);

    /// set items to the list.
    if (model.status == true) {
      for (var element in (model.data ?? [])) {
        listLevel.add(element.name);
      }
    }
    _setDetailToFields();
  }

  /// Perform level api error.
  void _getLevelError(dio.Response response) {
    hideGlobalLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }
}
