import 'package:collection/collection.dart';
import 'package:dio/dio.dart' as dio;
import 'package:game_on_flutter/infrastructure/storage/preference_manager.dart';
import 'package:game_on_flutter/values/app_constant.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../../../infrastructure/firebase/firebase_auth_manager.dart';
import '../../../../../../infrastructure/firebase/firestore_manager.dart';
import '../../../../../../infrastructure/model/club/signup/club_signup_data.dart';
import '../../../../../../infrastructure/model/club_member_response_model.dart';
import '../../../../../../infrastructure/navigation/route_config.dart';
import '../../../../../../infrastructure/navigation/routes.dart';
import '../../../../../../infrastructure/network/api_utils.dart';
import '../../../../../../infrastructure/network/network_config.dart';
import '../../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../../presentation/app_widgets/app_dialog_widget.dart';
import '../../../../../../presentation/screens/club/signup/add_member/add_member_bottomsheet.dart';
import '../../../../../../presentation/screens/club/signup/add_member/controllers/add_member_bottomsheet.controller.dart';
import '../../../../../../values/app_colors.dart';
import '../../../../../../values/app_string.dart';
import '../../../../../../values/app_values.dart';
import '../../../../../../values/common_utils.dart';
import '../../../../../app_widgets/app_loading_mixin.dart';
import '../../club_board_members/model/club_member_model.dart';
import '../providers/other_contacts_provider.dart';

