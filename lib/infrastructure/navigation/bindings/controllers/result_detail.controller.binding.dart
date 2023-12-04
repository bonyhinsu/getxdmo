import 'package:get/get.dart';

import '../../../../presentation/screens/player/result_detail/controllers/result_detail.controller.dart';
import '../../routes.dart';

class ResultDetailControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResultDetailController>(
      () => ResultDetailController(),
        tag: Routes.RESULT_DETAIL
    );
  }
}
