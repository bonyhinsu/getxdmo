import 'package:flutter/material.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_button_mixin.dart';
import 'package:game_on_flutter/presentation/app_widgets/user_feature_mixin.dart';
import 'package:game_on_flutter/values/app_colors.dart';
import 'package:game_on_flutter/values/app_values.dart';

class FollowUserWidget extends StatelessWidget with AppButtonMixin {

  String userName;
  Function() onFollowClick;
  FollowUserWidget({this.userName='', required this.onFollowClick,Key? key}) : super(key: key);

  late TextTheme textTheme;
  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppValues.screenMargin,vertical: AppValues.margin),
      decoration: const BoxDecoration(
          color: AppColors.appTileBackground,
         ),
      child: Column(
        children: [
          Text('Follow $userName?', style: textTheme.bodyLarge,),
          const SizedBox(height: 20,),
          Text('You are not following $userName. Please follow them first then start conversation with them.',style: textTheme.displaySmall,),
          const SizedBox(height: 20,),
          SizedBox(
              width: 140,
              child: appRedSecondaryButton( title: 'Follow', onClick: ()=> onFollowClick()))
        ],
      ),
    );
  }
}
