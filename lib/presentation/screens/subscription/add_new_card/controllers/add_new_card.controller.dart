import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../../infrastructure/model/subscription/payment_method_model.dart';
import '../../../../../infrastructure/navigation/route_config.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../infrastructure/network/api_utils.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../infrastructure/utils/card_utils.dart';
import '../../../../../values/app_values.dart';
import '../../../../../values/common_utils.dart';
import '../../../../app_widgets/app_loading_mixin.dart';
import '../../payment_mathod/controllers/payment_mathod.controller.dart';
import '../providers/add_new_card_provider.dart';

class AddNewCardController extends GetxController with AppLoadingMixin {
  AddCardTypeEnum addCardTypeEnum = AddCardTypeEnum.SAVE_CARD;

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController cardNumberTextEditingController =
      TextEditingController();
  TextEditingController expDateTextEditingController = TextEditingController();
  TextEditingController cvvTextEditingController = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode cardNumberFocusNode = FocusNode();
  FocusNode expDateFocusNode = FocusNode();
  FocusNode cvvFocusNode = FocusNode();

  final _provider = AddNewCardProvider();

  /// store valid field flag
  RxBool validFields = false.obs;

  final formKey = GlobalKey<FormState>();

  RxString nameError = "".obs;
  RxString numberError = "".obs;
  RxString expiryError = "".obs;
  RxString cvvError = "".obs;

  String _cardName = "";
  String _cardNumber = "";
  String _cardExpiryDate = "";
  String _cardCVV = "";

  /// true if user check save card.
  RxBool saveCard = true.obs;

  @override
  void onInit() {
    _getArguments();
    super.onInit();
  }

  /// Receive argument from previous screen.
  void _getArguments() {
    if (Get.arguments != null) {
      addCardTypeEnum = Get.arguments[RouteArguments.addCardType] ??
          AddCardTypeEnum.SAVE_CARD;
    }
  }

  /// save card name
  void setCardName(String value) {
    _cardName = value;
    validFields();
  }

  /// set card number
  void setCardNumber(String value) {
    _cardNumber = value;
    validateFields();
    if (_cardNumber.length == AppValues.paymentCardNumberMaxLength &&
        _cardExpiryDate.isEmpty) {
      expDateFocusNode.requestFocus();
    }
    numberError.refresh();
  }

  /// set card expiry
  void setCardExpiry(String value) {
    _cardExpiryDate = value;
    validateFields();
    if (_cardExpiryDate.length == AppValues.paymentCardExpiryMaxLength &&
        _cardCVV.isEmpty) {
      cvvFocusNode.requestFocus();
    }
  }

  /// set card cvv.
  void setCardCVV(String value) {
    _cardCVV = value;
    validateFields();

    if (_cardCVV.length == AppValues.paymentCVVMaxLength) {
      FocusScope.of(Get.context!).unfocus();
    }
  }

  /// Check field validation
  void validateFields() {
    bool validateCardNumberField = _cardNumber.isNotEmpty;

    bool validExpiry = _cardExpiryDate.isNotEmpty;

    bool validCVV = _cardCVV.isNotEmpty;

    validFields.value = validateCardNumberField &&
        validExpiry &&
        validCVV &&
        _cardName.isNotEmpty;
  }

