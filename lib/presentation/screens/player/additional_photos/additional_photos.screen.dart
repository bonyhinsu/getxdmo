import 'package:flutter/material.dart';
import 'package:game_on_flutter/values/app_values.dart';
import 'package:get/get.dart';

import '../../../../infrastructure/navigation/routes.dart';
import '../../../../values/app_string.dart';
import '../../../app_widgets/app_button_mixin.dart';
import '../../../app_widgets/base_view.dart';
import '../../../app_widgets/user_feature_mixin.dart';
import '../club_detail/view/image_grid_container.dart';
import 'controllers/additional_photos.controller.dart';

class AdditionalPhotosScreen extends GetView<AdditionalPhotosController>
    with AppBarMixin, AppButtonMixin, UserFeatureMixin {
  AdditionalPhotosScreen({Key? key}) : super(key: key);

  final AdditionalPhotosController _controller =
      Get.find(tag: Routes.ADDITIONAL_PHOTOS);

  late TextTheme textTheme;
  late BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    buildContext = context;
    return Scaffold(
      appBar: buildAppBar(
          title: AppString.additionalPhotos,
          onBackClick: _controller.onBackPressed),
      body: buildBody(),
    );
  }

  /// Build body widget.
  Widget buildBody() => Padding(
        padding: const EdgeInsets.all(AppValues.height_16),
        child: ImageGridContainer(
          onImageViewAll: () {},
          images: _controller.images ?? [], onClick: _controller.onImageClick, preTag: 'more',
        ),
      );
}
