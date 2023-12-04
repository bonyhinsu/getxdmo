import 'package:get/get.dart';

import '../../../../presentation/screens/authentication/general_data/controllers/app_master_data.controller.dart';
import '../../../../presentation/screens/club/club_favorite/controllers/club_data_provider_controller.dart';
import '../../../../presentation/screens/club/search_result/controllers/user_filter_menu_controller.dart';
import '../../../../presentation/screens/subscription/subscription_plan/controllers/subscription_plan.controller.dart';
import '../../routes.dart';

class SubscriptionPlanControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubscriptionPlanController>(
      () => SubscriptionPlanController(),
        tag: Routes.SUBSCRIPTION_PLAN,
    );
    Get.lazyPut<ClubDataProviderController>(() => ClubDataProviderController(),
        tag: Routes.CLUB_DATA_PROVIDER);

    Get.lazyPut<MasterDataController>(() => MasterDataController(),
        tag: Routes.MASTER_DATA_PROVIDER);

    Get.lazyPut<UserFilterMenuController>(() => UserFilterMenuController(),
        tag: Routes.CLUB_PLAYER_FILTER);
  }
}
