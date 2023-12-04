import 'package:game_on_flutter/infrastructure/model/common/app_fields.dart';
import 'package:game_on_flutter/infrastructure/model/user_info_model.dart';
import 'package:game_on_flutter/infrastructure/navigation/route_config.dart';
import 'package:get/get.dart';

import '../../../../../infrastructure/navigation/routes.dart';
import '../provider/additional_photos_provider.dart';

class AdditionalPhotosController extends GetxController {
  /// Store images.
  List<UserPhotos> images = [];

  /// Provider
  final provider = AdditionalPhotosProvider();

  @override
  void onInit() {
    _getArguments();
    super.onInit();
  }

  /// get arguments.
  void _getArguments() {
    if (Get.arguments != null) {
      images = Get.arguments[RouteArguments.images] ?? [];
    }
  }

  /// Function to handle back pressed.
  void onBackPressed() async {
    Get.back();
  }

  /// on image click to preview image.
  void onImageClick(UserPhotos url, String heroTag, int index) {
    Get.toNamed(Routes.IMAGE_PREVIEW, arguments: {
      RouteArguments.imageURL: '${AppFields.instance.imagePrefix}${url.image}',
      RouteArguments.imageList: images,
      RouteArguments.heroTag: heroTag,
      RouteArguments.index: index,
    });
  }
}
