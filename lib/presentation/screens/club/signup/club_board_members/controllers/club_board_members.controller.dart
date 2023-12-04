import 'package:dio/dio.dart' as dio;
import 'package:game_on_flutter/infrastructure/storage/preference_manager.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_loading_mixin.dart';
import 'package:game_on_flutter/values/app_colors.dart';
import 'package:game_on_flutter/values/common_utils.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../../../../../infrastructure/model/club/signup/club_signup_data.dart';
import '../../../../../../infrastructure/model/club_member_response_model.dart';
import '../../../../../../infrastructure/navigation/route_config.dart';
import '../../../../../../infrastructure/navigation/routes.dart';
import '../../../../../../infrastructure/network/api_utils.dart';
import '../../../../../../infrastructure/network/network_config.dart';
import '../../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../../values/app_string.dart';
import '../../../../../../values/app_values.dart';
import '../../../../../app_widgets/app_dialog_widget.dart';
import '../../add_member/add_member_bottomsheet.dart';
import '../../add_member/controllers/add_member_bottomsheet.controller.dart';
import '../../sports_selection/controllers/sports_selection.controller.dart';
import '../model/club_member_model.dart';
import '../providers/club_board_members_provider.dart';

class ClubBoardMembersController extends GetxController with AppLoadingMixin {
  /// if true then enable button.
  RxBool isValidField = RxBool(false);

  ///club signup data.
  SignUpData? signUpData;

  /// President object.
  Rx<ClubMemberModel> presidentObj = ClubMemberModel().obs;

  /// Director list
  RxList<ClubMemberModel> directorsList = RxList();

  /// Logger
  final logger = Logger();

  /// Stores edit detail bool
  bool editDetails = false;

  /// Track for when app needs to enable back button.
  bool enableBack = true;

  /// Club detail provides
  final _provider = ClubBoardMembersProvider();

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
      String message = Get.arguments[RouteArguments.message] ?? '';
      if (editDetails) {
        getClubBoardMembers();
      }

