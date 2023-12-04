import 'package:flutter/material.dart';
import 'package:game_on_flutter/values/app_colors.dart';
import 'package:game_on_flutter/values/app_values.dart';

class AppTextField {
  static Widget underLineTextField({
    required BuildContext context,
    label,
    FocusNode? focusNode,
    onFieldSubmitted,
    validator,
    onEditComplete,
    onTapOutside,
    onTextChange,
    onSaved,
    keyboardType,
    Color? hintColor,
    bool isTextInputActionDone = false,
    bool isTextInputActionSearch = false,
    bool isTextInputActionEnter = false,
    bool isObscureText = false,
    bool alignLabelWithHint = false,
    bool hasError = false,
    TextEditingController? controller,
    maxLength,
    bool fromBottomSheet = false,
    iconConstraints,
    capsText = false,
    allCaps = false,
    isFocused = false,
    inputFormator,
    bool enabled = true,
    bool enabledWithTapOnly = false,
    Iterable<String>? autofillHints,
    String? hintText,
    String? errorText,
    String? infoText,
    Widget? suffixIcon,
    Widget? prefixIcon,
    Widget? suffix,
    Widget? prefix,
    Color? backgroundColor,
    EdgeInsets? contentPadding,
    int? maxLines = 1,
    int? minLines = 1,
    double multilineWidgetHeight = 120,
    bool filled = false,
    bool enableFocusBorder = true,
    bool countryCodeEnabled = false,
    Color filledColor = AppColors.textFieldBackgroundColor,
    onTap,
  }) {
    final textStyle = Theme.of(context).textTheme;
    final textInputTextStyle = textStyle.displaySmall;
    const textfieldCornerRadius = 8.0;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: GestureDetector(
              onTap: (enabledWithTapOnly && onTap != null) ? onTap : null,
              child: TextFormField(
                style: textInputTextStyle!.merge(TextStyle(
                  fontSize: 13,
                  color: fromBottomSheet
                      ? AppColors.bottomSheetTextColor
                      : AppColors.textColorPrimary.withOpacity(0.80),
                )),
                onTap: () {
                  if (onTap != null) {
                    onTap();
                  }
                },
                onTapOutside:(event)=> onTapOutside,
                textAlignVertical: TextAlignVertical.center,
                maxLines: maxLines,
                enabled: enabled ?? true,
                controller: controller,
                onChanged: (value) {
                  if (onTextChange != null) {
                    onTextChange(value);
                  }
                },
                inputFormatters: inputFormator ?? [],
                enableSuggestions: true,
                autocorrect: false,
                readOnly: enabledWithTapOnly,
                textCapitalization: allCaps
                    ? TextCapitalization.characters
                    : capsText
                        ? TextCapitalization.words
                        : TextCapitalization.none,
                obscureText: isObscureText,
                validator: (value) => validator(value),
                focusNode: focusNode ?? FocusNode(),
                maxLength: maxLength,
                minLines: minLines,
                keyboardType: keyboardType,
                cursorColor: AppColors.textColorLightTheme,
                onFieldSubmitted: onFieldSubmitted,
                textInputAction: isTextInputActionDone
                    ? TextInputAction.done
                    : isTextInputActionEnter
                        ? TextInputAction.newline
                        : isTextInputActionSearch
                            ? TextInputAction.search
                            : TextInputAction.next,
                onEditingComplete: onEditComplete,
                autofillHints: autofillHints,
                onSaved: (value) {
                  if (onSaved != null) {
                    onSaved(value);
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  errorStyle: const TextStyle(
                    fontSize: AppValues.margin_12,
                  ),
                  prefixIcon: prefixIcon,
                  prefixIconColor: AppColors.textColorLightTheme,
                  // prefixIconConstraints: iconConstraints,
                  fillColor: backgroundColor ?? AppColors.appTileBackground,
                  counterText: "",
                  errorMaxLines: 5,
                  prefixIconConstraints: const BoxConstraints(
                    minHeight: 36,
                  ),
                  alignLabelWithHint: alignLabelWithHint,
                  contentPadding: contentPadding ??
                      const EdgeInsets.only(
                          right: 16.0, top: 16.0, bottom: 16.0),
                  suffixIcon: suffixIcon,
                  suffix: suffix,
                  suffixIconColor: AppColors.textColorLightTheme,
                  prefix: prefix != null
                      ? Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: prefix,
                        )
                      : const Padding(
                          padding: EdgeInsets.only(left: 16.0),
                        ),
                  suffixIconConstraints: iconConstraints,
                  isDense: true,
                  errorText: (errorText ?? "").isNotEmpty ? errorText : null,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: hintText,
                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 0, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(textfieldCornerRadius),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.solid,
                        color: Colors.transparent),
                    borderRadius: BorderRadius.circular(textfieldCornerRadius),
                  ),
                  focusedBorder: !enableFocusBorder
                      ? InputBorder.none
                      : OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(textfieldCornerRadius),
                          borderSide: const BorderSide(
                              width: 1,
                              style: BorderStyle.solid,
                              color: Colors.grey),
                        ),
                  hintStyle: textInputTextStyle.copyWith(
                    color: AppColors.textColorLightTheme,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: (infoText ?? "").isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: hasError && (controller?.text ?? "").isNotEmpty
                  ? Text(
                      '$infoText',
                      style: textInputTextStyle.copyWith(
                          color: Colors.red, fontWeight: FontWeight.w400),
                    )
                  : Text('$infoText',
                      style: textInputTextStyle.copyWith(
                          color: AppColors.textPlaceholderColor,
                          fontWeight: FontWeight.w400)),
            ),
          ),
        ],
      ),
    );
  }

  static Widget multilineTextField({
    required BuildContext context,
    label,
    FocusNode? focusNode,
    onFieldSubmitted,
    validator,
    onEditComplete,
    onTextChange,
    onSaved,
    keyboardType,
    bool isTextInputActionDone = false,
    bool isTextInputActionEnter = false,
    bool isObscureText = false,
    bool alignLabelWithHint = false,
    bool hasError = false,
    TextEditingController? controller,
    maxLength,
    iconConstraints,
    capsText = false,
    allCaps = false,
    isFocused = false,
    inputFormator,
    enabled,
    Iterable<String>? autofillHints,
    String? hintText,
    String? errorText,
    Widget? suffixIcon,
    Widget? prefixIcon,
    Widget? suffix,
    Color? hintColor,
    EdgeInsets? contentPadding,
    int? maxLines = 1,
    int? minLines = 1,
    double multilineWidgetHeight = 100,
    bool filled = false,
    bool enableFocusBorder = true,
    Color? backgroundColor,
    bool countryCodeEnabled = false,
    Color filledColor = AppColors.textFieldBackgroundColor,
    onTap,
  }) {
    const textfieldCornerRadius = 8.0;
    final textStyle = Theme.of(context).textTheme;
    final textInputTextStyle = textStyle.displaySmall;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            style: textInputTextStyle!.merge( TextStyle(
              fontSize: 13,
              color: AppColors.textColorPrimary.withOpacity(0.80),
            )),
            onTap: () {
              if (onTap != null) {
                onTap();
              }
            },
            textAlignVertical: TextAlignVertical.center,
            maxLines: maxLines,
            enabled: enabled ?? true,
            controller: controller,
            onChanged: (value) {
              if (onTextChange != null) {
                onTextChange(value);
              }
            },
            inputFormatters: inputFormator ?? [],
            enableSuggestions: false,
            autocorrect: false,
            textCapitalization: TextCapitalization.sentences,
            obscureText: isObscureText,
            validator: (value) => validator(value),
            focusNode: focusNode ?? FocusNode(),
            maxLength: maxLength,
            minLines: minLines,
            keyboardType: keyboardType,
            cursorColor: AppColors.textColorLightTheme,
            onFieldSubmitted: onFieldSubmitted,
            textInputAction: isTextInputActionDone
                ? TextInputAction.done
                : isTextInputActionEnter
                    ? TextInputAction.newline
                    : TextInputAction.next,
            onEditingComplete: onEditComplete,
            autofillHints: autofillHints,
            onSaved: (value) {
              if (onSaved != null) {
                onSaved(value);
              }
            },
            decoration: InputDecoration(
                errorStyle: const TextStyle(
                  fontSize: AppValues.margin_12,
                ),
                filled: true,
                fillColor:
                    backgroundColor ?? AppColors.appTileBackground,
                counterText: "",
                errorMaxLines: 5,
                prefixIcon: prefixIcon,
                prefixIconColor: AppColors.textColorLightTheme,
                prefixIconConstraints: iconConstraints,
                alignLabelWithHint: alignLabelWithHint,
                contentPadding: const EdgeInsets.all(16.0),
                suffixIcon: suffixIcon,
                suffix: suffix,
                suffixIconColor: AppColors.textColorLightTheme,
                suffixIconConstraints: iconConstraints,
                isDense: true,
                hintText: hintText,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.solid,
                      color: Colors.transparent),
                  borderRadius: BorderRadius.circular(textfieldCornerRadius),
                ),
                border: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 0, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(textfieldCornerRadius),
                ),
                focusedBorder: !enableFocusBorder
                    ? InputBorder.none
                    : OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(textfieldCornerRadius),
                        borderSide: const BorderSide(
                            width: 1,
                            style: BorderStyle.solid,
                            color: Colors.grey),
                      ),
                hintStyle: Theme.of(context).textTheme.displaySmall!.merge(
                    TextStyle(
                        color: hintColor ??
                            (focusNode!.hasFocus
                                ? AppColors.textColorLightTheme
                                : AppColors.textPlaceholderColor))),
                labelStyle: Theme.of(context).textTheme.caption!.copyWith(
                    color: AppColors.textColorLightTheme,
                    fontWeight: FontWeight.w600)),
          ),
          Visibility(
            visible: (errorText ?? "").isNotEmpty,
            child: Text(
              '$errorText',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: AppColors.errorColor),
            ),
          ),
        ],
      ),
    );
  }
}
