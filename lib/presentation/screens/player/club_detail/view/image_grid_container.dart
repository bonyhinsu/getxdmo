import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_on_flutter/infrastructure/model/common/app_fields.dart';
import 'package:game_on_flutter/values/app_string.dart';

import '../../../../../infrastructure/model/user_info_model.dart';
import '../../../../../values/app_colors.dart';
import '../../../../../values/app_images.dart';
import '../../../../../values/app_values.dart';
import '../../../../app_widgets/app_shimmer.dart';

class ImageGridContainer extends StatelessWidget {
  /// Image list.
  List<UserPhotos> images;

  bool requireViewAll;

  /// text theme
  late TextTheme textTheme;

  /// on image view all.
  Function() onImageViewAll;

  Function(UserPhotos imageUrl, String heroTag, int index) onClick;

  String preTag;

  ImageGridContainer(
      {required this.images,
      required this.onImageViewAll,
      required this.onClick,
      required this.preTag,
      this.requireViewAll = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(
          left: AppValues.padding_4,
          top: AppValues.height_8,
          right: AppValues.padding_4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildClubUserActionButtonRow(),
          const SizedBox(
            height: 8,
          ),
          buildImageGrid()
        ],
      ),
    );
  }

  /// build club action button row.
  Widget buildClubUserActionButtonRow() => requireViewAll
      ? Padding(
          padding: const EdgeInsets.only(top: AppValues.height_16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildTitle(),
              if (images.length >= 4) buildViewAllButton()
            ],
          ),
        )
      : const SizedBox();

  /// build title button.
  Widget buildTitle() => Text(
        AppString.additionalPhotos,
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        style:
            textTheme.headlineMedium?.copyWith(color: AppColors.textColorWhite),
      );

  /// Build view all button.
  Widget buildViewAllButton() => GestureDetector(
        onTap: () => onImageViewAll(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppValues.height_16),
          child: Text(
            AppString.strViewAll,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall
                ?.copyWith(color: AppColors.textColorDarkGray),
          ),
        ),
      );

  /// build image grid view.
  Widget buildImageGrid() {
    final listItems = requireViewAll
        ? images.length > 4
            ? images.sublist(0, 4)
            : images
        : images;
    return listItems.isNotEmpty
        ? GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.0,
                crossAxisSpacing: AppValues.height_16,
                mainAxisSpacing: AppValues.height_16),
            itemCount: listItems.length,
            physics: requireViewAll
                ? const NeverScrollableScrollPhysics()
                : const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext ctx, index) {
              return GestureDetector(
                onTap: () => onClick(
                    listItems[index], "${preTag}_imagePreview_$index", index),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppValues.smallRadius),
                  child: FittedBox(
                    fit: BoxFit.cover,
                    clipBehavior: Clip.hardEdge,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppValues.radius_12),
                      child:
                          buildImageView(listItems[index].image ?? "", index),
                    ),
                  ),
                ),
              );
            })
        : _noAdditionalImageWidget();
  }

  /// build image view.
  Widget buildImageView(String imageURL, int index) => Hero(
        tag: '${preTag}_imagePreview_$index',
        child: CachedNetworkImage(
          imageUrl: '${AppFields.instance.imagePrefix}$imageURL',
          fit: BoxFit.cover,
          placeholder: (context, url) => AppShimmer(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppValues.radius_6),
              ),
              height: 100,
              width: 100,
            ),
          ),
          errorWidget: (context, url, error) => blankClubIcon,
        ),
      );

  /// player blank icon.
  SvgPicture get blankClubIcon => SvgPicture.asset(
        AppImages.planBackground,
      );

  /// No image available
  Widget _noAdditionalImageWidget() {
    return SizedBox(
      height: 100,
      child: Center(
          child: Text(AppString.noImageAvailable,
              style: textTheme.displaySmall
                  ?.copyWith(color: AppColors.textColorTernary))),
    );
  }
}
