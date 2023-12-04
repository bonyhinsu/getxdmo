import 'package:flutter/material.dart';
import 'package:game_on_flutter/presentation/app_widgets/base_bottomsheet.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:game_on_flutter/values/app_values.dart';
import 'package:get/get.dart';

import '../../../../../infrastructure/model/club/post/create_post_menu_model.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../values/app_colors.dart';
import '../controllers/create_post_bottomsheet_controller.dart';

class CreatePostBottomsheet extends StatelessWidget {
  CreatePostBottomsheet({Key? key}) : super(key: key);

  final CreatePostBottomsheetController _controller = Get.find(tag: Routes.CREATE_POST);

  late TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return BaseBottomsheet(
        title: AppString.strCreateAPost,
        skipHorizontalPadding: true,
        child: buildBottomSheetBody());
  }

  /// Build bottomsheet body
  Widget buildBottomSheetBody() => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      ListView.separated(
            itemCount: _controller.createPostMenuList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) =>
                buildListTileWidget(_controller.createPostMenuList[index]),
            separatorBuilder: (BuildContext context, int index) => buildDivider,
          ),
      const SizedBox(height: AppValues.screenMargin,)
    ],
  );

  /// Build list item widget
  Widget buildListTileWidget(CreatePostMenuModel model) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: AppValues.margin_24),
        onTap: () => _controller.onClickMenu(model),
        title: Text(model.title,style: textTheme.labelMedium,),
      );

  Widget get buildDivider => const Divider(
    height: 1,
    color: AppColors.appWhiteButtonColorDisable,
  );
}
