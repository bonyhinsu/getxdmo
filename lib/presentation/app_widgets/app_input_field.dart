import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:game_on_flutter/values/app_colors.dart';
import 'package:game_on_flutter/values/app_icons.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:game_on_flutter/values/app_values.dart';

import 'app_textfield.dart';
import 'form_validation_mixin.dart';

class AppInputField extends StatefulWidget {
  String label;
  String hintText;
  bool isMandatory;
  bool isFocused = false;
  bool isPlainText = false;
  bool isPhoneNumber = false;
  bool isEmail = false;
  bool isPassword = false;
  bool isPasswordNotVisible = true;
  bool denySpaces = false;
  bool enablePasswordToggle = false;
  bool enableEmail = true;
  bool isLastField = false;
  bool isMultiLine = false;
  bool isCapWords = false;
  bool isCardNumber = false;
  bool isCVV = false;
  bool digitalInputRequired = false;
  bool isExpiryDate = false;
  bool fromBottomSheet = false;
  bool skipPasswordSpecialValidation = false;
  bool ignoreTopPadding = false;
  int? maxLength;
  TextEditingController controller;
  FocusNode focusNode;
  String errorText;
  dynamic validator;
  dynamic contentPadding;
  Function(String value)? onChange;
  Function()? onKeyPressed;
  Function()? onTap;
  Function()? onTapOutside;
  Function(String value)? onSubmit;

  AppInputField({
    required this.label,
    required this.controller,
    required this.focusNode,
    this.onChange,
    this.validator,
    this.onTap,
    this.onKeyPressed,
    this.hintText = "",
    this.onSubmit,
    this.onTapOutside,
    this.maxLength,
    this.contentPadding,
    this.isMandatory = false,
    this.fromBottomSheet = false,
    this.isPassword = false,
    this.isPhoneNumber = false,
    this.isCapWords = false,
    this.isEmail = false,
    this.isPlainText = false,
    this.denySpaces = false,
    this.enablePasswordToggle = false,
    this.enableEmail = true,
    this.digitalInputRequired = false,
    this.isLastField = false,
    this.isMultiLine = false,
    this.isCardNumber = false,
    this.skipPasswordSpecialValidation = false,
    this.ignoreTopPadding = false,
    this.isCVV = false,
    this.isExpiryDate = false,
    this.errorText = '',
    Key? key,
  }) : super(key: key);

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField>
    with FormValidationMixin {
  late TextTheme textTheme;

  @override
  void initState() {
    widget.focusNode.addListener(() {
      setState(() {
        widget.isFocused = widget.focusNode.hasFocus;
      });
    });

    if (widget.enablePasswordToggle) {
      widget.isPasswordNotVisible = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.only(
        top: widget.ignoreTopPadding?0:AppValues.margin_20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildRichTextWidget(),
          const SizedBox(
            height: AppValues.margin_10,
          ),
          !widget.isMultiLine ? buildInputField() : buildMultilineInputField(),
        ],
      ),
    );
  }

  /// Widget build Text widget
  Widget buildRichTextWidget() {
    return EasyRichText(
      "${widget.label}${widget.isMandatory ? '*' : ''}",
      patternList: [
        EasyRichTextPattern(
          targetString: '(\\*)',
          matchLeftWordBoundary: false,
          style: textTheme.displayLarge?.copyWith(
            color: AppColors.errorColor,
          ),
        ),
      ],
      defaultStyle: textTheme.displayLarge
          ?.copyWith(color: AppColors.textColorPrimary,fontSize: 15),
    );
  }

