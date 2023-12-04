import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:game_on_flutter/values/app_constant.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../infrastructure/firebase/firestore_manager.dart';
import '../../../../../infrastructure/model/common/app_fields.dart';
import '../../../../../infrastructure/model/user_detail_response_model.dart';
import '../../../../../infrastructure/model/user_info_model.dart';
import '../../../../../infrastructure/navigation/route_config.dart';
import '../../../../../infrastructure/navigation/routes.dart';
import '../../../../../infrastructure/network/api_utils.dart';
import '../../../../../infrastructure/network/network_config.dart';
import '../../../../../infrastructure/network/network_connectivity.dart';
import '../../../../../infrastructure/storage/preference_manager.dart';
import '../../../../../values/app_string.dart';
import '../../../../../values/common_utils.dart';
import '../../../../app_widgets/app_dialog_with_title_widget_two.dart';
import '../../../../app_widgets/app_loading_mixin.dart';
import '../../../chats/private_chat/controllers/private_chat.controller.dart';
import '../../../club/signup/club_board_members/model/club_member_model.dart';
import '../../../follow_unfollow/follow_unfollow.controller.dart';
import '../provider/club_detail_provider.dart';

class ClubDetailController extends GetxController
    with AppLoadingMixin, SingleGetTickerProviderMixin {
  /// Store provider
  final _provider = ClubDetailProvider();

  /// Stores item index
  int listItemIndex = -1;

  /// Track and refresh screen when user like or dislike.
  RxBool isLiked = false.obs;

  /// Track and refresh flag for if user follows club or not.
  RxBool followedUser = false.obs;

  late TabController tabController;

  RxInt currentSelectedIndex = 0.obs;

  Rx<UserDetails> userDetails = UserDetails().obs;

  ScrollController scrollController = ScrollController();

  /// Viewing user id
  String viewingClubId = '';

  /// President list
  List<ClubMemberModel> presidentList = [];

  /// Director list
  List<ClubMemberModel> directorList = [];

  /// Other board member list
  List<ClubMemberModel> otherBoardMemberList = [];

  /// Coaching staff list.
  List<ClubMemberModel> coachingStaffList = [];

  @override
  void onInit() {
    _getArguments();
    initController();
    super.onInit();
  }

  /// Receive arguments from previous screen.
  void _getArguments() {
    if (Get.arguments != null) {
      viewingClubId = Get.arguments[RouteArguments.userId].toString() ?? "";

      listItemIndex = Get.arguments[RouteArguments.listItemIndex] ?? -1;

      _getUserDetail();
    }
  }

  /// On like changed.
  void likeChange(bool _isLiked) {
    Get.toNamed(Routes.PLAYER_FAVOURITE_SELECTION, arguments: {
      RouteArguments.userId: viewingClubId,
      RouteArguments.alreadyLiked: isLiked.value
    })?.then((value) {
      if (value != null) {
        final checkForSelectedElement =
            value.indexWhere((element) => element.isSelected == true);

        userDetails.value.isFavourite = checkForSelectedElement != -1 ? 1 : 0;
        isLiked.value = checkForSelectedElement != -1;

        // _updateList();
      }
    });
  }

  /// Show unfollow warning dialog.
  void showUnfollowUserDialog() {
    Get.dialog(AppDialogWithTitleWidgetTwo(
      cancelButtonText: AppString.cancel,
      doneButtonText: AppString.unfollow,
      onDone: _onUnfollowUser,
      dialogText: AppString.unfollowClubWarningMessage,
      dialogTitle: 'Unfollow ${userDetails.value.name}?',
    ));
  }

  /// On cancel subscription.
  void _onUnfollowUser() {
    FollowUnfollowController unfollowController = Get.find();
    unfollowController.followUnfollowUser(viewingClubId).then((value) {
      final totalFollowers = userDetails.value.followerCount ?? 0;
      if (totalFollowers > 0) {
        userDetails.value.followerCount = totalFollowers - 1;
      }
      followedUser.value = false;
      followedUser.refresh();
    });
  }

  /// Show unfollow warning dialog.
  void onFollowClick() {
    FollowUnfollowController unfollowController = Get.find();
    unfollowController.followUnfollowUser(viewingClubId).then((value) {
      final totalFollowers = userDetails.value.followerCount ?? 0;
      userDetails.value.followerCount = totalFollowers + 1;
      followedUser.value = true;
      followedUser.refresh();
    });
  }

  /// On view all
  void onViewALL() {
    Get.toNamed(Routes.ADDITIONAL_PHOTOS,
        arguments: {RouteArguments.images: userDetails.value.userPhotos ?? []});
  }

  /// On follower all
  void onFollowerClick() {}

  /// On follower all
  void onChatClick() async {
    if (followedUser.isFalse) {
      CommonUtils.showInfoSnackBar(message: AppString.followUserFirstMessage);
      return;
    }
    Get.lazyPut(() => PrivateChatController(),
        tag: "${Routes.PRIVATE_CHAT}/${userDetails.value.firebaseUserId}");

    showGlobalLoading();
    final threadId = await GetIt.I<FireStoreManager>().getUserChatWith(
        myId: GetIt.I<PreferenceManager>().userUUID.toString(),
        friendId: userDetails.value.firebaseUserId??"");

    hideGlobalLoading();
    Get.toNamed(Routes.PRIVATE_CHAT, arguments: {
      RouteArguments.firebaseUserId: userDetails.value.firebaseUserId,
      RouteArguments.userId: userDetails.value.id.toString(),
      RouteArguments.email: (userDetails.value.email ?? "").trim(),
      RouteArguments.userName: userDetails.value.name ?? "",
      RouteArguments.threadId: threadId,
      RouteArguments.profilePicture: (userDetails.value.profileImage ?? "")
          .isNotEmpty
          ? userDetails.value.profileImage ?? ""
          : "",
    });
  }

  /// On call function
  void onCallClick(ClubMemberModel obj) =>
      CommonUtils.openPhoneApplication(obj.phone ?? "");

  /// on message function
  void onMessageClick(ClubMemberModel obj) =>
      CommonUtils.openEmailApplication(obj.email ?? "");

  /// on image click to preview image.
  void onImageClick(UserPhotos url, String heroTag, int index) {
    Get.toNamed(Routes.IMAGE_PREVIEW, arguments: {
      RouteArguments.imageList: userDetails.value.userPhotos,
      RouteArguments.index: index,
      RouteArguments.heroTag: heroTag,
    });
  }

  /// scroll to bottom
  void navigateToBottom(int pos) {
    Future.delayed(const Duration(milliseconds: 400), () {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
    });
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

  /// get user detail API.
  void _getUserDetail() async {
    if (await NetworkConnectivity.instance.hasNetwork()) {
      showGlobalLoading();
      dio.Response? response =
          await _provider.getUserDetail(clubId: viewingClubId);
      if (response.data != null) {
        if (response.statusCode == NetworkConstants.success) {
          /// On success
          _getUserDetailSuccess(response);
        } else {
          /// On Error
          _getUserDetailError(response);
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

  /// Get user detail success API response
  void _getUserDetailSuccess(dio.Response response) {
    hideGlobalLoading();
    UserDetailResponseModel userDetailResponseModel =
        UserDetailResponseModel.fromJson(response.data);
    if (userDetailResponseModel.data != null) {
      userDetails.value = userDetailResponseModel.data!;
      isLiked.value = userDetails.value.isFavourite == 1;
      followedUser.value = userDetails.value.isFollow == 1;

      // Prepare Comma Separated Data.
      _prepareCommaSeparatedData(userDetailResponseModel);

      // Prepare club members.
      _prepareClubBoardMember();

      userDetails.refresh();
    }
  }

  /// Prepare Comma Separated Data.
  void _prepareCommaSeparatedData(
      UserDetailResponseModel userDetailResponseModel) {
    // Prepare location name arraylist
    userDetails.value.commaSeparatedLocations =
        _getCommaSeparatedLocations(userDetailResponseModel);

    // Prepare level name arraylist
    userDetails.value.commaSeparatedLevels =
        _getCommaSeparatedLevels(userDetailResponseModel);

    // Prepare sports name arraylist
    userDetails.value.commaSeparatedSports =
        _getCommaSeparatedSports(userDetailResponseModel);

    // Prepare preferred position arraylist
    userDetails.value.commaSeparatedPreferredPositions =
        _getCommaSeparatedPreferredPosition(userDetailResponseModel);
  }

  /// Prepare club board members.
  void _prepareClubBoardMember() {
    userDetails.value.clubAdminDetails?.forEach((element) {
      switch (element.type) {
        case AppConstants.rolePresident:

          /// ---- President
          presidentList.add(ClubMemberModel.member(element.name, element.type,
              element.email ?? "", element.contactNumber));
          return;
        case AppConstants.roleDirector:

          /// ---- Director
          directorList.add(ClubMemberModel.member(element.name, element.type,
              element.email ?? "", element.contactNumber));
          return;

        default:

          /// ---- Other Board Members
          otherBoardMemberList.add(ClubMemberModel.member(element.name,
              element.type, element.email ?? "", element.contactNumber));
      }
    });

    userDetails.value.coachingStaffDetails?.forEach((element) {
      coachingStaffList.add(ClubMemberModel.coach(
          userName: element.name ?? "",
          role: element.speciality,
          email: element.email ?? "",
          phone: element.contactNumber,
          dateOfBirth: element.dateOfBirth,
          itemId: element.id,
          gender: (element.gender ?? "male").toLowerCase() == 'male' ? 1 : 2,
          totalExperience: element.experience));
    });
  }

  /// Return string with coma separated locations.
  ///
  /// required [UserDetailResponseModel].
  String _getCommaSeparatedLocations(
      UserDetailResponseModel userDetailResponseModel) {
    // Prepare location name arraylist
    List<String?> comaSeparatedLocations =
        (userDetailResponseModel.data?.userSportsDetails ?? []).isNotEmpty
            ? (userDetailResponseModel.data?.userSportsDetails ?? [])
                .map((sportElement) {
                final comaSeparatedLocationList = sportElement
                    .userLocationDetails
                    ?.map((e) => e.locationDetails?.name ?? "")
                    .toList();
                // Remove empty value from the list.
                comaSeparatedLocationList
                    ?.removeWhere((element) => element.isEmpty);

                return comaSeparatedLocationList?.join(', ');
              }).toList()
            : [];

    // Remove empty value from the list.
    comaSeparatedLocations.removeWhere((element) => (element ?? "").isEmpty);

    return comaSeparatedLocations.join(', ');
  }

  /// Return string with coma separated locations.
  ///
  /// required [UserDetailResponseModel].
  String _getCommaSeparatedLevels(
      UserDetailResponseModel userDetailResponseModel) {
    // Prepare location name arraylist
    List<String?> comaSeparatedLocations =
        (userDetailResponseModel.data?.userSportsDetails ?? []).isNotEmpty
            ? (userDetailResponseModel.data?.userSportsDetails ?? [])
                .map((sportElement) {
                final comaSeparatedLocationList = sportElement.userLevelDetails
                    ?.map((e) => e.levelDetails?.name ?? "")
                    .toList();
                // Remove empty value from the list.
                comaSeparatedLocationList
                    ?.removeWhere((element) => element.isEmpty);

                return comaSeparatedLocationList?.join(', ');
              }).toList()
            : [];

    // Remove empty value from the list.
    comaSeparatedLocations.removeWhere((element) => (element ?? "").isEmpty);

    return comaSeparatedLocations.join(', ');
  }

  /// Return string with coma separated locations.
  ///
  /// required [UserDetailResponseModel].
  String _getCommaSeparatedSports(
      UserDetailResponseModel userDetailResponseModel) {
    // Prepare sport name arraylist
    List<String?> comaSeparatedSports =
        (userDetailResponseModel.data?.userSportsDetails ?? []).isNotEmpty
            ? (userDetailResponseModel.data?.userSportsDetails ?? [])
                .map(
                    (sportElement) => sportElement.sportTypeDetails?.name ?? "")
                .toList()
            : [];

    // Remove empty value from the list.
    comaSeparatedSports.removeWhere((element) => (element ?? "").isEmpty);

    return comaSeparatedSports.join(', ');
  }

  /// Return string with coma separated locations.
  ///
  /// required [UserDetailResponseModel].
  String _getCommaSeparatedPreferredPosition(
      UserDetailResponseModel userDetailResponseModel) {
    // Prepare location name arraylist
    List<String?> comaSeparatedLocations =
        (userDetailResponseModel.data?.userSportsDetails ?? []).isNotEmpty
            ? (userDetailResponseModel.data?.userSportsDetails ?? [])
                .map((sportElement) {
                final comaSeparatedLocationList = sportElement
                    .userPlayerCategory
                    ?.map((e) => e.name ?? "")
                    .toList();
                // Remove empty value from the list.
                comaSeparatedLocationList
                    ?.removeWhere((element) => element.isEmpty);

                return comaSeparatedLocationList?.join(', ');
              }).toList()
            : [];

    // Remove empty value from the list.
    comaSeparatedLocations.removeWhere((element) => (element ?? "").isEmpty);

    return comaSeparatedLocations.join(', ');
  }

  /// Get user detail api error.
  void _getUserDetailError(dio.Response response) {
    hideGlobalLoading();
    GetIt.instance<ApiUtils>().parseErrorResponse(response);
  }

  Future<void> initController() async {
    tabController = TabController(vsync: this, length: 4);
    tabController.addListener(() {
      currentSelectedIndex.value = tabController.index;
    });
  }
}
