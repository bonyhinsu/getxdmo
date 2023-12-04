import 'package:get/get.dart';

import '../../../../presentation/screens/chats/chat_main/controllers/chat_main.controller.dart';

class ChatMainControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatMainController>(
      () => ChatMainController(),
    );
  }
}
