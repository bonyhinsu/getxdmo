import 'package:get/get.dart';

import '../../../../presentation/screens/subscription/add_new_card/controllers/add_new_card.controller.dart';
import '../../routes.dart';

class AddNewCardControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddNewCardController>(
      () => AddNewCardController(),
        tag: Routes.ADD_NEW_CARD
    );
  }
}
