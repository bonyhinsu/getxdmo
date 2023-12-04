import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../infrastructure/model/common/app_fields.dart';
import '../../../../infrastructure/navigation/routes.dart';
import '../../../../values/app_colors.dart';
import '../../../../values/app_font_size.dart';
import '../../../../values/app_icons.dart';
import '../../../../values/app_values.dart';
import '../../../../values/common_utils.dart';
import '../../../app_widgets/club_profile_widget.dart';
import '../../../app_widgets/slider_indicator_widget.dart';
import '../../../custom_widgets/post_edit_menu_widget.dart';
import 'controllers/post_detail.controller.dart';

class PostDetailScreen extends GetView<PostDetailController> {
  PostDetailScreen({Key? key}) : super(key: key);

  final PostDetailController _controller = Get.find(tag: Routes.POST_DETAIL);

  late TextTheme textTheme;

  final pagerController = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return Obx(
      () => Scaffold(
        appBar: buildHeaderAppbar(),
        body: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppValues.screenMargin),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: AppValues.height_20,
                ),
                if ((_controller.postModel.value.postImage ?? []).isNotEmpty)
                  ExpandablePageView.builder(
                    itemCount:
                        (_controller.postModel.value.postImage ?? []).length,
                    onPageChanged: (int page) {
                      _controller.dotIndex.value = page;
                    },
                    controller: _controller.pagerController,
                    itemBuilder: (BuildContext context, int itemIndex) {
                      return ClipRRect(
                        borderRadius:
                            BorderRadius.circular(AppValues.smallRadius),
                        child: CachedNetworkImage(
                          imageUrl:
                              '${AppFields.instance.imagePrefix}${(_controller.postModel.value.postImage ?? [])[itemIndex].image ?? ""}',
                          fit: BoxFit.fitWidth,
                          fadeOutDuration: const Duration(seconds: 1),
                          fadeInDuration: const Duration(seconds: 1),
                          errorWidget: (_, __, ___) {
                            if ((((_controller.postModel.value.postImage ??
                                            [])[itemIndex])
                                        .image ??
                                    "")
                                .contains("assets/")) {
                              return Image.asset(
                                (_controller.postModel.value.postImage ??
                                            [])[itemIndex]
                                        .image ??
                                    "",
                                fit: BoxFit.fitWidth,
                              );
                            }
                            return Container();
                          },
                          placeholder: (context, url) {
                            return const SizedBox(
                              height: 150,
                              width: 150,
                              child: Center(
                                child: SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                if ((_controller.postModel.value.postImage ?? []).isNotEmpty &&
                    (_controller.postModel.value.postImage ?? []).length > 1)
                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.only(top: AppValues.height_8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _buildPageIndicator(),
                      ),
                    ),
                  ),
                const SizedBox(
                  height: AppValues.height_16,
                ),
                buildClubDetailColumn()
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// build page indicator for paged view.
  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < (_controller.postModel.value.postImage ?? []).length; i++) {
      list.add(i == _controller.dotIndex.value
          ? SliderIndicatorWidget(
              isActive: true,
            )
          : SliderIndicatorWidget(isActive: false));
    }
    return list;
  }

  /// Build header app bar widget
  AppBar buildHeaderAppbar() => AppBar(
        elevation: 0,
        backgroundColor: AppColors.pageBackground,
        leadingWidth: AppValues.appbarBackButtonSize + AppValues.screenMargin,
        centerTitle: true,
        leading: FittedBox(
          fit: BoxFit.contain,
          child: buildIconButton(
              icon: AppIcons.backArrowIcon, onClick: _controller.onBackPressed),
        ),
        title: GestureDetector(
          onTap: _controller.onHeaderClick,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildClubProfilePicture(),
              const SizedBox(
                width: AppValues.height_12,
              ),
              Expanded(
                  child: buildTitleText(
                      title: _controller.postModel.value.clubName ?? "",
                      isMainTitle: true)),
            ],
          ),
        ),
        actions: [
          _controller.enableEdit
              ? Padding(
                  padding: const EdgeInsets.only(
                      top: AppValues.appbarTopMargin,
                      right: AppValues.screenMargin,
                      bottom: AppValues.appbarTopMargin),
                  child: PostEditMenuWidget(
                    onDelete: _controller.onDeletePost,
                    onEdit: _controller.onEditPost,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(
                      top: AppValues.appbarTopMargin,
                      right: AppValues.height_6,
                      bottom: AppValues.appbarTopMargin),
                  child: IconButton(
                    onPressed: _controller.onPostShare,
                    icon: SizedBox(
                      width: AppValues.iconSize_24,
                      height: AppValues.iconSize_24,
                      child: SvgPicture.asset(
                        AppIcons.iconShare,
                      ),
                    ),
                  ),
                )
        ],
      );

  /// Build club profile picture.
  Widget buildClubProfilePicture() {
    const editIconSize = 42.0;
    return Padding(
      padding: const EdgeInsets.only(
          top: AppValues.appbarTopMargin, bottom: AppValues.appbarTopMargin),
      child: ClubProfileWidget(
        profileURL: _controller.postModel.value.clubLogo ?? "",
        width: editIconSize,
        height: editIconSize,
      ),
    );
  }

  /// Return back button widget.
  Widget buildIconButton({Function? onClick, required String icon}) =>
      GestureDetector(
        onTap: onClick == null ? () => Get.back() : () => onClick(),
        child: Container(
          margin: const EdgeInsets.only(
              left: AppValues.screenMargin,
              top: AppValues.appbarTopMargin,
              bottom: AppValues.appbarTopMargin),
          decoration: BoxDecoration(
              border:
                  Border.all(color: AppColors.inputFieldBorderColor, width: 1),
              color: AppColors.textColorSecondary.withOpacity(0.20),
              borderRadius: BorderRadius.circular(AppValues.smallRadius)),
          height: AppValues.appbarBackButtonSize,
          width: AppValues.appbarBackButtonSize,
          padding: const EdgeInsets.all(AppValues.smallPadding),
          child: SvgPicture.asset(icon),
        ),
      );

  /// Return title widget.
  Widget buildTitleText({required String title, bool isMainTitle = true}) {
    return Text(
      title,
      style: TextStyle(
          fontWeight: FontWeight.w600,
          fontFamily: FontConstants.poppins,
          fontSize: isMainTitle ? 18 : 16,
          color: AppColors.textColorSecondary),
    );
  }

  /// Build text content.
  Widget buildText() => Text(
        _controller.postModel.value.postDescription ?? "",
        textAlign: TextAlign.start,
        style: textTheme.headlineSmall
            ?.copyWith(color: AppColors.textColorDarkGray, fontSize: 13),
      );

  /// Build club detail column.
  Widget buildClubDetailColumn() => Flexible(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              CommonUtils.getRemainingDaysInWord(
                  _controller.postModel.value.time ?? "",
                  isUTC: true),
              style: textTheme.headlineSmall
                  ?.copyWith(color: AppColors.textColorDarkGray),
            ),
            const SizedBox(
              height: AppValues.height_12,
            ),
            buildText(),
          ],
        ),
      );

  /// Build league title.
  Widget buildLeagueTitle() => Text(
        _controller.postModel.value.clubName ?? "",
        textAlign: TextAlign.start,
        style: textTheme.headlineMedium
            ?.copyWith(color: AppColors.textColorSecondary),
      );

  /// Build row widget.
  Widget buildRowWidget() {
    final eventDate =
        CommonUtils.ddmmmyyyyDate(_controller.postModel.value.time ?? "");
    final eventTime =
        CommonUtils.hhmmaDate(_controller.postModel.value.time ?? "");
    return Row(
      children: [
        buildItemWidget(title: eventTime, icon: AppIcons.postTimeIcon),
        buildItemWidget(title: eventDate, icon: AppIcons.postDateIcon),
        buildItemWidget(
            title: _controller.postModel.value.leagueName ?? "",
            icon: AppIcons.postLocationIcon),
      ],
    );
  }

  /// Build item widget.
  Widget buildItemWidget({String title = "", String icon = ""}) => Expanded(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              color: AppColors.textColorSecondary,
              height: AppValues.iconSmallSize,
              width: AppValues.iconSmallSize,
            ),
            const SizedBox(
              width: 4,
            ),
            Expanded(
                child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: textTheme.displaySmall?.copyWith(
                color: AppColors.textColorDarkGray,
              ),
            )),
          ],
        ),
      );
}
