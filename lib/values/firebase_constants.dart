/// Constants for database fields.
class FirebaseModelParams {
  static const String fcmToken = "fcmToken";
  static const String EMAIL = "email";
  static const String UUID = "uuid";
  static const String PROFILE_PICTURE = "profilePicture";
  static const String name = "senderName";
  static const String sender = "sender";
  static const String userId = "userId";
  static const String USER_NAME = "userName";
  static const String receiver = "receiver";
  static const String messageTime = "messageTime";
  static const String lastMessageTime = "lastMessageTime";
  static const String message = "message";
  static const String messageText = "messageText";
  static const String attachment = "attachment";
  static const String hasAttachment = "hasAttachment";
  static const String attachmentType = "attachmentType";
  static const String messageType = "messageType";
  static const String members = "members";
  static const String lastMessageSent = "lastMessageSent";
  static const String sentBy = "sentBy";
  static const String isRead = "isRead";
  static const String isGroup = "isGroup";
  static const String groupAdmin = "groupAdmin";
  static const String threadId = "threadId";
  static const String groupProfilePicture = "groupProfilePicture";
  static const String updatedAt = "updatedAt";
  static const String isMute = "isMute";
  static const String messageId = "messageId";
  static const String groups = "groups";
  static const String DEVICE_TYPE = "deviceType";
  static const String BUILD_NUMBER = "buildNumber";
  static const String BUILD_VERSION = "buildVersion";
  static const String LAST_LOGIN_TIME = "lastLoginTime";
  static const String USER_TYPE = "userType";
  static const String PHONE_NUMBER = "phoneNumber";
}

/// Constants for database document path.
class FirebaseDocumentConstants {
  static const String users = "/users";
  static const String messages = "/messages";
  static const String groupInfo = "/group_info";
  static const String chatWith = "/chat_with";
  static const String group = "/group";
  static const String members = "/members";
  static const String unreadMessage = "/unread_messages";
}
