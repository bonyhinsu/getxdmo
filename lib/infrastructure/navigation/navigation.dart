import 'package:get/get.dart';

import '../../presentation/screens.dart';
import '../../presentation/screens/club/signup/coaching_staff/view_coach/view/club_coach_screen.dart';
import '../../presentation/screens/club/signup/register_club_details/register_club_details.screen.dart';
import '../../presentation/screens/player/editable_additional_photo/editable_additional_photo.screen.dart';
import '../../presentation/screens/player/player_profile_privacy/player_profile_privacy.screen.dart';
import 'bindings/controllers/club_coach.binding.dart';
import 'bindings/controllers/controllers_bindings.dart';
import 'bindings/controllers/editable_additional_photo.controller.binding.dart';
import 'routes.dart';

class Nav {
  static List<GetPage> routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomeScreen(),
      binding: HomeControllerBinding(),
    ),
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashScreen(),
      transitionDuration: const Duration(seconds: 0),
      transition: Transition.fade,
      binding: SplashControllerBinding(),
    ),
    GetPage(
      name: Routes.WELCOME,
      page: () => WelcomeScreen(),
      transition: Transition.fadeIn,
      binding: WelcomeControllerBinding(),
    ),
    GetPage(
      name: Routes.CHAT_MAIN,
      page: () => ChatMainScreen(),
      binding: ChatMainControllerBinding(),
    ),
    GetPage(
      name: Routes.PRIVATE_CHAT,
      page: () => PrivateChatScreen(),
      binding: PrivateChatControllerBinding(),
    ),
    GetPage(
      name: Routes.ROLE_SELECTION,
      page: () => RoleSelectionScreen(),
      binding: RoleSelectionControllerBinding(),
    ),
    GetPage(
      name: Routes.REGISTER_CLUB_DETAILS,
      page: () => RegisterClubDetailsScreen(),
      binding: RegisterClubDetailsControllerBinding(),
    ),
    GetPage(
      name: Routes.CLUB_BOARD_MEMBERS,
      page: () => ClubBoardMembersScreen(),
      binding: ClubBoardMembersControllerBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeScreen(),
      binding: HomeControllerBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginScreen(),
      binding: LoginControllerBinding(),
    ),
    GetPage(
      name: Routes.VERIFY,
      page: () => VerifyScreen(),
      binding: VerifyControllerBinding(),
    ),
    GetPage(
      name: Routes.FORGOT_PASSWORD,
      page: () => ForgotPasswordScreen(),
      binding: ForgotPasswordControllerBinding(),
    ),
    GetPage(
      name: Routes.NEW_PASSWORD,
      page: () => NewPasswordScreen(),
      binding: NewPasswordControllerBinding(),
    ),
    GetPage(
      name: Routes.SPORT_TYPE,
      page: () => SportsSelectionScreen(),
      binding: SportsSelectionControllerBinding(),
    ),
    GetPage(
      name: Routes.CLUB_LOCATION,
      page: () => ClubLocationScreen(),
      binding: ClubLocationControllerBinding(),
    ),
    GetPage(
      name: Routes.CLUB_PLAYER_TYPE,
      page: () => ClubPlayerTypeScreen(),
      binding: ClubPlayerTypeControllerBinding(),
    ),
    GetPage(
      name: Routes.CLUB_LEVEL,
      page: () => ClubLevelScreen(),
      binding: ClubLevelControllerBinding(),
    ),
    GetPage(
      name: Routes.CLUB_ACTIVITY,
      page: () => ClubActivityScreen(),
      binding: ClubActivityControllerBinding(),
    ),
    GetPage(
      name: Routes.CLUB_FAVORITE,
      page: () => ClubFavoriteScreen(),
      binding: ClubFavoriteControllerBinding(),
    ),
    GetPage(
      name: Routes.CLUB_PROFILE,
      page: () => ClubProfileScreen(),
      binding: ClubProfileControllerBinding(),
    ),
    GetPage(
      name: Routes.OTHER_CONTACT_INFORMATION,
      page: () => OtherContactInformationScreen(),
      binding: OtherContactInfomationControllerBinding(),
    ),
    GetPage(
      name: Routes.CLUB_HOME,
      page: () => ClubHomeScreen(),
      binding: ClubHomeControllerBinding(),
    ),
    GetPage(
      name: Routes.CLUB_MAIN,
      page: () => ClubMainScreen(),
      binding: ClubMainControllerBinding(),
    ),
    GetPage(
      name: Routes.MANAGE_POST,
      page: () => ManagePostScreen(),
      binding: ManagePostControllerBinding(),
    ),
    GetPage(
      name: Routes.MANAGE_SUBSCRIPTION,
      page: () => ManageSubscriptionScreen(),
      binding: ManageSubscriptionControllerBinding(),
    ),
    GetPage(
      name: Routes.SUBSCRIPTION_PLAN,
      page: () => SubscriptionPlanScreen(),
      binding: SubscriptionPlanControllerBinding(),
    ),
    GetPage(
      name: Routes.PAYMENT_METHOD,
      page: () => PaymentMethodScreen(),
      binding: PaymentMethodControllerBinding(),
    ),
    GetPage(
      name: Routes.ADD_NEW_CARD,
      page: () => AddNewCardScreen(),
      binding: AddNewCardControllerBinding(),
    ),
    GetPage(
      name: Routes.SUBSCRIPTION_DETAIL,
      page: () => SubscriptionDetailScreen(),
      binding: SubscriptionDetailControllerBinding(),
    ),
    GetPage(
      name: Routes.CLUB_PLAYER_DETAIL,
      page: () => ClubPlayerDetailScreen(),
      binding: ClubPlayerDetailControllerBinding(),
    ),
    GetPage(
      name: Routes.ADD_POST,
      page: () => AddPostScreen(),
      binding: AddPostControllerBinding(),
    ),
    GetPage(
      name: Routes.ADD_EVENT,
      page: () => AddEventScreen(),
      binding: AddEventControllerBinding(),
    ),
    GetPage(
      name: Routes.ADD_RESULT,
      page: () => AddResultScreen(),
      binding: AddResultControllerBinding(),
    ),
    GetPage(
      name: Routes.ADD_OPEN_POSITION,
      page: () => AddOpenPositionScreen(),
      binding: AddOpenPositionControllerBinding(),
    ),
    GetPage(
      name: Routes.CLUB_USER_SEARCH,
      page: () => ClubUserSearchScreen(),
      binding: ClubUserSearchControllerBinding(),
    ),
    GetPage(
      name: Routes.SEARCH_RESULT,
      page: () => SearchResultScreen(),
      binding: SearchResultControllerBinding(),
    ),
    GetPage(
      name: Routes.CLUB_NOTIFICATION,
      page: () => ClubNotificationScreen(),
      binding: ClubNotificationControllerBinding(),
    ),
    GetPage(
      name: Routes.PLAYER_MAIN,
      page: () => const PlayerMainScreen(),
      binding: PlayerMainControllerBinding(),
    ),
    GetPage(
      name: Routes.REGISTER_PLAYER_DETAIL,
      page: () => RegisterPlayerDetailScreen(),
      binding: RegisterPlayerDetailControllerBinding(),
    ),
    GetPage(
      name: Routes.PLAYER_PROFILE,
      page: () => PlayerProfileScreen(),
      binding: PlayerProfileControllerBinding(),
    ),
    GetPage(
      name: Routes.PLAYER_PROFILE_PRIVACY,
      page: () => PlayerProfilePrivacyScreen(),
      binding: PlayerProfilePrivacyControllerBinding(),
    ),
    GetPage(
      name: Routes.SELECT_CLUB,
      page: () => SelectClubScreen(),
      binding: SelectClubControllerBinding(),
    ),
    GetPage(
      name: Routes.PREFFERED_POSITION,
      page: () => PrefferedPositionScreen(),
      binding: PrefferedPositionControllerBinding(),
    ),
    GetPage(
      name: Routes.PLAYER_HOME,
      page: () => PlayerHomeScreen(),
      binding: PlayerHomeControllerBinding(),
    ),
    GetPage(
      name: Routes.CLUB_DETAIL,
      page: () => ClubDetailScreen(),
      binding: ClubDetailControllerBinding(),
    ),
    GetPage(
      name: Routes.POST_DETAIL,
      page: () => PostDetailScreen(),
      binding: PostDetailControllerBinding(),
    ),
    GetPage(
      name: Routes.OPEN_POSITION_DETAIL,
      page: () => OpenPositionDetailScreen(),
      binding: OpenPositionDetailControllerBinding(),
    ),
    GetPage(
      name: Routes.EVENT_DETAIL,
      page: () => EventDetailScreen(),
      binding: EventDetailControllerBinding(),
    ),
    GetPage(
      name: Routes.RESULT_DETAIL,
      page: () => ResultDetailScreen(),
      binding: ResultDetailControllerBinding(),
    ),
    GetPage(
      name: Routes.PLAYER_CLUB_SEARCH,
      page: () => PlayerClubSearchScreen(),
      binding: PlayerClubSearchControllerBinding(),
    ),
    GetPage(
      name: Routes.ADDITIONAL_PHOTOS,
      page: () => AdditionalPhotosScreen(),
      binding: AdditionalPhotosControllerBinding(),
    ),
    GetPage(
      name: Routes.EDITABLE_ADDITIONAL_PHOTOS,
      page: () => EditableAdditionalPhotoScreen(),
      binding: EditableAdditionalPhotoControllerBinding(),
    ),
    GetPage(
      name: Routes.IMAGE_PREVIEW,
      page: () => ImagePreviewScreen(),
      transitionDuration: const Duration(milliseconds: 800),
      binding: ImagePreviewControllerBinding(),
    ),
    GetPage(
      name: Routes.PLAYER_FAVOURITE_SELECTION,
      page: () => PlayerFavouriteSelectionScreen(),
      binding: PlayerFavouriteSelectionControllerBinding(),
    ),
    GetPage(
      name: Routes.CLUB_COACHING_STAFF,
      page: () => ClubCoachScreen(),
      binding: ClubCoachBinding(),
    ),
    GetPage(
      name: Routes.CLUB_COACHING_STAFF,
      page: () => ClubCoachScreen(),
      binding: ClubCoachBinding(),
    ),
    GetPage(
      name: Routes.PLAYER_SEARCH_RESULT,
      page: () => PlayerClubSearchResultScreen(),
      binding: PlayerSearchResultControllerBinding(),
    ),
    GetPage(
      name: Routes.POST_IMAGE_PREVIEW,
      page: () => PostImagePreviewScreen(),
      binding: PostImagePreviewControllerBinding(),
    ),
    GetPage(
      name: Routes.BLOCKED_USERS,
      page: () => BlockedUsersScreen(),
      binding: BlockedUsersControllerBinding(),
    ),


    GetPage(
      name: Routes.NO_INTERNET,
      page: () => NoInternetScreen(),
      binding: NoInternetControllerBinding(),
    ),
  ];
}
