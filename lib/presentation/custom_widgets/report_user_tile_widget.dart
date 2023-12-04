import 'package:flutter/material.dart';

import '../../infrastructure/model/common/report_user_list_response.dart';
import '../app_widgets/app_checkbox_widget.dart';

class ReportUserTileWidget extends StatelessWidget {
  ReportUserListResponseData model;
  int index;
  bool isSelected;
  Function(int index) onSelect;

  ReportUserTileWidget(
      {required this.model,
      required this.index,
      required this.isSelected,
      required this.onSelect,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap:(){
        onSelect(model.id??0);
      } ,
      leading: AppCheckboxWidget(
        isSelected: isSelected,
        onSelected: (checked) {
          onSelect(model.id??0);
        },
      ),
      title: Text(model.name??""),
    );
  }
}
