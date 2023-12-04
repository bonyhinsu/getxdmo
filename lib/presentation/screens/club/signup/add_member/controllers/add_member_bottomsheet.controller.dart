import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_loading_mixin.dart';
import 'package:game_on_flutter/values/app_constant.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../../../../../infrastructure/model/common/add_member_response.dart';
import '../../../../../../infrastructure/navigation/routes.dart';
import '../../../../../../infrastructure/network/api_utils.dart';
import '../../../../../../infrastructure/network/network_config.dart';
import '../../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../../values/common_utils.dart';
import '../../club_board_members/controllers/club_board_members.controller.dart';
import '../../club_board_members/model/club_member_model.dart';
import '../../other_contact_infomation/controllers/other_contact_infomation.controller.dart';
import '../providers/add_member_bottomsheet_provider.dart';

class AddMemberBottomsheetController extends GetxController
    with AppLoadingMixin {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController roleController;

  late FocusNode nameFocusNode;
  late FocusNode emailFocusNode;
  late FocusNode phoneFocusNode;
  late FocusNode roleFocusNode;

  RxString nameError = "".obs;
  RxString emailError = "".obs;
  RxString roleError = "".obs;
  RxString phoneError = "".obs;

  /// bool to check field are valid or not.
  ///
  /// if true then enable button.
  RxBool isValidField = RxBool(false);

  /// form global key.
  final formKey = GlobalKey<FormState>();

  /// Form bottomSheet title.
  String bottomSheetTitle = '';

  /// Store tag to enable where the bottomSheet is triggered from.
  String bottomSheetTag = '';

  /// true if role field enable otherwise false.
  bool enableRole = false;

  /// true if bottom sheet opens for update member.
  bool isEditMember = false;

  /// Index of the member list.
  int itemIndex = 0;

  // user id
  int userId = 0;

  // item id
  int memberObjId = 0;

  String _name = "";
  String _email = "";
  String _role = "";
  String _phone = "";

  /// Logger.
  final logger = Logger();

  /// provider.
  final _provider = AddMemberBottomSheetProvider();

  @override
  void onInit() {
    _initialiseFields();
    super.onInit();
  }

  /// Setup initial fields.
  void _initialiseFields() {
    nameController = TextEditingController(text: "");
    emailController = TextEditingController(text: "");
    phoneController = TextEditingController(text: "");
    roleController = TextEditingController(text: "");

    nameFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    phoneFocusNode = FocusNode();
    roleFocusNode = FocusNode();
  }

  void setBottomSheetTag(String tag) {
    bottomSheetTag = tag;
    if (bottomSheetTag == Routes.ADD_PRESIDENT_BOTTOMSHEET) {
      setRole(AppConstants.rolePresident);
    }
    if (bottomSheetTag == Routes.ADD_DIRECTOR_BOTTOMSHEET) {
      setRole(AppConstants.roleDirector);
    }
  }

  /// Check for each field and return with true if all fields are
  /// validate otherwise false.
  void _checkValidation() {
    isValidField.value = _name.isNotEmpty &&
        _email.isNotEmpty &&
        _phone.isNotEmpty &&
        (enableRole ? _role.isNotEmpty : true);
  }

  /// Clear fields.
  void clearFields() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    roleController.clear();
    setName('');
    setEmail('');
    setPhone('');
    _clearFieldErrors();
  }

  /// Clear all fields.
  void _clearFieldErrors() {
    nameError.value = "";
    emailError.value = "";
    roleError.value = "";
    phoneError.value = "";
  }

  /// set name
  void setName(String value) {
    _name = value;
    _checkValidation();
  }

  /// set email
  void setEmail(String value) {
    _email = value;
    _checkValidation();
  }

  /// set phone number
  void setPhone(String value) {
    _phone = value;
    _checkValidation();
  }

  /// set role.
  void setRole(String value) {
    _role = value;
    _checkValidation();
  }

  /// submit form.
  void submitForm() {
    if (formKey.currentState!.validate()) {
      if (!isEditMember) {
        addBoardMembers();
      } else {
        updateBoardMembers();
      }
    }
  }

  /// Add president name to the list.
  void _addPresidentName() {
    final ClubBoardMembersController controller0 =
        Get.find(tag: Routes.CLUB_BOARD_MEMBERS_PRESIDENT);

    final obj = getMemberObj();
    controller0.addPresident(obj);
  }

  /// Add newly added director to the list.
  void _addDirector() {
    final ClubBoardMembersController controller =
        Get.find(tag: Routes.CLUB_BOARD_MEMBERS_DIRECTORS);

    final obj = getMemberObj();
    controller.addDirector(obj);
  }

  /// Update existing director list.
  void _updateDirector() {
    final ClubBoardMembersController controller =
        Get.find(tag: Routes.CLUB_BOARD_MEMBERS_DIRECTORS);

    final obj = getMemberObj();
    controller.updateDirectorList(obj, itemIndex);
  }

  /// Add newly added director to the list.
  void _addOtherMember() {
    final OtherContactInfomationController controller =
        Get.find(tag: Routes.OTHER_CONTACT_INFORMATION);

    final obj = getMemberObj();
    controller.addMember(obj);
  }

  /// Update existing member list
  void _updateOtherMember() {
    final OtherContactInfomationController controller =
        Get.find(tag: Routes.OTHER_CONTACT_INFORMATION);

    final obj = getMemberObj();
    controller.updateMemberList(obj, userId);
  }

  /// perform add logic to screen.
  void _performFields() {
    if (bottomSheetTag == Routes.ADD_PRESIDENT_BOTTOMSHEET) {
      _addPresidentName();
    } else if (bottomSheetTag == Routes.ADD_DIRECTOR_BOTTOMSHEET) {
      if (isEditMember) {
        _updateDirector();
      } else {
        _addDirector();
      }
    } else if (bottomSheetTag == Routes.ADD_ANOTHER_DIRECTOR_BOTTOMSHEET) {
      if (isEditMember) {
        _updateOtherMember();
      } else {
        _addOtherMember();
      }
    }
    clearFields();
    Get.back();
  }

  /// Set member data
  void setMemberData(ClubMemberModel model, int index) {
    isEditMember = true;
    itemIndex = index;
    emailController.text = model.email ?? "";
    phoneController.text = model.phone ?? "";
    nameController.text = model.userName ?? "";
    roleController.text = model.role ?? "";
    memberObjId = model.itemId ?? -1;

    _email = emailController.text;
    _phone = phoneController.text;
    _name = nameController.text;
    _role = roleController.text;

    _checkValidation();
  }

  /// Return instance of [ClubMemberModel].
  ClubMemberModel getMemberObj() {
    final memberObj = ClubMemberModel();
    memberObj.userName = _name;
    memberObj.email = _email;
    memberObj.phone = _phone;
    memberObj.role = _role;
    memberObj.itemId = memberObjId;
    return memberObj;
  }

  /// Add club detail API.
  void addBoardMembers() async {
    try {
      if (await NetworkConnectivity.instance.hasNetwork()) {
        showGlobalLoading();

        dio.Response? response = await _provider.addMemberBottomSheetProvider(
            email: _email,
            name: _name,
            role: _role,
            phone: _phone,
            isFromOtherMember:
                bottomSheetTag == Routes.ADD_ANOTHER_DIRECTOR_BOTTOMSHEET);

        if (response.statusCode == NetworkConstants.created) {
          /// On success
          _addBoardMembersSuccess(response);
        } else {
          /// On Error
          _addBoardMembersError(response);
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

  /// Update club detail API.
  void updateBoardMembers() async {
    try {
      if (await NetworkConnectivity.instance.hasNetwork()) {
        showGlobalLoading();
        dio.Response? response =
            await _provider.updateMemberBottomSheetProvider(
                email: _email,
                name: _name,
                role: _role,
                phone: _phone,
                isFromOtherMember:
                    bottomSheetTag == Routes.ADD_ANOTHER_DIRECTOR_BOTTOMSHEET,
                id: memberObjId);
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _updateBoardMembersSuccess(response);
        } else {
          /// On Error
          _addBoardMembersError(response);
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

  /// Perform login api success
  void _addBoardMembersSuccess(dio.Response response) {
    hideGlobalLoading();
    AddMemberResponse addMemberResponse =
        AddMemberResponse.fromJson(response.data);
    memberObjId = addMemberResponse.data?.id ?? -1;
    _performFields();
  }

  /// Perform login api success
  void _updateBoardMembersSuccess(dio.Response response) {
    hideGlobalLoading();
    _performFields();
  }

  /// Perform api error.
  void _addBoardMembersError(dio.Response response) {
    hideGlobalLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }
}
