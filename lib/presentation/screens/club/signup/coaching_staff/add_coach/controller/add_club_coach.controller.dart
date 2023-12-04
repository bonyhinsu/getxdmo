import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_loading_mixin.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../../../../../../infrastructure/model/common/add_member_response.dart';
import '../../../../../../../infrastructure/network/api_utils.dart';
import '../../../../../../../infrastructure/network/network_config.dart';
import '../../../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../../../values/app_string.dart';
import '../../../../../../../values/common_utils.dart';
import '../../../club_board_members/model/club_member_model.dart';
import '../provider/add_club_coach.provider.dart';

class AddClubCoachController extends GetxController with AppLoadingMixin {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController dobController;
  late TextEditingController specialityController;

  late FocusNode nameFocusNode;
  late FocusNode emailFocusNode;
  late FocusNode phoneFocusNode;
  late FocusNode dobFocusNode;
  late FocusNode specialityFocusNode;

  RxString nameError = "".obs;
  RxString emailError = "".obs;
  RxString roleError = "".obs;
  RxString phoneError = "".obs;
  RxString dobError = "".obs;

  /// bool to check field are valid or not.
  ///
  /// if true then enable button.
  RxBool isValidField = RxBool(false);

  /// form global key.
  final formKey = GlobalKey<FormState>();

  /// Form bottomSheet title.
  String bottomSheetTitle = AppString.addCoachingStaff;

  bool isEditMember = false;

  int itemId = -1;
  String _name = "";
  String _email = "";
  String _dob = "";
  String _phone = "";
  String _speciality = "";
  RxString experienceValue = "".obs;
  RxString gender = "".obs;

  /// Gender list
  List<String> genders = [AppString.male, AppString.female];

  /// Experience list
  List<String> experience = [
    "New Comer",
    "1+ Year",
    "2+ Years",
    "5+ Years",
    "7+ Years",
    "10+ Years",
    "15+ Years",
  ];

  final scrollController = ScrollController();

  /// provider.
  final _provider = AddClubCoachProvider();

  /// Logger.
  final logger = Logger();

  @override
  void onInit() {
    _initialiseFields();
    listenForFieldFocus();
    super.onInit();
  }

  /// Setup initial fields.
  void _initialiseFields() {
    nameController = TextEditingController(text: "");
    emailController = TextEditingController(text: "");
    phoneController = TextEditingController(text: "");
    dobController = TextEditingController(text: "");
    specialityController = TextEditingController(text: "");

    nameFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    phoneFocusNode = FocusNode();
    dobFocusNode = FocusNode();
    specialityFocusNode = FocusNode();

    setGender(genders.first);
    setExperience(experience.first);
  }

  /// listen for field focus.
  void listenForFieldFocus() {
    dobFocusNode.addListener(() {
      Future.delayed(const Duration(milliseconds: 400), () {
        if (dobFocusNode.hasFocus) {
          dobFocusNode.unfocus();
          openDatePicker();
        }
      });
    });

    specialityFocusNode.addListener(() {
      Future.delayed(const Duration(milliseconds: 400), () {
        if (specialityFocusNode.hasFocus) {
          scrollController.animateTo(scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut);
        }
      });
    });
  }

  /// Open date picker.
  void openDatePicker() async {
    final currentDate = DateTime.now();

    final nextDate = DateTime(currentDate.year - 18);
    final datetime = dob.isEmpty
        ? DateTime(currentDate.year - 25)
        : DateTime.parse(CommonUtils.yyyymmddDate(dob));
    final startDate = DateTime(currentDate.year - 100);
    final DateTime? picked = await showDatePicker(
        context: Get.context!,
        initialDate: datetime,
        firstDate: startDate,
        lastDate: nextDate);
    if (picked != null && picked != datetime) {
      final newFormattedDate = CommonUtils.ddmmmyyyyDate(picked.toString());
      dobController.text = newFormattedDate;
      setDob(newFormattedDate);
      dobFocusNode.unfocus();
      _checkValidation();

      if (speciality.isEmpty) {
        specialityFocusNode.requestFocus();
      }
    }
  }

  /// Check for each field and return with true if all fields are
  /// validate otherwise false.
  void _checkValidation() {
    isValidField.value = _name.isNotEmpty &&
        _email.isNotEmpty &&
        _phone.isNotEmpty &&
        speciality.isNotEmpty &&
        dob.isNotEmpty;
  }