  /// on
  void onSubmit() {
    if (formKey.currentState!.validate()) {
      _clearFieldErrors();
      final isFieldFields = checkForValidateField();
      if (isFieldFields) {
        _clearFields();

        /// TODO: Do api call to save payment detail.

        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          if (saveCard.value) {
            CommonUtils.showSuccessSnackBar(
                message: AppString.addCardSuccessMessage);
            Future.delayed(const Duration(seconds: 2), () {
              _navigateToNextScreen();
            });
          } else {
            _navigateToNextScreen();
          }
        });
      }
    }
  }

  /// validate fields
  bool checkForValidateField() {
    bool validateCardNumberField =
        _cardNumber.isNotEmpty && _cardNumber.length >= 19;

    if (!validateCardNumberField) {
      expiryError.value = "Please enter valid card number";
      return false;
    }

    bool _validExpiry = _cardExpiryDate.isNotEmpty &&
        _cardExpiryDate.length == 5 &&
        validExpiry();

    if (!_validExpiry) {
      expiryError.value = "Please enter valid expiry date";
      return false;
    }

    bool _validCVV = (_cardCVV.isNotEmpty && _cardCVV.length == 3);

    if (!_validCVV) {
      expiryError.value = "Please enter valid cvv";
      return false;
    }
    return true;
  }

  /// Clear all fields.
  void _clearFieldErrors() {
    nameError.value = "";
    numberError.value = "";
    expiryError.value = "";
    cvvError.value = "";
  }

  /// Clear fields.
  void _clearFields() {
    _clearFieldErrors();
    nameTextEditingController.clear();
    expDateTextEditingController.clear();
    cardNumberTextEditingController.clear();
    cvvTextEditingController.clear();

    FocusScope.of(Get.context!).unfocus();
  }

  /// login API.
  void savePaymentDetail() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showGlobalLoading();
      dio.Response? response = await _provider.addPaymentDetail();
      if (response != null) {
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _addCardSuccess(response);
        } else {
          /// On Error
          _addCardError(response);
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

  /// Perform login api success
  void _addCardSuccess(dio.Response response) {
    hideGlobalLoading();
    _clearFields();
    if (saveCard.value) {
      CommonUtils.showSuccessSnackBar(message: AppString.addCardSuccessMessage);
      Future.delayed(const Duration(seconds: 2), () {});
    } else {}
    _navigateToNextScreen();
  }

  /// Perform api error.
  void _addCardError(dio.Response response) {
    hideGlobalLoading();
    _clearFields();

    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }

  /// Go to dashboard
  void _navigateToNextScreen() {
    if (addCardTypeEnum == AddCardTypeEnum.ADD_CARD_AND_SUBSCRIBE) {
      final PaymentMethodController controller =
          Get.find(tag: Routes.PAYMENT_METHOD);

      final cardType = getCardTypeFromCardNumber();
      PaymentMethodModel cardModel =
          PaymentMethodModel.selected(cardType, _cardNumber);
      controller.addNewCardAndSelect(cardModel);

      Get.until((route) => route.settings.name == Routes.PAYMENT_METHOD);
    }
  }

  /// Returns true when expiry month is greater then current month and between 1 to 12 and
  /// also year should be greater then current year
  ///
  ///``````dart
  /// addCardViewModel.expiryDate = 11/22;
  /// final expiryMonth = addCardViewModel.expiryDate.split("/")[0]; => 11
  /// final expiryYear = addCardViewModel.expiryDate.split("/")[1];  => 22
  ///
  /// ```````
  /// After extracting values, validate month and year
  ///
  /// [validYear] returns true when expiryYear is greater then current year.
  /// DateTime returns 2022 in [now.year.toString()] but we need 22 so need to get last 2 characters by currentYear.substring(2, 3).
  /// Now it will return 22
  ///
  /// [validMonth] returns true when month between 1 to 12 and greater then current month.
  ///
  /// returns true when [validYear],[validMonth] both true
  bool validExpiry() {
    final expiryMonth = _cardExpiryDate.split("/")[0];
    final expiryYear = _cardExpiryDate.split("/")[1];
    DateTime now = DateTime.now();
    String currentYear = now.year.toString();
    final validYear =
        int.parse(expiryYear) >= int.parse(currentYear.substring(2, 4));
    final validMonth = int.parse(expiryYear) ==
            int.parse(currentYear.substring(2, 4))
        ? (int.parse(expiryMonth) >= now.month) && int.parse(expiryMonth) <= 12
        : int.parse(expiryMonth) <= 12;
    return validYear && validMonth;
  }

  /// Returns cardType enum from card number
  String getCardTypeFromCardNumber() {
    CardTypeEnum _cardType = getCardTypeEnum();
    switch (_cardType) {
      case CardTypeEnum.Maestro:
        return AppString.mestroCard;
      case CardTypeEnum.MasterCard:
        return AppString.masterCard;
      case CardTypeEnum.Rupey:
        return AppString.rupayCard;
      case CardTypeEnum.Visa:
        return AppString.visaCard;
      default:
        return AppString.otherCard;
    }
  }
  CardTypeEnum getCardTypeEnum() => CardUtils.instance
      .detectCardType(_cardNumber.replaceAll(new RegExp(' '), ''));
}

enum AddCardTypeEnum { SAVE_CARD, ADD_CARD_AND_SUBSCRIBE }
