import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_loading_mixin.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../../../../../../infrastructure/model/club/signup/club_signup_data.dart';
import '../../../../../../../infrastructure/model/coaching_staff_response.dart';
import '../../../../../../../infrastructure/navigation/route_config.dart';
import '../../../../../../../infrastructure/navigation/routes.dart';
import '../../../../../../../infrastructure/network/api_utils.dart';
import '../../../../../../../infrastructure/network/network_config.dart';
import '../../../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../../../infrastructure/storage/preference_manager.dart';
import '../../../../../../../values/app_string.dart';
import '../../../../../../../values/app_values.dart';
import '../../../../../../../values/common_utils.dart';
import '../../../../../../app_widgets/app_dialog_widget.dart';
import '../../../club_board_members/controllers/club_board_members.controller.dart';
import '../../../club_board_members/model/club_member_model.dart';
import '../../../sports_selection/controllers/sports_selection.controller.dart';
import '../../add_coach/controller/add_club_coach.controller.dart';
import '../../add_coach/view/add_club_coach_screen.dart';
import '../provider/club_coach.provider.dart';

class ClubCoachController extends GetxController with AppLoadingMixin {
  /// if true then enable button.
  RxBool isValidField = RxBool(false);

  ///club signup data.
  SignUpData? signUpData;

  /// Logger
  final logger = Logger();

  /// Stores edit detail bool
  bool editDetails = false;

  /// Club detail provides
  final _provider = ClubCoachProvider();

  /// Director list
  RxList<ClubMemberModel> coachList = RxList();

  SportTypeEnum sportsTypeEnum = SportTypeEnum.SIGNUP;

  @override
  void onInit() {
    _getArguments();
    super.onInit();
  }

  /// Get argument from previous screen
  void _getArguments() {
    if (Get.arguments != null) {
      signUpData = Get.arguments[RouteArguments.signupData] ??
          SignUpData.prepareDummyData();

      editDetails = Get.arguments[RouteArguments.updateDetails] ?? false;
      sportsTypeEnum =
          Get.arguments[RouteArguments.sportTypeEnum] ?? SportTypeEnum.SIGNUP;
      if (editDetails) {
        getClubCoachList();
      }
    }
    showLoading();

    Future.delayed(const Duration(seconds: 1), () {
      hideLoading();
    });
  }

  /// on Submit called.
  void onSubmit() {
    if (editDetails) {
      editSuccessMessage();
    } else {
      Get.toNamed(Routes.OTHER_CONTACT_INFORMATION,
          arguments: {RouteArguments.signupData: signUpData});
    }
  }

  /// Edit success message.
  void editSuccessMessage() {
    isValidField.value = false;
    CommonUtils.showSuccessSnackBar(message: AppString.detailsUpdateSuccess);

    Future.delayed(const Duration(seconds: AppValues.successMessageDetailInSec),
        () {
      Get.until((route) => route.settings.name == Routes.CLUB_MAIN);
    });
  }

  /// On skip click
  void skipToNextScreen() {
    Get.toNamed(Routes.OTHER_CONTACT_INFORMATION,
        arguments: {RouteArguments.signupData: signUpData});
  }