  /// Build input field.
  Widget buildInputField() {
    return AppTextField.underLineTextField(
      context: context,
      enabled: widget.enableEmail,
      contentPadding:
          widget.contentPadding ?? const EdgeInsets.symmetric(vertical: 16.0),
      isFocused: widget.isFocused,
      errorText: widget.errorText,
      label: widget.label,
      capsText: widget.isCapWords,
      hintText: widget.hintText,
      onFieldSubmitted: widget.onSubmit,
      onTapOutside: widget.onTapOutside,
      fromBottomSheet: widget.fromBottomSheet,
      hintColor: widget.fromBottomSheet
          ? AppColors.textColorDarkGray
          : AppColors.inputFieldBorderColor,
      onTap: widget.onTap,
      inputFormator: [
        if (widget.denySpaces) FilteringTextInputFormatter.deny(RegExp(r'\s')),
        if (widget.isPhoneNumber || widget.digitalInputRequired)
          FilteringTextInputFormatter.digitsOnly,
      ],
      keyboardType: (widget.digitalInputRequired || widget.isPhoneNumber)
          ? TextInputType.number
          : widget.isEmail
              ? TextInputType.emailAddress
              : TextInputType.text,
      validator: (value) {
        if (widget.isMandatory) {
          if (value == null || value.isEmpty) {
            widget.focusNode.requestFocus();
            return AppString.fieldDoesNotEmptyMessage;
          }

          if (widget.isEmail) {
            final isValidEmail = validEmail(value);
            if (!isValidEmail) {
              widget.focusNode.requestFocus();
            }
            return !isValidEmail
                ? AppString.pleaseEnterValidEmailAddress
                : null;
          }

          if (widget.isPassword && !widget.skipPasswordSpecialValidation) {
            final isValidPassword = validPassword(value);
            if (!isValidPassword) {
              widget.focusNode.requestFocus();
            }
            return !isValidPassword ? AppString.invalidPasswordMessage : null;
          }

          if (widget.isPhoneNumber) {
            final isValidNumber = validNumberField(value);
            if (!isValidNumber) {
              widget.focusNode.requestFocus();
            }
            return !isValidNumber
                ? AppString.pleaseEnterValidPhoneNumber
                : null;
          }
        }
        return null;
      },
      isObscureText: widget.enablePasswordToggle
          ? widget.isPasswordNotVisible
          : widget.isPassword &&
              (widget.isPasswordNotVisible || !widget.enablePasswordToggle),
      suffixIcon: widget.enablePasswordToggle
          ? GestureDetector(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: widget.isPasswordNotVisible
                    ? SvgPicture.asset(
                        AppIcons.iconPasswordOff,
                        height: 12,
                        width: 12,
                      )
                    : SvgPicture.asset(
                        AppIcons.iconPasswordOn,
                        height: 12,
                        width: 12,
                      ),
              ),
              onTap: () {
                setState(() {
                  widget.focusNode.requestFocus();
                  widget.isPasswordNotVisible = !widget.isPasswordNotVisible;
                });
              },
            )
          : null,
      isTextInputActionDone: widget.isLastField,
      maxLength: widget.maxLength ??
          (widget.isPhoneNumber
              ? AppValues.phoneMaxLength
              : AppValues.textFieldMaxLength),
      hasError: widget.errorText.isNotEmpty,
      controller: widget.controller,
      onTextChange: widget.onChange,

      focusNode: widget.focusNode,
    );
  }

  /// Build input field.
  Widget buildMultilineInputField() {
    return AppTextField.multilineTextField(
      context: context,
      multilineWidgetHeight: 80,
      enabled: widget.enableEmail,
      minLines: 3,
      isTextInputActionDone: widget.isLastField,
      contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
      isFocused: widget.isFocused,
      errorText: widget.errorText,
      label: widget.label,
      hintText: widget.hintText,
      hintColor: AppColors.inputFieldBorderColor,
      capsText: true,
      inputFormator: [
        if (widget.denySpaces) FilteringTextInputFormatter.deny(RegExp(r'\s')),
      ],
      keyboardType: TextInputType.multiline,
      maxLines: 4,
      validator: (val) {},
      maxLength: AppValues.multilineLength,
      hasError: widget.errorText.isNotEmpty,
      controller: widget.controller,
      onTextChange: widget.onChange,
      focusNode: widget.focusNode,
    );
  }
}
