import 'package:flutter/material.dart';

import '../../infrastructure/model/club/post/post_filter_model.dart';
import '../../values/app_colors.dart';
import '../../values/app_values.dart';

class AppChipListWidget extends StatefulWidget {
  List<PostFilterModel> options;
  List<int> choiceIndex = [];
  bool isWrap = true;
  Function(List<PostFilterModel> updatedList) onChoiceChange;

  AppChipListWidget(
      {required this.options,
      required this.onChoiceChange,
      this.isWrap = true,
      Key? key})
      : super(key: key);

  @override
  State<AppChipListWidget> createState() => _AppChipListWidgetState();
}

class _AppChipListWidgetState extends State<AppChipListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppValues.margin_20),
      child: widget.isWrap
          ? Wrap(
              spacing: AppValues.margin_10,
              children: List.generate(widget.options.length, (index) {
                return buildChip(index);
              }),
            )
          : SizedBox(
              height: 40,
              child: ListView.separated(
                itemCount: widget.options.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (_, index) => buildChip(index),
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(
                  width: AppValues.margin_10,
                ),
              ),
            ),
    );
  }


  Widget buildChip(int index) => ChoiceChip(
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color: widget.options[index].isSelected
                    ? AppColors.choiceSelectedColor
                    : AppColors.choiceUnselectedColor,
                strokeAlign: 0),
            borderRadius: BorderRadius.circular(AppValues.radius_6)),
        labelPadding: const EdgeInsets.all(2.0),
        padding: const EdgeInsets.symmetric(
          horizontal: AppValues.margin_10,
        ),
        label: Text(
          widget.options[index].title ?? "",
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                color: widget.choiceIndex.contains(index)
                    ? AppColors.appRedButtonColor
                    : Colors.white,
              ),
        ),
        selected: widget.options[index].isSelected,
        selectedColor: AppColors.choiceSelectedColor,
        backgroundColor: AppColors.choiceUnselectedColor,
        onSelected: (value) {
          setState(() {
            if (widget.options[index].isSelected) {
              widget.options[index].isSelected = false;
            } else {
              widget.options[index].isSelected = true;
            }
          });
          widget.onChoiceChange(widget.options);
        },
        // backgroundColor: color,
        elevation: 1,
        visualDensity: VisualDensity.comfortable,
      );
}