  /// Add coach bottomSheet.
  void addCoachBottomSheet() {
    const controllerTag = Routes.CLUB_ADD_COACHING_STAFF;
    Get.lazyPut<AddClubCoachController>(() => AddClubCoachController(),
        tag: controllerTag);
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      builder: (context) => AddClubCoachBottomSheet(),
    ).then((value) {
      if (value != null) {
        addCoachToList(value);
      }
      Get.delete<AddClubCoachController>(tag: controllerTag, force: true);
    });
  }

  /// Add coach list.
  ///
  /// required [ClubMemberModel]
  void addCoachToList(ClubMemberModel model) {
    coachList.add(model);
    coachList.refresh();
    _checkValidation();
  }

  /// Update coach list.
  ///
  /// required [ClubMemberModel]
  /// required [index]
  void updateCoachToList(ClubMemberModel model, int index) {
    coachList[index] = model;
    _checkValidation();
    CommonUtils.showSuccessSnackBar(message: AppString.detailsUpdateSuccess);
  }

  /// Edit director.
  ///
  /// required [ClubMemberModel]
  /// required [index]
  void editDirector(ClubMemberModel obj, int index) {
    const controllerTag = Routes.CLUB_ADD_COACHING_STAFF;
    Get.lazyPut<AddClubCoachController>(() => AddClubCoachController(),
        tag: controllerTag);
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      builder: (context) => AddClubCoachBottomSheet(
        editDetail: true,
        model: obj,
      ),
    ).then((value) {
      if (value != null) {

        updateCoachToList(value, index);
      }
      Get.delete<AddClubCoachController>(tag: controllerTag, force: true);
    });
  }

  /// check validation.
  void _checkValidation() {
    isValidField.value = coachList.isNotEmpty;
    coachList.refresh();
    isValidField.refresh();
  }

  /// On call function
  ///
  /// required [ClubMemberModel]
  void onCallClick(ClubMemberModel obj) =>
      CommonUtils.openPhoneApplication(obj.phone ?? "");

  /// on message function
  ///
  /// required [ClubMemberModel]
  void onMessageClick(ClubMemberModel obj) =>
      CommonUtils.openEmailApplication(obj.email ?? "");

  /// Delete director from the list.
  ///
  /// required [ClubMemberModel]
  /// required [index]
  void deleteCoach(ClubMemberModel obj, int index) {
    deleteConfirmationDialog(onDelete: () {
      deleteCoachFromList((obj.itemId ?? -1).toString(), index);
    });
  }

  /// Delete confirmation dialog.
  void deleteConfirmationDialog({required Function() onDelete}) {
    Get.dialog(AppDialogWidget(
      onDone: onDelete,
      dialogText: AppString.deleteBoardMemberConfirmationMessage,
    ));
  }

  /// Get club coach members.
  void getClubCoachList() async {
    try {
      if (await NetworkConnectivity.instance.hasNetwork()) {
        showLoading();
        dio.Response? response = await _provider.getClubCoaches(
            clubId: GetIt.I<PreferenceManager>().userId.toString());
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _getClubMembersSuccess(response);
        } else {
          /// On Error
          _getBoardMembersError(response);
        }
      } else {
        hideLoading();
        GetIt.I<CommonUtils>().showServerDownError();
      }
    } catch (ex) {
      logger.e(ex);
      hideGlobalLoading();
      CommonUtils.showErrorSnackBar(message: ex.toString());
    }
  }

  /// delete coach from club.
  void deleteCoachFromList(String itemId, int index) async {
    try {
      if (await NetworkConnectivity.instance.hasNetwork()) {
        showLoading();
        dio.Response? response =
            await _provider.deleteClubBoardCoach(itemId: itemId);
        if (response.statusCode == NetworkConstants.deleteSuccess) {
          /// On success
          _deleteCoachResponse(response, index);
        } else {
          /// On Error
          _getBoardMembersError(response);
        }
      } else {
        hideLoading();
        GetIt.I<CommonUtils>().showServerDownError();
      }
    } catch (ex) {
      logger.e(ex);
      hideGlobalLoading();
      CommonUtils.showErrorSnackBar(message: ex.toString());
    }
  }

  /// Perform get club member success.
  void _getClubMembersSuccess(dio.Response response) {
    hideLoading();
    CoachingStaffResponseModel coachResponse =
        CoachingStaffResponseModel.fromJson(response.data);
    if (coachResponse.status == true) {
      coachResponse.data?.forEach((coachElement) {
        coachList.add(ClubMemberModel.coach(
            userName: coachElement.name,
            itemId: coachElement.id,
            totalExperience: coachElement.experience,
            role: coachElement.speciality,
            phone: coachElement.contactNumber,
            email: coachElement.email,
            dateOfBirth: coachElement.dateOfBirth,
            gender: (coachElement.gender ?? "male").toLowerCase() == 'male'
                ? 1
                : 2));
      });
    }
    _checkValidation();
  }

  /// Delete coach response
  void _deleteCoachResponse(dio.Response response, int index) {
    coachList.removeAt(index);
    hideLoading();
    _checkValidation();
  }

  /// Perform api error.
  void _getBoardMembersError(dio.Response response) {
    hideLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }

  Future<void> refreshList()async{
    coachList.clear();
    getClubCoachList();
  }
}
