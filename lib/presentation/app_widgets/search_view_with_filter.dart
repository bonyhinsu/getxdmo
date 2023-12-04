import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../values/app_colors.dart';
import '../../values/app_icons.dart';
import '../../values/app_string.dart';
import '../../values/app_values.dart';
import 'app_textfield.dart';

class SearchViewWithFilter extends StatelessWidget {
  TextEditingController? textEditingController;
  FocusNode? focusNode;
  String hintMessage = AppString.searchByNameAndLocation;
  String? inputText;

  bool enableSearch;
  bool isFilterApplied;
  bool isSearchApplied;

  Function()? onClearSearch;
  Function() onFilterClick;
  Function()? onSearchClick;
  Function(String text)? onChange;

  SearchViewWithFilter(
      {required this.onFilterClick,
      this.onChange,
      this.onSearchClick,
      this.onClearSearch,
      this.inputText,
      required this.textEditingController,
      required this.focusNode,
      required this.isFilterApplied,
      this.enableSearch = false,
      this.isSearchApplied = false,
      this.hintMessage = AppString.searchByNameAndLocation,
      Key? key})
      : super(key: key);

  late TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return Material(
      type: MaterialType.transparency,
      child: Container(
        color: AppColors.pageBackground,
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppValues.smallRadius),
                color: enableSearch
                    ? Colors.transparent
                    : AppColors.appTileBackground),
            child:
                enableSearch ? buildTextField : buildSearchAreaNonEditable()),
      ),
    );
  }

  /// Build non searchable filter view.
  Widget buildSearchAreaNonEditable() {
    return GestureDetector(
      onTap: onSearchClick,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppValues.smallRadius),
        ),
        padding: const EdgeInsets.only(left: AppValues.margin_15),
        child: Row(
          children: [
            buildSearchIcon(),
            const SizedBox(
              width: 14.0,
            ),
            Expanded(child: buildTextIcon()),
            buildFilterIcon(),
          ],
        ),
      ),
    );
  }

  /// Build search icon
  Widget buildSearchIcon() => SvgPicture.asset(
        AppIcons.searchIcon,
        height: 15,
        width: 15,
      );

  Widget buildClearIcon() => SvgPicture.asset(
        AppIcons.iconClose,
        color: AppColors.textColorDarkGray,
      );

  /// Build filter icon
  Widget buildFilterIcon() => InkWell(
      onTap: () => onFilterClick(),
      child: Container(
          padding: const EdgeInsets.only(
              right: AppValues.padding_16,
              top: AppValues.mediumPadding,
              bottom: AppValues.mediumPadding,
              left: AppValues.padding_16),
          child: Stack(
            children: [
              SvgPicture.asset(AppIcons.filterIcon),
              if (isFilterApplied)
                Positioned(
                    right: 0,
                    child: Container(
                      height: AppValues.height_8,
                      width: AppValues.height_8,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius:
                              BorderRadius.circular(AppValues.smallRadius)),
                    ))
            ],
          )));

  /// Build text icon
  Widget buildTextIcon() => Text(
        inputText ?? AppString.searchByNameAndLocation,
        style: textTheme.displaySmall?.copyWith(
          color: AppColors.textSearch,
        fontSize: 14),
      );

  /// Build club email field.
  Widget get buildTextField => AppTextField.underLineTextField(
        context: Get.context!,
        suffixIcon: buildFilterIcon(),
        hintColor: AppColors.inputFieldBorderColor,
        prefixIcon: InkWell(
          onTap: textEditingController!.text.isNotEmpty ? _onClearSearch : null,
          child: Container(
            padding: const EdgeInsets.only(right: 0, left: AppValues.margin_20),
            child: textEditingController!.text.isEmpty
                ? buildSearchIcon()
                : buildClearIcon(),
          ),
        ),
        hintText: hintMessage,
        keyboardType: TextInputType.text,
        controller: textEditingController,
        onTextChange: onChange,
        focusNode: focusNode,
      );

  /// on clear search
  void _onClearSearch() {
    if (onClearSearch != null) {
      onClearSearch!();
    }
  }
}