      if (message.isNotEmpty) {
        enableBack = false;
        Future.delayed(const Duration(seconds: 1), () {
          CommonUtils.showInfoSnackBar(message: message);
        });
      }
    }
  }

  /// on Submit called.
  void onSubmit() {
    if (editDetails) {
      editSuccessMessage();
    } else {
      Get.toNamed(Routes.CLUB_COACHING_STAFF, arguments: {
        RouteArguments.signupData: signUpData,
        RouteArguments.sportTypeEnum: sportsTypeEnum
      });
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
    GetIt.I<PreferenceManager>().setLogin(true);
    if (isValidField.isFalse) {
      Get.toNamed(Routes.CLUB_COACHING_STAFF,
          arguments: {RouteArguments.signupData: signUpData});
    }
  }

  /// Add director bottomSheet.
  void addDirectorBottomSheet() {
    const controllerTag = Routes.ADD_DIRECTOR_BOTTOMSHEET;
    Get.lazyPut<AddMemberBottomsheetController>(
        () => AddMemberBottomsheetController(),
        tag: controllerTag);
    Get.bottomSheet(
            AddMemberBottomsheet(
                bottomSheetTag: controllerTag,
                bottomSheetTitle: AppString.addDirector),
            barrierColor: AppColors.bottomSheetBgBlurColor,
            isScrollControlled: true)
        .then((value) {
      Get.delete<AddMemberBottomsheetController>(
          tag: controllerTag, force: true);
    });
  }

  /// Add president bottomSheet.
  void addPresidentBottomSheet() {
    const controllerTag = Routes.ADD_PRESIDENT_BOTTOMSHEET;
    Get.lazyPut<AddMemberBottomsheetController>(
        () => AddMemberBottomsheetController(),
        tag: controllerTag);
    Get.bottomSheet(
            AddMemberBottomsheet(
                bottomSheetTag: controllerTag,
                bottomSheetTitle: AppString.addPresident),
            barrierColor: AppColors.bottomSheetBgBlurColor,
            isScrollControlled: true)
        .then((value) {
      Get.delete<AddMemberBottomsheetController>(
          tag: controllerTag, force: true);
    });
  }

  /// Add president name to obj.
  void addPresident(ClubMemberModel obj) {
    presidentObj.value = obj;
    _checkValidation();
  }

  /// Check for validation
  _checkValidation() {
    isValidField.value = (presidentObj.value.userName ?? "").isNotEmpty;
    isValidField.refresh();
  }

  /// Add newly added director to the list.
  void addDirector(ClubMemberModel obj) {
    directorsList.add(obj);
  }

  /// update director object to the list.
  void updateDirectorList(ClubMemberModel obj, int index) {
    directorsList[index] = obj;
  }

  ///Confirmation for delete view
  Future<bool> onDismiss(String? model, int index) async {
    return false;
  }

  /// Edit director.
  void editDirector(ClubMemberModel obj, int index) {
    const controllerTag = Routes.ADD_DIRECTOR_BOTTOMSHEET;
    Get.lazyPut<AddMemberBottomsheetController>(
        () => AddMemberBottomsheetController(),
        tag: controllerTag);

    Get.bottomSheet(
            AddMemberBottomsheet(
                bottomSheetTag: controllerTag,
                isEditMember: true,
                details: obj,
                editMemberIndex: index,
                bottomSheetTitle: AppString.editDirector),
            barrierColor: AppColors.bottomSheetBgBlurColor,
            isScrollControlled: true)
        .then((value) {
      Get.delete<AddMemberBottomsheetController>(
          tag: controllerTag, force: true);
    });
  }

  /// Edit president
  void editPresident(ClubMemberModel obj, int index) {
    const controllerTag = Routes.ADD_PRESIDENT_BOTTOMSHEET;
    Get.lazyPut<AddMemberBottomsheetController>(
        () => AddMemberBottomsheetController(),
        tag: controllerTag);

    Get.bottomSheet(
            AddMemberBottomsheet(
                bottomSheetTag: controllerTag,
                isEditMember: true,
                details: obj,
                bottomSheetTitle: AppString.editPresident),
            barrierColor: AppColors.bottomSheetBgBlurColor,
            isScrollControlled: true)
        .then((value) {
      Get.delete<AddMemberBottomsheetController>(
          tag: controllerTag, force: true);
    });
  }

  /// Delete director from the list.
  void deleteDirector(ClubMemberModel obj, int index) {
    deleteConfirmationDialog(onDelete: () {
      deleteBoardMember(itemId: obj.itemId.toString(), index: index);
    });
  }

  /// Delete president from the list.
  void deletePresident(ClubMemberModel obj, int index) {
    CommonUtils.showInfoSnackBar(message: AppString.youCantRemovePresidentMessage);
    /*deleteConfirmationDialog(onDelete: () {
      deleteBoardMember(itemId: obj.itemId.toString(), index: index, isPresident: true);
    });*/
  }

  /// On call function
  void onCallClick(ClubMemberModel obj) =>
      CommonUtils.openPhoneApplication(obj.phone ?? "");

  /// on message function
  void onMessageClick(ClubMemberModel obj) =>
      CommonUtils.openEmailApplication(obj.email ?? "");

  /// Delete confirmation dialog.
  void deleteConfirmationDialog({required Function() onDelete}) {
    Get.dialog(AppDialogWidget(
      onDone: onDelete,
      dialogText: AppString.deleteBoardMemberConfirmationMessage,
    ));
  }

  /// Get club board members.
  void getClubBoardMembers() async {
    try {
      if (await NetworkConnectivity.instance.hasNetwork()) {
        showLoading();
        dio.Response? response = await _provider.getClubBoardMembers(
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

  /// Delete club member success.
  void _deleteClubMemberSuccess(dio.Response response, int index,bool isPresident ) {
    hideGlobalLoading();
    if(isPresident){
      presidentObj.value = ClubMemberModel();
    }else {
      directorsList.removeAt(index);
    }
    _checkValidation();
    getClubBoardMembers();
  }

  /// Perform get club member success.
  void _getClubMembersSuccess(dio.Response response) {
    hideLoading();
    ClubMemberResponseModel clubMemberResponseModel =
        ClubMemberResponseModel.fromJson(response.data);
    if (clubMemberResponseModel.status == true) {
      directorsList.clear();

      /// Prepare president obj.
      _preparePresident(clubMemberResponseModel);

      /// Prepare director obj.
      _prepareDirectorListFromApiResponse(clubMemberResponseModel);
    }
    _checkValidation();
  }

  /// prepare president obj from the api response.
  void _preparePresident(ClubMemberResponseModel clubMemberResponseModel) {
    final presidentList = clubMemberResponseModel.data?.president ?? [];
    if (presidentList.isNotEmpty) {
      final president = presidentList.first;

      final clubObj = prepareModelFromResponse(president);
      addPresident(clubObj);
    }
  }

  /// prepare director obj from the api response.
  void _prepareDirectorListFromApiResponse(
      ClubMemberResponseModel clubMemberResponseModel) {
    for (var element in (clubMemberResponseModel.data?.director ?? [])) {
      final clubObj = prepareModelFromResponse(element);
      addDirector(clubObj);
    }
  }

  /// return [ClubMemberModel] after preparing from api response.
  ClubMemberModel prepareModelFromResponse(President? element) {
    final clubObj = ClubMemberModel();
    clubObj.userName = element?.name ?? "";
    clubObj.email = element?.email ?? "";
    clubObj.phone = element?.contactNumber ?? "";
    clubObj.role = element?.type ?? "";
    clubObj.itemId = element?.id ?? -1;
    return clubObj;
  }

  /// Perform api error.
  void _getBoardMembersError(dio.Response response) {
    hideLoading();
    hideGlobalLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }

  /// Delete board members.
  void deleteBoardMember({required String itemId, required int index, bool isPresident=false}) async {
    try {
      if (await NetworkConnectivity.instance.hasNetwork()) {
        showGlobalLoading();
        dio.Response? response =
            await _provider.deleteClubBoardMembers(itemId: itemId, );
        if (response.statusCode == NetworkConstants.deleteSuccess) {
          /// On success
          _deleteClubMemberSuccess(response, index,isPresident);
        } else {
          /// On Error
          _getBoardMembersError(response);
        }
      } else {
        hideGlobalLoading();
        GetIt.I<CommonUtils>().showServerDownError();
      }
    } catch (ex) {
      logger.e(ex);
      hideGlobalLoading();
      CommonUtils.showErrorSnackBar(message: ex.toString());
    }
  }
}

enum BoardMemberViewType { SIGNUP, EDIT_SETTINGS, COMPLETE_PROFILE }
