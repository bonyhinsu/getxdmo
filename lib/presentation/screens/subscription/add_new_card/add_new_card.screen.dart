import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_on_flutter/infrastructure/utils/ExpiryDateFormator.dart';
import 'package:game_on_flutter/presentation/app_widgets/user_feature_mixin.dart';
import 'package:get/get.dart';

import '../../../../infrastructure/navigation/routes.dart';
import '../../../../infrastructure/utils/card_number_input_formator.dart';
import '../../../../infrastructure/utils/card_utils.dart';
import '../../../../values/app_colors.dart';
import '../../../../values/app_string.dart';
import '../../../../values/app_values.dart';
import '../../../app_widgets/app_button_mixin.dart';
import '../../../app_widgets/app_input_field.dart';
import '../../../app_widgets/app_text_mixin.dart';
import '../../../app_widgets/app_textfield.dart';
import '../../../app_widgets/base_view.dart';
import 'controllers/add_new_card.controller.dart';

class AddNewCardScreen extends GetView<AddNewCardController>
    with AppBarMixin, AppButtonMixin, AppTextMixin, UserFeatureMixin {
  AddNewCardScreen({Key? key}) : super(key: key);

  final AddNewCardController _controller = Get.find(tag: Routes.ADD_NEW_CARD);

  late TextTheme textTheme;
  late BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: buildAppBar(
          title: AppString.addNewCard,
        ),
        body: SafeArea(
          child: Obx(() => buildBody(context)),
        ),
      ),
    );
  }

  /// Widget build body.
  Widget buildBody(BuildContext context) => Form(
        key: _controller.formKey,
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppValues.screenMargin),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: AppValues.screenMargin,
                      color: AppColors.pageBackground,
                    ),
                    buildNameField,
                    buildCardNumberTextField(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: buildCardExpiryRow()),
                        const SizedBox(
                          width: AppValues.height_20,
                        ),
                        Expanded(child: buildCardCVVRow()),
                      ],
                    ),
                    buildSaveCardCheckbox()
                  ],
                ),
              ),
                appWhiteButton(
                    title: AppString.addCard,
                    isValidate: _controller.validFields.value,
                    onClick: () => _controller.onSubmit()),
              const SizedBox(
                height: AppValues.screenMargin,
              ),
            ],
          ),
        ),
      );

  /// Build name text field
  Widget get buildNameField => AppInputField(
        label: AppString.name,
        controller: _controller.nameTextEditingController,
        focusNode: _controller.nameFocusNode,
        errorText: _controller.nameError.value,
        isMandatory: true,
        isCapWords: true,
        onChange: _controller.setCardName,
      );

  /// Build card number field.
  Widget get buildCardNumberField => AppInputField(
        label: AppString.strCardNumber,
        controller: _controller.cardNumberTextEditingController,
        focusNode: _controller.cardNumberFocusNode,
        errorText: _controller.numberError.value,
        isMandatory: true,
        onChange: _controller.setCardNumber,
      );

  /// Build expiry date text field.
  Widget get buildCardExpiry => AppInputField(
        label: AppString.strExpDate,
        isEmail: true,
        controller: _controller.expDateTextEditingController,
        focusNode: _controller.expDateFocusNode,
        errorText: _controller.expiryError.value,
        isMandatory: true,
        denySpaces: true,
        onChange: _controller.setCardExpiry,
      );

  /// Build CVV text field.
  Widget get buildCardCVV => AppInputField(
        label: AppString.strCVV,
        isEmail: true,
        controller: _controller.cvvTextEditingController,
        focusNode: _controller.cvvFocusNode,
        errorText: _controller.cvvError.value,
        isMandatory: true,
        denySpaces: true,
        onChange: _controller.setCardCVV,
      );

  Widget buildCardNumberTextField() {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppValues.margin_20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildRichTextWidget(text: AppString.strCardNumber),
          const SizedBox(
            height: AppValues.margin_10,
          ),
          buildCardNumberInputField()
        ],
      ),
    );
  }

  /// Build card expiry row widget
  Widget buildCardExpiryRow() {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppValues.margin_20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildRichTextWidget(text: AppString.strExpDate),
          const SizedBox(
            height: AppValues.margin_10,
          ),
          buildCardExpiryDateInputField()
        ],
      ),
    );
  }

  /// Build card cvv row widget
  Widget buildCardCVVRow() {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppValues.margin_20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildRichTextWidget(text: AppString.strCVV),
          const SizedBox(
            height: AppValues.margin_10,
          ),
          buildCardCVVInputField()
        ],
      ),
    );
  }

  /// Build card number input field.
  Widget buildCardNumberInputField() {
    return AppTextField.underLineTextField(
      context: buildContext,
      contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
      isFocused: _controller.cardNumberFocusNode.hasFocus,
      errorText: _controller.numberError.value,
      inputFormator: [
        FilteringTextInputFormatter.digitsOnly,
        CardNumberInputFormator(),
      ],
      suffixIcon: Container(
        padding: const EdgeInsets.all(AppValues.smallPadding),
        height: AppValues.size_30,
        child: CardUtils.instance.getCardIcon(_controller.getCardTypeEnum()),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppString.fieldDoesNotEmptyMessage;
        }
        return null;
      },
      maxLength: AppValues.paymentCardNumberMaxLength,
      hasError: _controller.numberError.value.isNotEmpty,
      controller: _controller.cardNumberTextEditingController,
      onTextChange: _controller.setCardNumber,
      focusNode: _controller.cardNumberFocusNode,
    );
  }

  /// Build card expiry input field.
  Widget buildCardExpiryDateInputField() {
    return AppTextField.underLineTextField(
      context: buildContext,
      hintColor: AppColors.inputFieldBorderColor,
      contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
      isFocused: _controller.expDateFocusNode.hasFocus,
      errorText: _controller.expiryError.value,
      inputFormator: [
        FilteringTextInputFormatter.digitsOnly,
        ExpiryInputFormator(),
      ],
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppString.fieldDoesNotEmptyMessage;
        }
        return null;
      },
      maxLength: AppValues.paymentCardExpiryMaxLength,
      hasError: _controller.expiryError.value.isNotEmpty,
      controller: _controller.expDateTextEditingController,
      onTextChange: _controller.setCardExpiry,
      focusNode: _controller.expDateFocusNode,
    );
  }

  /// Build card cvv input field.
  Widget buildCardCVVInputField() {
    return AppTextField.underLineTextField(
      context: buildContext,
      hintColor: AppColors.inputFieldBorderColor,
      contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
      isFocused: _controller.cvvFocusNode.hasFocus,
      errorText: _controller.cvvError.value,
      inputFormator: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppString.fieldDoesNotEmptyMessage;
        }
        return null;
      },
      isObscureText: true,
      isTextInputActionDone: true,
      maxLength: AppValues.paymentCVVMaxLength,
      hasError: _controller.cvvError.value.isNotEmpty,
      controller: _controller.cvvTextEditingController,
      onTextChange: _controller.setCardCVV,
      focusNode: _controller.cvvFocusNode,
    );
  }

  /// Build save card checkbox.
  Widget buildSaveCardCheckbox() {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppValues.margin_20,
      ),
      child: Row(
        children: [
          Theme(
            data: Theme.of(buildContext).copyWith(
              unselectedWidgetColor: AppColors.textFieldBackgroundColor,
            ),
            child: SizedBox(
              height: AppValues.iconSize_24,
              width: AppValues.iconSize_24,
              child: Checkbox(
                checkColor: AppColors.appRedButtonColor,
                activeColor: AppColors.textFieldBackgroundColor,
                materialTapTargetSize: MaterialTapTargetSize.padded,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(3))),
                value: _controller.saveCard.value,
                onChanged: (newValue) {
                  _controller.saveCard.value = (newValue ?? true);
                },
              ),
            ),
          ),
          const SizedBox(
            width: 8.0,
          ),
          Text(AppString.saveCard,
              style: textTheme.displaySmall
                  ?.copyWith(color: AppColors.textColorPrimary)),
        ],
      ),
    );
  }

  /// Widget build Text widget
  Widget buildRichTextWidget({required String text}) {
    return EasyRichText(
      "$text*",
      patternList: [
        EasyRichTextPattern(
          targetString: '(\\*)',
          matchLeftWordBoundary: false,
          style: textTheme.displayLarge?.copyWith(
            color: AppColors.errorColor,
          ),
        ),
      ],
      defaultStyle: textTheme.displayLarge,
    );
  }
}
