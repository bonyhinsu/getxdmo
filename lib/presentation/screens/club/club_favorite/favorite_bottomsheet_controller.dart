import 'package:game_on_flutter/infrastructure/model/club/post/post_filter_model.dart';
import 'package:game_on_flutter/infrastructure/storage/preference_manager.dart';
import 'package:game_on_flutter/presentation/screens/club/club_favorite/controllers/club_favorite.controller.dart';
import 'package:game_on_flutter/values/app_constant.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:group_button/group_button.dart';

import '../../../../../../infrastructure/model/club/signup/club_signup_data.dart';
import '../../../../../../infrastructure/navigation/routes.dart';
import '../../../../../../values/app_string.dart';
import '../../../../../../values/app_values.dart';
import '../../../../../../values/common_utils.dart';
import '../../player/player_club_favourite/controllers/player_club_favourite.controller.dart';

class FavoriteBottomsheetController extends GetxController {
  /// Store and update list.
  RxList<PostFilterModel> filterData = RxList();

  /// store and track selected index;
  RxInt selectedIndex = (-1).obs;

  /// Button selection controller
  GroupButtonController groupButtonController = GroupButtonController();

  ///club signup data.
  SignUpData? signUpData;

  /// show clear all button for player user.
  bool enableClearAll = false;

  /// This enable apply filter button.
  RxBool enableApplyButton = false.obs;

  @override
  void onInit() {
    enableClearAll =
        GetIt.I<PreferenceManager>().getUserType == AppConstants.userTypePlayer;
    super.onInit();
  }

  /// On select field.
  void setSelectedField(PostFilterModel model, int index) {
    final isSelected = filterData[index].isSelected;
    filterData[index].isSelected = !isSelected;
    enableApplyButton.value = true;
  }

  /// Edit success message.
  void editSuccessMessage() {
    CommonUtils.showSuccessSnackBar(message: AppString.detailsUpdateSuccess);

    Future.delayed(const Duration(seconds: AppValues.successMessageDetailInSec),
        () {
      Get.until((route) => route.settings.name == Routes.CLUB_MAIN);
    });
  }

  /// Apply filter.
  void applyFilter() {
    if (GetIt.I<PreferenceManager>().isClub) {
      final ClubFavoriteController controller =
          Get.find(tag: Routes.CLUB_FAVORITE);
      controller.addSelectedFilter(filterData);
    } else {
      final PlayerClubFavouriteController controller =
          Get.find(tag: Routes.PLAYER_FAVOURITE_CLUB);
      controller.addSelectedFilter(filterData);
    }
    Get.back();
  }

  /// Set choice list to items
  void setMenuList(List<PostFilterModel> list) {
    filterData.value = list;

    /// show selected choice items.
    for (int i = 0; i < filterData.length; i++) {
      if (filterData[i].isSelected) {
        groupButtonController.selectIndex(i);
      }
    }
  }

  /// Clear all.
  void clearAll() {
    for (int i = 0; i < filterData.length; i++) {
      filterData[i].isSelected = false;
    }
    groupButtonController.unselectAll();
    enableApplyButton.value = true;
  }
}
