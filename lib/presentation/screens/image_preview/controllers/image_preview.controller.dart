import 'package:flutter/cupertino.dart';
import 'package:game_on_flutter/infrastructure/model/user_info_model.dart';
import 'package:game_on_flutter/infrastructure/navigation/route_config.dart';
import 'package:get/get.dart';

class ImagePreviewController extends GetxController {
  String urlToPreview = '';
  String heroTag = 'imagepreview';
  int index = 0;
  List<UserPhotos> images = [];
  late PageController pagerController;

  @override
  void onInit() {
    _getArgument();
    pagerController = PageController(
      initialPage: index,
    );
    super.onInit();
  }

  void _getArgument() {
    if (Get.arguments != null) {
      images = Get.arguments[RouteArguments.imageList] ?? [];
      index = Get.arguments[RouteArguments.index] ?? 0;
      heroTag = Get.arguments[RouteArguments.heroTag] ?? "";
      urlToPreview = Get.arguments[RouteArguments.imageURL] ?? "";
    }
  }
}
