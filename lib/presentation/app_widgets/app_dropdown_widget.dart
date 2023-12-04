import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:game_on_flutter/values/app_colors.dart';
import 'package:game_on_flutter/values/app_values.dart';

class AppDropdownWidget extends StatelessWidget {
  List<String> items;
  Function(String selectedItem) onItemChanged;
  String selectedItem;
  bool fromBottomSheet;

  AppDropdownWidget(
      {required this.items,
      required this.onItemChanged,
      required this.selectedItem,
      this.fromBottomSheet = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ClipRRect(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      borderRadius: BorderRadius.circular(AppValues.smallRadius),
      child: DropdownSearch<String>(
        popupProps: PopupProps.menu(
            showSelectedItems: true,
            fit: FlexFit.loose,
            itemBuilder: _customDropdownItemBuilder,
            menuProps: MenuProps(
              backgroundColor: fromBottomSheet
                  ? AppColors.bottomSheetInputBackground
                  : AppColors.bottomSheetBackground,
            )),
        items: items,
        dropdownBuilder: (ctx, item) {
          return Text(
            item ?? "",
            style: textTheme.displaySmall?.copyWith(
                color: fromBottomSheet
                    ? AppColors.bottomSheetTextColor
                    : AppColors.textColorSecondary.withOpacity(0.5)),
            overflow: TextOverflow.ellipsis,
          );
        },
        dropdownDecoratorProps: DropDownDecoratorProps(
          baseStyle: textTheme.displaySmall,
          textAlignVertical: TextAlignVertical.center,
          dropdownSearchDecoration: InputDecoration(
            filled: true,
            border: InputBorder.none,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            suffixIcon: null,
            fillColor: fromBottomSheet
                ? AppColors.appTileBackground
                : AppColors.textFieldBackgroundColor,
          ),
        ),
        dropdownButtonProps: const DropdownButtonProps(
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          alignment: Alignment.center,
          icon: RotatedBox(
            quarterTurns: 3,
            child: Icon(
              Icons.arrow_back_ios,
              size: 15,
            ),
          ),
        ),
        onChanged: (value) {
          selectedItem = value as String;
          onItemChanged(selectedItem);
        },
        selectedItem: selectedItem,
      ),
    );

    /* DropdownSearch<String>.multiSelection(
      items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
      popupProps: PopupPropsMultiSelection.menu(
        showSelectedItems: true,
        disabledItemFn: (String s) => s.startsWith('I'),
      ),
      onChanged: print,
      selectedItems: ["Brazil"],
    );
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        items: items
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: textTheme.displaySmall?.copyWith(
                        color: fromBottomSheet
                            ? AppColors.bottomSheetTextColor
                            : AppColors.textColorSecondary.withOpacity(0.5)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        value: selectedItem,
        onChanged: (value) {
          selectedItem = value as String;
          onItemChanged(selectedItem);
        },
        buttonStyleData: ButtonStyleData(
          height: 46,
          padding: const EdgeInsets.only(left: 4, right: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppValues.smallRadius),
            color: fromBottomSheet
                ? AppColors.bottomSheetInputBackground
                : AppColors.appTileBackground,
          ),
          elevation: 0,
        ),
        iconStyleData: const IconStyleData(
          icon: RotatedBox(
            quarterTurns: 3,
            child: Icon(
              Icons.arrow_back_ios,
            ),
          ),
          iconSize: 14,
          iconEnabledColor: AppColors.appWhiteButtonColor,
          iconDisabledColor: Colors.grey,
        ),
        dropdownStyleData: DropdownStyleData(
          padding: null,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppValues.smallRadius),
            color: AppColors.appTileBackground,
          ),
          elevation: 0,
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all<double>(6),
            thumbVisibility: MaterialStateProperty.all<bool>(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );*/
  }
}

Widget _customDropdownItemBuilder(
    BuildContext context, String item, bool isSelected) {
  return ListTile(
    selected: isSelected,
    contentPadding: const EdgeInsets.symmetric(horizontal: AppValues.margin_12),
    title: Text(
      item,
      style: Theme.of(context).textTheme.displaySmall?.copyWith(
          color: isSelected
              ? AppColors.appWhiteButtonColor
              : AppColors.textColorTernary),
    ),
  );
}
