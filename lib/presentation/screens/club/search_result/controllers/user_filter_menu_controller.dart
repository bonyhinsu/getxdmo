import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../../infrastructure/model/club/actiivty_filter_model.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../infrastructure/storage/preference_manager.dart';
import '../../../../../values/app_colors.dart';
import '../../../authentication/general_data/controllers/app_master_data.controller.dart';
import '../../../home/club_home/controllers/club_activity_filter_option_controller.dart';
import '../../../home/club_home/view/club_activity_filter_option_bottomsheet.dart';
import '../../club_favorite/controllers/club_data_provider_controller.dart';

class UserFilterMenuController extends GetxController {
  /// Menu list
  RxList<ClubActivityFilter> filterMenuList = RxList();

  Function(List<ClubActivityFilter> tempList)? onSelect;

  /// Prepare filter menu items
  void prepareFilterMenu() async {
    MasterDataController masterDataController =
        Get.find(tag: Routes.MASTER_DATA_PROVIDER);
    await masterDataController.getPrepareData().then((value) {
      ClubDataProviderController clubDataProvider =
          Get.find(tag: Routes.CLUB_DATA_PROVIDER);

      clubDataProvider.prepareMenuItems();

      filterMenuList.value = clubDataProvider.filterMenuList;
    });
  }

  /// Verify data then navigate to filter screen.
  void navigateToFilterScreen(
      Function(List<ClubActivityFilter> tempList) onApplyFilter,
      {bool clearFilters = false}) async {
    onSelect = onApplyFilter;
    if ((filterMenuList.value ?? []).isNotEmpty) {
      if ((filterMenuList.value ?? []).first.filterSubItems.isNotEmpty) {
        _showFilterBottomSheet(clearFilters);
      } else {
        _prepareDataThenNavigate();
      }
    } else {
      _prepareDataThenNavigate();
    }
  }

  /// Forcefully refresh data.
  void forceRefreshAllData(){
    filterMenuList.value.clear();
    prepareFilterMenu();
  }

  /// Get data and prepare data to be filter.
  void _prepareDataThenNavigate() async {
    filterMenuList.value.clear();
    MasterDataController masterDataController =
        Get.find(tag: Routes.MASTER_DATA_PROVIDER);
    await masterDataController.getPrepareData().then((value) {
      ClubDataProviderController clubDataProvider =
          Get.find(tag: Routes.CLUB_DATA_PROVIDER);

      if (GetIt.I<PreferenceManager>().isClub) {
        clubDataProvider.prepareMenuItems();
      } else {
        clubDataProvider.prepareMenuItemsForPlayer();
      }

      filterMenuList.value = clubDataProvider.filterMenuList;

      _showFilterBottomSheet(true);
    });
  }

  /// set filter list to items
  void setFilterListToSelectedItems(List<ClubActivityFilter> tempList) {
    filterMenuList.value = tempList;
    filterMenuList.refresh();
    onSelect!(tempList);
  }

  /// On filter click
  void _showFilterBottomSheet(bool clearFilters) {
    if (onSelect == null) {
      return;
    }
    bool isRegistered = Get.isRegistered<ClubActivityFilterOptionController>(
        tag: Routes.CLUB_ACTIVITY_FILTER);
    if (!isRegistered) {
      Get.lazyPut<ClubActivityFilterOptionController>(
          () => ClubActivityFilterOptionController(),
          tag: Routes.CLUB_ACTIVITY_FILTER);
    }
    Future.delayed(const Duration(milliseconds: 400), () {
      Get.bottomSheet(
              ClubActivityFilterOptionBottomSheet(
                filterMenuList: filterMenuList,
                onApplyFilter: setFilterListToSelectedItems,
                requireClearAll: clearFilters,
              ),
              barrierColor: AppColors.bottomSheetBgBlurColor,
              enterBottomSheetDuration: const Duration(milliseconds: 600),
              exitBottomSheetDuration: const Duration(milliseconds: 400),
              isScrollControlled: true)
          .then((value) {
        Get.delete<ClubActivityFilterOptionController>(
            tag: Routes.CLUB_ACTIVITY_FILTER, force: true);
      });
    });
  }
}
