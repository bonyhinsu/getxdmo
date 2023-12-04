abstract class NetworkEnvironment {
  /// Rakshit local
  static const apiBackend = "http://192.168.1.35:5001/api/";

  /// Production Backend
  static const prodBackend = "http://192.168.1.35:5001/api/";

  static const baseURL = "${apiBackend}v1/";
}

abstract class NetworkAPI {
  static const login = "";

  //Login
  static const loginUser = '${NetworkEnvironment.baseURL}front/auth/login';
  static const logout = '${NetworkEnvironment.baseURL}front/auth/logout';

  // Get user details
  static const userDetails = '${NetworkEnvironment.baseURL}front/users';

  // Store firebase token
  static const storeFirebaseToken = '$userDetails/storeFirebaseToken';

  // Login user verify.
  static const loginUserVerify =
      '${NetworkEnvironment.baseURL}front/auth/loginVerification';

  // Resend OTP
  static const resendVerification =
      '${NetworkEnvironment.baseURL}front/auth/resendVerification';

  // Forgot Password.
  static const forgotPassword =
      '${NetworkEnvironment.baseURL}front/auth/forgotPassword';

  // Forgot Password Verify
  static const forgotPasswordVerify =
      '${NetworkEnvironment.baseURL}front/auth/forgotPasswordVerification';

  //Reset Password
  static const resetPassword =
      '${NetworkEnvironment.baseURL}front/auth/resetPassword';

  // Change Password
  static const changePassword =
      '${NetworkEnvironment.baseURL}front/auth/changePassword';

  // Sports Type.
  static const sportsType = '${NetworkEnvironment.baseURL}common/getSportTypes';

  // Settings.
  static const settings = '${NetworkEnvironment.baseURL}common/getSetting';

  // Locations
  static const locations = '${NetworkEnvironment.baseURL}common/getLocations';

  // Levels
  static const levels = '${NetworkEnvironment.baseURL}common/getLevels';

  // Player type
  static const playerType = '${NetworkEnvironment.baseURL}common/getGenders';

  // Preferred Position
  static const getPositionBySportType =
      '${NetworkEnvironment.baseURL}common/getPositionBySportType';

  // Club/Player Register
  static const register = '${NetworkEnvironment.baseURL}front/auth/register';

  // Update club
  static const updateUserDetails =
      '${NetworkEnvironment.baseURL}front/users/updateUserDetails';

  // Club's board members.
  static const clubBoardMembers =
      '${NetworkEnvironment.baseURL}front/clubadmin';

  // Club's coaching staff.
  static const clubCoachingStaff =
      '${NetworkEnvironment.baseURL}front/coachingStaff';

  // Subscription
  static const subscriptionPlan =
      '${NetworkEnvironment.baseURL}front/subscription';

  // Cancel Subscription
  static const subscriptionPlanCancel =
      '${NetworkEnvironment.baseURL}front/subscription/cancelSubscription';

  // Get Free Subscription
  static const getFreeSubscription =
      '${NetworkEnvironment.baseURL}front/subscription/getFreeSubscription';

  // Post
  static const post = '${NetworkEnvironment.baseURL}front/posts';

  // RecentPostList
  static const recentPostList = '${NetworkEnvironment.baseURL}front/posts';

  static const postFilterType =
      '${NetworkEnvironment.baseURL}front/posts/postTypeList';

  // Recent activity
  static const getRecentPostList =
      '${NetworkEnvironment.baseURL}front/users/getRecentPostList';

  // Player list
  static const playerList =
      '${NetworkEnvironment.baseURL}front/users/getPlayerList';

  // Notification list
  static const notificationList =
      '${NetworkEnvironment.baseURL}front/users/getNotificationList';

  // Notification list
  static const readNotification =
      '${NetworkEnvironment.baseURL}front/users/readNotification';

  // Favourites.
  static const favourites = '${NetworkEnvironment.baseURL}front/favourites';

  // player profile privacy
  static const profilePrivacy = '${NetworkEnvironment.baseURL}front/users/addSelectedClubs';

  // player profile privacy
  static const selectedClub = '${NetworkEnvironment.baseURL}front/users/selectedClubList';

  // get club list
  static const clubList =
      '${NetworkEnvironment.baseURL}front/users/getClubList';

  // Player > Profile Privacy > Get user all clubs with is selected field
  static const selectedWithAllClub =
      '${NetworkEnvironment.baseURL}front/users/selectedWithAllClub';

  // Player > Profile Privacy > Get user selected clubs
  static const userSelectedClubToBeHiddenFrom =
      '${NetworkEnvironment.baseURL}front/users/hideSelectedClub';

  // search club list
  static const playerSearchClubResult =
      '${NetworkEnvironment.baseURL}front/users/getClubListing';


  // Selected favourite list
  static const selectedFavouriteList =
      '${NetworkEnvironment.baseURL}front/favourites/getSelectedFavouriteList';