class OtherContactInfomationController extends GetxController
    with AppLoadingMixin {
  /// Director list.
  RxList<ClubMemberModel> membersList = RxList();

  /// Prepare group member list.
  RxList<MemberRoleGroupModel> groupMemberList = RxList();

  ///club signup data.
  SignUpData? signUpData;

  /// Stores edit detail bool.
  bool editDetails = false;

  /// if true then enable button.
  RxBool isValidField = RxBool(false);

  /// Provider
  final _provider = OtherContactsProvider();

  /// Logger
  final logger = Logger();

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
      if (editDetails) {
        _getOtherMembers();
      }
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

  /// on Submit called.
  void onSubmit() {
    if (editDetails) {
      editSuccessMessage();
    } else {
      _loginWithFirebase();
    }
  }

  /// On skip click
  void skipToNextScreen() {
    _loginWithFirebase();
  }

  /// Add director bottomSheet.
  void addDirectorBottomSheet() {
    const controllerTag = Routes.ADD_ANOTHER_DIRECTOR_BOTTOMSHEET;
    Get.lazyPut<AddMemberBottomsheetController>(
        () => AddMemberBottomsheetController(),
        tag: controllerTag);
    Get.bottomSheet(
            AddMemberBottomsheet(
                bottomSheetTag: controllerTag,
                enableRole: true,
                bottomSheetTitle: AppString.addOtherContactInfo),
            barrierColor: AppColors.bottomSheetBgBlurColor,
            isScrollControlled: true)
        .then((value) {
      Get.delete<AddMemberBottomsheetController>(
          tag: controllerTag, force: true);
    });
  }

  /// Add newly added director to the list.
  void addMember(ClubMemberModel obj) {
    obj.userId = DateTime.now().millisecondsSinceEpoch;
    final capitaliseRole = (obj.role ?? "").capitalizeFirst ?? "";
    obj.role = capitaliseRole;
    membersList.add(obj);
    _prepareGroup();
    _checkValidation();
  }

  /// Check for validation.
  void _checkValidation() {
    isValidField.value = membersList.isNotEmpty;
  }

  /// update director object to the list.
  void updateMemberList(ClubMemberModel obj, int userId) {
    final parentIndex =
        membersList.indexWhere((element) => element.userId == userId);
    if (parentIndex != -1) {
      membersList[parentIndex].userName = obj.userName;
      membersList[parentIndex].role = obj.role;
      membersList[parentIndex].email = obj.email;
      _prepareGroup();
    }
  }

  void _prepareGroup() {
    groupMemberList.clear();
    final map = groupBy(membersList, (obj) => obj.role ?? "");

    map.forEach((key, value) {
      groupMemberList.add(MemberRoleGroupModel(key, value));
    });
  }

  /// Edit director.
  void editDirector(ClubMemberModel obj, int index, int roleIndex) {
    const controllerTag = Routes.ADD_ANOTHER_DIRECTOR_BOTTOMSHEET;

    Get.lazyPut<AddMemberBottomsheetController>(
        () => AddMemberBottomsheetController(),
        tag: controllerTag);

    Get.bottomSheet(
            AddMemberBottomsheet(
                bottomSheetTag: controllerTag,
                isEditMember: true,
                enableRole: true,
                details: obj,
                userId: obj.userId,
                role: roleIndex,
                editMemberIndex: index,
                bottomSheetTitle: AppString.editOtherContactInfo),
            barrierColor: AppColors.bottomSheetBgBlurColor,
            isScrollControlled: true)
        .then((value) {
      Get.delete<AddMemberBottomsheetController>(
          tag: controllerTag, force: true);
    });
  }

  /// Delete director from the list.
  void deleteDirector(ClubMemberModel obj, int index, int roleIndex) {
    deleteConfirmationDialog(onDelete: () {
      final getItem = groupMemberList[roleIndex].memberList?[index];
      membersList.remove(getItem);
      groupMemberList[roleIndex].memberList?.removeAt(index);
      _prepareGroup();
      _checkValidation();
    });
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

  /// Navigate to subscription plan screen.
  void navigateToSubscriptionPlan() {
    hideGlobalLoading();
    GetIt.I<PreferenceManager>().setLogin(true);
    GetIt.I<PreferenceManager>().setUserProfile("");
    GetIt.I<PreferenceManager>().setUserEmail(signUpData?.clubEmail ?? "");
    GetIt.I<PreferenceManager>().setUserName(signUpData?.clubName ?? "");
    final sportTypeId = (signUpData?.sportType ?? []).isNotEmpty
        ? (signUpData?.sportType ?? []).first.itemId
        : -1;

    Get.offAllNamed(Routes.SUBSCRIPTION_PLAN, arguments: {
      RouteArguments.sportTypeId: sportTypeId.toString(),
      RouteArguments.signupData: signUpData,
    });
  }

  /// Delete confirmation dialog.
  void successInformationDialog({required Function() onDone}) {
    Get.dialog(AppDialogWidget(
      onDone: navigateToSubscriptionPlan,
      enableCancelWidget: false,
      dialogText: AppString.clubSignupSuccessMessage,
    ));
  }

  /// Login user in firebase
  void _loginWithFirebase() async {
    showGlobalLoading();
    String version = "";
    String buildNumber = "";
    String deviceType = GetPlatform.isAndroid ? "Android" : "iOS";
    String lastLoginDateAndTime = DateTime.now().toIso8601String();

    await PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });

    //Save user and application detail
    FirebaseAuthManager.instance.loginUserWithEmailAndPassword(
      (signUpData?.clubEmail ?? "").trim(),
      GetIt.I<CommonUtils>().getUserPassword(),
      (uuid) async {
        GetIt.I<PreferenceManager>().setUserName(
          signUpData?.clubName ?? "",
        );
        GetIt.I<PreferenceManager>().setUserEmail(
          signUpData?.clubEmail ?? "",
        );
        GetIt.I<PreferenceManager>().setUserProfile('');

        GetIt.I<PreferenceManager>().setFirebaseChatUserId(uuid);
        GetIt.I<PreferenceManager>().setFirebaseUUID(uuid);

        /// Step2 : Update user detail is firebase user document
        await GetIt.I<FireStoreManager>().saveUserData(
            email: signUpData?.clubEmail ?? "",
            uuid: uuid,
            deviceType: deviceType,
            buildNumber: buildNumber,
            userName: signUpData?.clubName ?? "",
            userId: GetIt.I<PreferenceManager>().userId.toString(),
            lastLoginDateAndTime: lastLoginDateAndTime,
            phoneNumber: signUpData?.clubPhoneNumber ?? "",
            userType: AppConstants.userTypeClub,
            isRegisterUser: true,
            version: version);

        GetIt.I<PreferenceManager>().setFirebaseChatUserId(uuid);
        GetIt.I<PreferenceManager>().setFirebaseUUID(uuid);
        _navigateToSubscription();
      },
      (error) {
        print("loginUserWithEmailAndPassword $error");
        if (error.contains("firebase_auth/user-not-found")) {
          _registerUserWithFireBase(
            email: (signUpData?.clubEmail ?? ""),
            version: version,
            deviceType: deviceType,
            lastLoginDateAndTime: lastLoginDateAndTime,
            buildNumber: buildNumber,
          );
        }
        isLoading.value = false;
      },
    );
  }

  /// Register new user if the user is not exists in firebase.
  ///
  /// required [email]
  /// required [deviceType]
  /// required [buildNumber]
  /// required [version]
  /// required [lastLoginDateAndTime]
  void _registerUserWithFireBase({
    String email = "",
    String deviceType = "",
    String buildNumber = "",
    String version = "",
    String lastLoginDateAndTime = "",
  }) {
    //Save user and application detail
    FirebaseAuthManager.instance.registerUserWithEmailAndPassword(
      email.trim(),
      GetIt.I<CommonUtils>().getUserPassword(),
      (uuid) async {
        GetIt.I<PreferenceManager>().setUserName(
          signUpData?.clubName ?? "",
        );
        GetIt.I<PreferenceManager>().setUserEmail(
          signUpData?.clubEmail ?? "",
        );
        GetIt.I<PreferenceManager>().setUserProfile('');

        GetIt.I<PreferenceManager>().setFirebaseChatUserId(uuid);
        GetIt.I<PreferenceManager>().setFirebaseUUID(uuid);

        /// Step2 : Update user detail is firebase user document
        await GetIt.I<FireStoreManager>().saveUserData(
            email: email.trim(),
            uuid: uuid,
            userType: AppConstants.userTypeClub,
            isRegisterUser: true,
            userName: (signUpData?.clubName ?? ""),
            userId: GetIt.I<PreferenceManager>().userId.toString(),
            deviceType: deviceType,
            buildNumber: buildNumber,
            lastLoginDateAndTime: lastLoginDateAndTime,
            phoneNumber: signUpData?.clubPhoneNumber ?? "",
            version: version);
        GetIt.I<PreferenceManager>().setFirebaseChatUserId(uuid);
        GetIt.I<PreferenceManager>().setFirebaseUUID(uuid);

        _navigateToSubscription();
      },
      (error) {
        print("_registerUserWithFireBase $error");
        isLoading.value = false;
      },
    );
  }

  /// Navigate to subscription screen
  void _navigateToSubscription() async {
    GetIt.I<PreferenceManager>().setLogin(true);
    navigateToSubscriptionPlan();
  }

  /// Get other club members.
  void _getOtherMembers() async {
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

  /// Perform get club member success.
  void _getClubMembersSuccess(dio.Response response) {
    hideLoading();
    ClubMemberResponseModel clubMemberResponseModel =
        ClubMemberResponseModel.fromJson(response.data);
    if (clubMemberResponseModel.status == true) {
      membersList.clear();

      (clubMemberResponseModel.data?.otherInfo ?? []).forEach((element) {
        membersList.add(ClubMemberModel.member(
            element.name, element.type, element.email, element.contactNumber));
      });
    }
    _prepareGroup();
    _checkValidation();
  }

  /// Perform api error.
  void _getBoardMembersError(dio.Response response) {
    hideLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }

  /// Delete board members.
  void deleteBoardMember({required String itemId, required int index}) async {
    try {
      if (await NetworkConnectivity.instance.hasNetwork()) {
        showLoading();
        dio.Response? response =
            await _provider.deleteClubBoardMembers(itemId: itemId);
        if (response.statusCode == NetworkConstants.deleteSuccess) {
          /// On success
          _deleteClubMemberSuccess(response, index);
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

  /// Delete club member success.
  void _deleteClubMemberSuccess(dio.Response response, int index) {
    membersList.removeAt(index);
    _checkValidation();
    _getOtherMembers();
  }
}

class MemberRoleGroupModel {
  String? role;
  List<ClubMemberModel>? memberList;

  MemberRoleGroupModel(this.role, this.memberList);
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
