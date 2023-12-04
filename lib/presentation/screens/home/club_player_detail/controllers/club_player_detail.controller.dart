import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:game_on_flutter/infrastructure/model/common/app_fields.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_loading_mixin.dart';
import 'package:game_on_flutter/presentation/screens/club/club_favorite/controllers/club_favorite.controller.dart';
import 'package:game_on_flutter/presentation/screens/home/club_home/controllers/club_home_controller.dart';
import 'package:game_on_flutter/presentation/screens/home/club_player_detail/providers/club_player_detail_provider.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../infrastructure/firebase/firestore_manager.dart';
import '../../../../../infrastructure/model/club/home/image_model.dart';
import '../../../../../infrastructure/model/user_detail_response_model.dart';
import '../../../../../infrastructure/model/user_info_model.dart';
import '../../../../../infrastructure/navigation/route_config.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../infrastructure/network/api_utils.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../infrastructure/storage/preference_manager.dart';
import '../../../../../values/common_utils.dart';
import '../../../../app_widgets/app_dialog_with_title_widget_two.dart';
import '../../../chats/private_chat/controllers/private_chat.controller.dart';
import '../../../follow_unfollow/follow_unfollow.controller.dart';

class ClubPlayerDetailController extends GetxController
    with AppLoadingMixin, SingleGetTickerProviderMixin {
  /// Player detail view type enum
  PlayerDetailViewTypeEnum playerDetailViewTypeEnum =
      PlayerDetailViewTypeEnum.clubHomeList;

  Rx<UserDetails> userDetails = UserDetails().obs;

  /// Viewing user id
  String viewingUserId = '';

  /// Store provider
  final _provider = ClubPlayerDetailProvider();

  late List<ImageModel> image;

  /// Stores item index
  int listItemIndex = -1;

  /// Track and refresh screen when user like or dislike.
  RxBool isLiked = false.obs;

  /// flag to update is current user is follow.
  RxBool followedUser = false.obs;

  late TabController tabController;

  RxInt currentSelectedIndex = 0.obs;

  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    image = getUserListForSearch();
    _initTabController();
    _getArguments();
    super.onInit();
  }

  /// Receive arguments from previous screen.
  void _getArguments() {
    if (Get.arguments != null) {
      viewingUserId = Get.arguments[RouteArguments.userId] ?? "";

      listItemIndex = Get.arguments[RouteArguments.listItemIndex] ?? -1;

      playerDetailViewTypeEnum =
          Get.arguments[RouteArguments.playerDetailViewTypeEnum] ??
              PlayerDetailViewTypeEnum.clubHomeList;

      _getUserDetail();
    }
  }

  /// On like changed.
  void likeChange(_) {
    Get.toNamed(Routes.PLAYER_FAVOURITE_SELECTION, arguments: {
      RouteArguments.userId: viewingUserId,
      RouteArguments.alreadyLiked: isLiked.value
    })?.then((value) {
      if (value != null) {
        final checkForSelectedElement =
            value.indexWhere((element) => element.isSelected == true);

        userDetails.value.isFavourite = checkForSelectedElement != -1 ? 1 : 0;
        isLiked.value = checkForSelectedElement != -1;

        _updateList();
      }
    });
  }

  /// update respected list for the change.
  void _updateList() {
    if (GetIt.I<PreferenceManager>().isClub) {
      if (playerDetailViewTypeEnum == PlayerDetailViewTypeEnum.clubHomeList) {
        /// Check is [ClubHomeController] is registered or not.
        bool isClubHomeControllerRegister =
            Get.isRegistered<ClubHomeController>(tag: Routes.CLUB_HOME);
        if (isClubHomeControllerRegister) {
          final ClubHomeController controller0 =
              Get.find(tag: Routes.CLUB_HOME);

          controller0.updateLikeChangeToList(listItemIndex, isLiked.value);
        }
      } else if (playerDetailViewTypeEnum ==
          PlayerDetailViewTypeEnum.clubFavourite) {
        /// Check is [ClubHomeController] is registered or not.
        bool isControllerRegister =
            Get.isRegistered<ClubFavoriteController>(tag: Routes.CLUB_FAVORITE);

        if (isControllerRegister) {
          final ClubFavoriteController controller0 =
              Get.find(tag: Routes.CLUB_FAVORITE);

          controller0.updateLikeChangeToList(listItemIndex, isLiked.value);
        }
      }
    }
  }

  /// On view all
  void onViewALL() {
    Get.toNamed(Routes.ADDITIONAL_PHOTOS,
        arguments: {RouteArguments.images: userDetails.value.userPhotos ?? []});
  }

  /// On view all
  void onVideoClick({String videoURL = ''}) async {
    videoURL = userDetails.value.video ?? "";

    if (await canLaunch(videoURL)) {
      await launch(videoURL, forceSafariVC: false);
    } else {
      if (await canLaunch(videoURL)) {
        await launch(videoURL);
      } else {
        throw 'Could not launch Video URL';
      }
    }
  }

  /// on image click to preview image.
  void onImageClick(UserPhotos url, String heroTag, int index) {
    Get.toNamed(Routes.IMAGE_PREVIEW, arguments: {
      RouteArguments.imageList: userDetails.value.userPhotos,
      RouteArguments.heroTag: heroTag,
      RouteArguments.index: index,
    });
  }

  /// Show unfollow warning dialog.
  void showUnfollowUserDialog() {
    Get.dialog(AppDialogWithTitleWidgetTwo(
      cancelButtonText: AppString.cancel,
      doneButtonText: AppString.unfollow,
      onDone: _onUnfollowUser,
      dialogText: AppString.unfollowPlayerWarningMessage,
      dialogTitle: 'Unfollow ${userDetails.value.name ?? ""}?',
    ));
  }

  /// Show unfollow warning dialog.
  void onFollowClick() {
    FollowUnfollowController unfollowController = Get.find();
    unfollowController.followUnfollowUser(viewingUserId).then((value) {
      final totalFollowers = userDetails.value.followerCount ?? 0;
      userDetails.value.followerCount = totalFollowers + 1;
      followedUser.value = true;
    });
  }

  /// on message button click
  void onMessageClick() async {
    if (followedUser.isFalse) {
      CommonUtils.showInfoSnackBar(message: AppString.followPlayerFirstMessage);
      return;
    }
    Get.lazyPut(() => PrivateChatController(),
        tag: "${Routes.PRIVATE_CHAT}/${userDetails.value.firebaseUserId}");

    showGlobalLoading();
    final threadId = await GetIt.I<FireStoreManager>().getUserChatWith(
        myId: GetIt.I<PreferenceManager>().userUUID.toString(),
        friendId: userDetails.value.firebaseUserId ?? "");

    hideGlobalLoading();
    Get.toNamed(Routes.PRIVATE_CHAT, arguments: {
      RouteArguments.firebaseUserId: userDetails.value.firebaseUserId,
      RouteArguments.userId: userDetails.value.id.toString(),
      RouteArguments.email: (userDetails.value.email ?? "").trim(),
      RouteArguments.userName: userDetails.value.name ?? "",
      RouteArguments.threadId: threadId,
      RouteArguments.profilePicture:
          (userDetails.value.profileImage ?? "").isNotEmpty
              ? userDetails.value.profileImage ?? ""
              : "",
    });
  }

  /// On cancel subscription.
  void _onUnfollowUser() {
    FollowUnfollowController unfollowController = Get.find();
    unfollowController.followUnfollowUser(viewingUserId).then((value) {
      followedUser.value = false;
      final totalFollowers = userDetails.value.followerCount ?? 0;
      if (totalFollowers > 0) {
        userDetails.value.followerCount = totalFollowers - 1;
      }
    });
  }

  /// get user detail API.
  void _getUserDetail() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showLoading();
      dio.Response? response =
          await _provider.getUserDetail(userId: viewingUserId);
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _getUserDetailSuccess(response);
        } else {
          /// On Error
          _getUserDetailError(response);
        }
      } else {
        hideLoading();
        GetIt.I<CommonUtils>().showServerDownError();
      }
    } else {
      hideLoading();
      GetIt.I<CommonUtils>().showNetworkError();
    }
  }

  /// Get user detail success API response
  void _getUserDetailSuccess(dio.Response response) {
    hideLoading();

    UserDetailResponseModel userDetailResponseModel =
        UserDetailResponseModel.fromJson(response.data);
    if (userDetailResponseModel.data != null) {
      userDetails.value = userDetailResponseModel.data!;
      isLiked.value = userDetails.value.isFavourite == 1;
      followedUser.value = userDetails.value.isFollow == 1;
      userDetails.refresh();
    }
  }

  /// Get user detail api error.
  void _getUserDetailError(dio.Response response) {
    hideGlobalLoading();
    hideLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }

  /// Build tab controller.
  Future<void> _initTabController() async {
    tabController = TabController(vsync: this, length: 2);
    tabController.addListener(() {
      currentSelectedIndex.value = tabController.index;
    });
  }

  List<ImageModel> getUserListForSearch() {
    return [
      ImageModel(
        image: "Patricia Williams",
        video:
            "https://2.bp.blogspot.com/-y0aJ6bN98F0/Upi95Qpe8RI/AAAAAAAAGc4/-L8B-WtJmHY/s1600/Girl_01_Small+2.png",
      ),
      ImageModel(
        image: "Patricia Williams",
        video:
            "https://img.freepik.com/premium-vector/little-boy-with-winter-clothes_24877-36784.jpg",
      ),
      ImageModel(
        image: "Patricia Williams",
        video: "https://img.freepik.com/free-icon/boy_318-174477.jpg",
      ),
      ImageModel(
        image: "Patricia Williams",
        video:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSZpK86Byd1y1vomiV4F-1fKqR6MibmGH7Q0VGNVCNaJN45F4E8JUJgreTpbCjZD2zPmjLUk-06ASE&usqp=CAU&ec=48665701",
      ),
      ImageModel(
        image: "Patricia Williams",
        video:
            "https://2.bp.blogspot.com/-y0aJ6bN98F0/Upi95Qpe8RI/AAAAAAAAGc4/-L8B-WtJmHY/s1600/Girl_01_Small+2.png",
      ),
    ];
  }

  /// scroll to bottom
  void navigateToBottom(int pos) {
    Future.delayed(const Duration(milliseconds: 400), () {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
    });
  }
}

enum PlayerDetailViewTypeEnum {
  clubHomeList,
  clubSearchResult,
  clubFavourite,
  chat
}
