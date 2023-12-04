import 'package:get/get.dart';

import '../../../../presentation/screens/club/search_result/controllers/search_result.controller.dart';
import '../../routes.dart';

class SearchResultControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchResultController>(
      () => SearchResultController(),
      tag: Routes.SEARCH_RESULT
    );
  }
}
