import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_loading_mixin.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../../infrastructure/model/favourite/add_favourite_response.dart';
import '../../../../../infrastructure/network/api_utils.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../values/common_utils.dart';
import '../provider/player_favourite_selection_provider.dart';

class AddFavouriteItemController extends GetxController with AppLoadingMixin {
  late TextEditingController itemController;

  String _item = "";

  /// bool to check field are valid or not.
  ///
  /// if true then enable button.
  RxBool isValidField = RxBool(false);

  /// Item error
  RxString itemError = "".obs;

  /// Focus node
  late FocusNode itemFocusNode;

  /// Form key
  final formKey = GlobalKey<FormState>();

  /// provider
  final _provider = PlayerFavouriteSelectionProvider();

  bool isEditForm = false;

  /// index for which item will be updated.
  int updateItemIndex = -1;
  int updateItemId = -1;

  @override
  void onInit() {
    _initialiseFields();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(milliseconds: 600), () {
      itemFocusNode.requestFocus();
    });
  }

  /// Setup initial fields.
  void _initialiseFields() {
    itemController = TextEditingController(text: "");

    itemFocusNode = FocusNode();
  }

  /// on Submit called.
  void onSubmit() {
    if (formKey.currentState!.validate()) {
      FocusScope.of(Get.context!).unfocus();
      if (isEditForm) {
        _updateToFavouriteAPI();
      } else {
        _addToFavouriteAPI();
      }
    }
  }

  /// Clear all fields.
  void _clearFieldErrors() {
    itemError.value = "";
  }

  /// Clear fields.
  void _clearFields() {
    _clearFieldErrors();
    itemController.clear();
  }

  /// Set favourite item.
  void setFavouriteItem(String value) {
    _item = value;
    checkFieldValid();
  }

  /// clear field validation.
  void checkFieldValid() {
    isValidField.value = _item.isNotEmpty;
  }

  /// Sets existing item name to the field.
  void setExistingData(String itemName, int existingItemId) {
    isEditForm = true;
    itemController.text = itemName;
    updateItemId = existingItemId;
    setFavouriteItem(itemName);
  }

  /// add to favourite API.
  void _addToFavouriteAPI() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showGlobalLoading();
      dio.Response? response =
          await _provider.addPlayerFavouriteList(value: _item.trim());
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.created) {
          /// On success
          _addFavouriteSuccessResponse(response);
        } else {
          /// On Error
          _addFavouriteErrorResponse(response);
        }
      } else {
        hideGlobalLoading();
        GetIt.I<CommonUtils>().showServerDownError();
      }
    } else {
      hideGlobalLoading();
      GetIt.I<CommonUtils>().showNetworkError();
    }
  }

  /// update to favourite API.
  void _updateToFavouriteAPI() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showGlobalLoading();
      dio.Response? response =
          await _provider.updatePlayerFavouriteList(value: _item.trim(),itemId: updateItemId);
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _addFavouriteSuccessResponse(response);
        } else {
          /// On Error
          _addFavouriteErrorResponse(response);
        }
      } else {
        hideGlobalLoading();
        GetIt.I<CommonUtils>().showServerDownError();
      }
    } else {
      hideGlobalLoading();
      GetIt.I<CommonUtils>().showNetworkError();
    }
  }

  /// Perform login api success
  void _addFavouriteSuccessResponse(dio.Response response) {
    hideGlobalLoading();
    _clearFields();
    AddFavouriteResponse model = AddFavouriteResponse.fromJson(response.data);
    _addItemToListAndBack(
        id: model.data?.id ?? 1, value: model.data?.name ?? "");
  }

  /// Perform api error.
  void _addFavouriteErrorResponse(dio.Response response) {
    hideGlobalLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }

  /// add item to favourite list and navigate to back.
  void _addItemToListAndBack({required int id, required String value}) {
    Get.back(result: {'id': id, 'value': value});
  }
}
