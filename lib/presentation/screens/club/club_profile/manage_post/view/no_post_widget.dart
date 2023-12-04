import 'package:flutter/material.dart';
import 'package:game_on_flutter/values/app_string.dart';

class NoPostWidget extends StatelessWidget {
  const NoPostWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(AppString.noPlayerFound),);
  }
}