  // Selected favourite list
  static const addSelectFavouriteList =
      '${NetworkEnvironment.baseURL}front/favourites/addFavouriteUser';

  // Get favourite list
  static const getFavouriteList =
      '${NetworkEnvironment.baseURL}front/favourites/getFavouriteList';

  // Delete favourites
  static const deleteFavourite =
      '${NetworkEnvironment.baseURL}front/favourites';

  // Follow/Unfollow
  static const followUnfollow =
      '${NetworkEnvironment.baseURL}front/users/followUnfollow';

  // Manage subscription
  static const manageSubscription =
      '${NetworkEnvironment.baseURL}front/subscription/manageSubscription';

  // Manage subscription
  static const upgradeSubscription =
      '${NetworkEnvironment.baseURL}front/subscription/upgradeSubscription';

  // Renew subscription
  static const renewSubscription =
      '${NetworkEnvironment.baseURL}front/subscription/renewSubscription';

  // Get user subscriptions
  static const getSelectedSportType =
      '${NetworkEnvironment.baseURL}front/users/getSelectedSportType';

  // Get user advertisements
  static const getAdvertisement =
      '${NetworkEnvironment.baseURL}front/advertisement';

  // Block user
  static const blockUser =
      '${NetworkEnvironment.baseURL}front/users/blockUnblockUser';

  // Blocked user
  static const blockedUserList =
      '${NetworkEnvironment.baseURL}front/users/getBlockUserList';

  // Report user
  static const reportUserMasterData =
      '${NetworkEnvironment.baseURL}common/getReportList';
  static const reportUser =
      '${NetworkEnvironment.baseURL}front/users/reportUser';

  // Blocked user
  static const checkIsUserBlock =
      '${NetworkEnvironment.baseURL}front/users/checkIsUserBlock';
}

abstract class NetworkParams {
  static const bearer = "bearer";
  static const headerAuthToken = "Authorization";
  static const password = "password";
  static const confirmPassword = "confirmPassword";
  static const name = "name";
  static const email = "email";
  static const data = "data";
  static const phoneNumber = "phoneNumber";
  static const address = "address";
  static const type = "type";
  static const selectedClubs = "selectedClubs";
  static const video = "video";
  static const introduction = "introduction";
  static const referenceAndInfo = "referenceAndInfo";
  static const bio = "bio";
  static const sportTypeId = "sportTypeId";
  static const locationDetail = "locationDetail";
  static const playerCategoryDetail = "playerCategoryDetail";
  static const locationId = "locationId";
  static const latitude = "latitude";
  static const longitude = "longitude";
  static const levelDetail = "levelDetail";
  static const deviceType = "deviceType";
  static const uuid = "uuid";
  static const osVersion = "osVersion";
  static const deviceName = "deviceName";
  static const modelName = "modelName";
  static const playerPosition = "playerPosition";
  static const ip = "ip";
  static const contactNumber = "contactNumber";
  static const speciality = "speciality";
  static const experience = "experience";
  static const gender = "gender";
  static const dateOfBirth = "dateOfBirth";
  static const forgotPasswordOtpCode = "forgotPasswordOtpCode";
  static const otpCode = "otpCode";
  static const isOtherContactInfo = "isOtherContactInfo";
  static const height = "height";
  static const weight = "weight";
  static const subscriptionId = "subscriptionId";
  static const userId = "userId";
  static const postTypeId = "postTypeId";
  static const favouriteListId = "favouriteListId";
  static const title = "title";
  static const otherDetails = "otherDetails";
  static const arrayImages = "Images";
  static const image = "image";
  static const deleteBannerImage = "deleteBannerImage";
  static const userImages = "userImages";
  static const selectDate = "selectDate";
  static const selectTime = "selectTime";
  static const highlights = "highlights";
  static const location = "location";
  static const score = "score";
  static const participantsA = "participantsA";
  static const participantsB = "participantsB";
  static const typeOfEvent = "typeOfEvent";
  static const age = "age";
  static const skill = "skill";
  static const level = "level";
  static const references = "references";
  static const search = "search";
  static const offset = "offset";
  static const limit = "limit";
  static const favouriteUserId = "favouriteUserId";
  static const selectedList = "selectedList";
  static const firebaseToken = "firebaseToken";
  static const firebaseUuid = "firebaseUuid";
  static const firebaseUserId = "firebaseUserId";
  static const locationName = "locationName";
  static const levelName = "levelName";
  static const sportTypeName = "sportTypeName";
  static const positionName = "positionName";
  static const reportUserId = "reportUserId";
  static const reportId = "reportId";
  static const description = "description";
}

abstract class NetworkConstants {
  static const password = "password";
  static const formUrlContentType = "application/x-www-form-urlencoded";
  static const validationError = 422;
  static const success = 200;
  static const created = 201;
  static const deleteSuccess = 204;
  static const unAuthenticate = 401;

  /// Form field validation error.
  static const fieldErrorStatus = 422;
}
