import 'package:get/get.dart';

import '../../../../presentation/screens/player/editable_additional_photo/controllers/editable_additional_photo.controller.dart';
import '../../routes.dart';

class EditableAdditionalPhotoControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditableAdditionalPhotoController>(
      () => EditableAdditionalPhotoController(),
        tag: Routes.EDITABLE_ADDITIONAL_PHOTOS
    );
  }
}