  /// Clear fields.
  void clearFields() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    dobController.clear();
    _clearFieldErrors();
  }

  /// Clear all fields.
  void _clearFieldErrors() {
    nameError.value = "";
    emailError.value = "";
    roleError.value = "";
    phoneError.value = "";
  }

  /// submit form.
  void submitForm() {
    if (formKey.currentState!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();
      Future.delayed(const Duration(milliseconds: 100),(){
        if (isEditMember) {
          updateBoardMembers();
        } else {
          addCoachForClub();
        }
      });

    } else {
      isValidField.value = false;
      CommonUtils.showErrorSnackBar(
          message: AppString.invalidFormValidationErrorMessage);
    }
  }

  /// returns [_speciality] value
  String get speciality => _speciality;

  /// set [_speciality] value
  void setSpeciality(String value) {
    _speciality = value;
    _checkValidation();
  }

  /// returns [_phone] value
  String get phone => _phone;

  /// set [_phone] value
  void setPhone(String value) {
    _phone = value;

    _checkValidation();
  }

  /// returns [_dob] value
  String get dob => _dob;

  /// set [_dob] value
  void setDob(String value) {
    _dob = value;
    _checkValidation();
  }

  /// returns [_email] value
  String get email => _email;

  /// set [_email] value
  void setEmail(String value) {
    _email = value;
    _checkValidation();
  }

  /// returns [_name] value
  String get name => _name;

  /// set [_name] value
  void setName(String value) {
    _name = value;
    _checkValidation();
  }

  /// returns [_experience] value
  String get getExperience => experienceValue.value;

  /// set [_experience] value
  void setExperience(String value) {
    experienceValue.value = value;
    _checkValidation();
  }

  /// set [gender] value
  void setGender(String value) {
    gender.value = value;
    _checkValidation();
  }

  /// set data manually to local fields.
  void addExistingDataToFields(ClubMemberModel model) {
    String convertedDate =
        CommonUtils.ddmmmyyyyDateWithTimezone2(model.dateOfBirth ?? "");

    dobController.text = convertedDate;
    nameController.text = model.userName ?? "";
    emailController.text = model.email ?? "";
    phoneController.text = model.phone ?? "";
    specialityController.text = model.role ?? "";
    itemId = model.itemId ?? -1;

    setExperience(model.totalExperience ?? "");
    setDob(convertedDate);
    setName(model.userName ?? "");
    setEmail(model.email ?? "");
    setPhone(model.phone ?? "");
    setSpeciality(model.role ?? "");
    setGender((model.gender ?? 1) == 1 ? genders.first : genders.last);
  }

  /// add data to screen.
  void addDataToScreen(int id) {
    String convertedDate = CommonUtils.yyyyMMddTHHmmsssZDateWithTimezone(dob);
    ClubMemberModel coachModel = ClubMemberModel.coach(
        userName: name,
        dateOfBirth: convertedDate,
        email: email,
        phone: phone,
        role: speciality,
        gender: gender.value == genders.first ? 1 : 2,
        totalExperience: getExperience,
        itemId: id);

    Get.back(result: coachModel);
  }

  /// Add coach detail API.
  void addCoachForClub() async {
    try {
      if (await NetworkConnectivity.instance.hasNetwork()) {
        showGlobalLoading();

        // Convert date from dd/MM/yyyy to yyyy-MM-dd HH:mm:ss.
        final convertedDate = CommonUtils.yyyymmddDate(dob);

        dio.Response? response = await _provider.addCoachForClub(
            email: email,
            name: name,
            phone: phone,
            dateOfBirth: convertedDate,
            gender: gender.value,
            experience: experienceValue.value,
            speciality: speciality);
        if (response.data != null) {
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
      } else {
        hideGlobalLoading();
        GetIt.I<CommonUtils>().showNetworkError();
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

        // Convert date from dd/MM/yyyy to yyyy-MM-dd HH:mm:ss.
        final convertedDate = CommonUtils.yyyymmddDate(dob);

        dio.Response? response = await _provider.updateCoachForClub(
            email: email,
            name: name,
            phone: phone,
            dateOfBirth: convertedDate,
            gender: gender.value,
            experience: experienceValue.value,
            speciality: speciality,
            id: itemId);
        if (response.data != null) {
          if (response.statusCode == NetworkConstants.success) {
            /// On success
            _updateCoachSuccess(response);
          } else {
            /// On Error
            _addBoardMembersError(response);
          }
        } else {
          hideGlobalLoading();
          GetIt.I<CommonUtils>().showServerDownError();
        }
      } else {
        hideGlobalLoading();
        GetIt.I<CommonUtils>().showNetworkError();
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
    itemId = addMemberResponse.data?.id ?? -1;
    addDataToScreen(itemId);
  }

  /// Perform update coach success
  void _updateCoachSuccess(dio.Response response) {
    hideGlobalLoading();
    addDataToScreen(itemId);
  }

  /// Perform api error.
  void _addBoardMembersError(dio.Response response) {
    hideGlobalLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }
}
