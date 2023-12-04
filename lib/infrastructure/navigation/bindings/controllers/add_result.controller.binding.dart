import 'package:get/get.dart';

import '../../../../presentation/screens/club/add_result/controllers/add_result.controller.dart';
import '../../routes.dart';

class AddResultControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddResultController>(
      () => AddResultController(),
        tag: Routes.ADD_RESULT
    );
  }
}
