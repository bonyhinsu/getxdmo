import 'package:flutter/material.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_button_mixin.dart';
import 'package:game_on_flutter/presentation/app_widgets/base_bottomsheet.dart';
import 'package:game_on_flutter/presentation/screens/player/player_favourite_selection/controllers/add_favourite_item_controller.dart';
import 'package:game_on_flutter/values/app_values.dart';
import 'package:get/get.dart';

import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../values/app_string.dart';
import '../../../../app_widgets/app_input_field.dart';

class AddFavouriteItemWidget extends StatelessWidget with AppButtonMixin {
  AddFavouriteItemWidget(
      {String? existingItem, int itemId =-1,bool isEdit = false, Key? key}) {
    if (isEdit && existingItem != null) {
      _controller.setExistingData(existingItem,itemId);
    }
  }

  final AddFavouriteItemController _controller =
      Get.find(tag: Routes.ADD_PLAYER_FAVOURITE_BOTTOMSHEET);

  @override
  Widget build(BuildContext context) {
    return BaseBottomsheet(
      title: _controller.isEditForm
          ? AppString.strUpdateList
          : AppString.strAddNewList,
      child: Obx(
        () => Form(
          key: _controller.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildListInputField,
              const SizedBox(
                height: AppValues.height_16,
              ),
              _buildCreateButton(),
              const SizedBox(
                height: AppValues.height_20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build list field.
  Widget get _buildListInputField => AppInputField(
        label: AppString.listName,
        fromBottomSheet: true,
        isCapWords: true,
        isLastField: true,
        controller: _controller.itemController,
        focusNode: _controller.itemFocusNode,
        errorText: _controller.itemError.value,
        onChange: _controller.setFavouriteItem,
      );

  /// Create button
  Widget _buildCreateButton() => appWhiteButton(
      title: _controller.isEditForm ? AppString.strUpdate : AppString.strCreate,
      isValidate: _controller.isValidField.value,
      onClick: () => _controller.onSubmit());
}
