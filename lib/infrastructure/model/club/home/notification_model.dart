class NotificationModel {
  bool? status;
  int? code;
  List<NotificationData>? data;
  String? message;

  NotificationModel({this.status, this.code, this.data, this.message});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    if (json['data'] != null) {
      data = <NotificationData>[];
      json['data'].forEach((v) {
        data!.add(new NotificationData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class NotificationData {
  int? id;
  int? userId;
  int? fromUserId;
  String? description;
  String? isRead;
  String? createdAt;
  String? updatedAt;
  FromUserDetails? fromUserDetails;

  NotificationData(
      {this.id,
      this.userId,
      this.fromUserId,
      this.description,
      this.isRead,
      this.createdAt,
      this.updatedAt,
      this.fromUserDetails});

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    fromUserId = json['fromUserId'];
    description = json['description'];
    isRead = json['isRead'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    fromUserDetails = json['fromUserDetails'] != null
        ? new FromUserDetails.fromJson(json['fromUserDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['fromUserId'] = this.fromUserId;
    data['description'] = this.description;
    data['isRead'] = this.isRead;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.fromUserDetails != null) {
      data['fromUserDetails'] = this.fromUserDetails!.toJson();
    }
    return data;
  }
}

class FromUserDetails {
  int? id;
  String? name;
  String? email;
  String? password;
  String? phoneNumber;
  String? address;
  String? gender;
  int? height;
  int? weight;
  String? dateOfBirth;
  int? age;
  String? video;
  String? profileImage;
  String? type;
  int? otpCode;
  String? otpExpireTime;
  int? forgotPasswordOtpCode;
  String? forgotPasswordExpireTime;
  String? bio;
  String? introduction;
  String? referenceAndInfo;
  String? firebaseUserId;
  String? isBlock;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  FromUserDetails(
      {this.id,
      this.name,
      this.email,
      this.password,
      this.phoneNumber,
      this.address,
      this.gender,
      this.height,
      this.weight,
      this.dateOfBirth,
      this.age,
      this.video,
      this.profileImage,
      this.type,
      this.otpCode,
      this.otpExpireTime,
      this.forgotPasswordOtpCode,
      this.forgotPasswordExpireTime,
      this.bio,
      this.introduction,
      this.referenceAndInfo,
      this.firebaseUserId,
      this.isBlock,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  FromUserDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    gender = json['gender'];
    height = json['height'];
    weight = json['weight'];
    dateOfBirth = json['dateOfBirth'];
    age = json['age'];
    video = json['video'];
    profileImage = json['profileImage'];
    type = json['type'];
    otpCode = json['otpCode'];
    otpExpireTime = json['otpExpireTime'];
    forgotPasswordOtpCode = json['forgotPasswordOtpCode'];
    forgotPasswordExpireTime = json['forgotPasswordExpireTime'];
    bio = json['bio'];
    introduction = json['introduction'];
    referenceAndInfo = json['referenceAndInfo'];
    firebaseUserId = json['firebaseUserId'];
    isBlock = json['isBlock'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['phoneNumber'] = this.phoneNumber;
    data['address'] = this.address;
    data['gender'] = this.gender;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['dateOfBirth'] = this.dateOfBirth;
    data['age'] = this.age;
    data['video'] = this.video;
    data['profileImage'] = this.profileImage;
    data['type'] = this.type;
    data['otpCode'] = this.otpCode;
    data['otpExpireTime'] = this.otpExpireTime;
    data['forgotPasswordOtpCode'] = this.forgotPasswordOtpCode;
    data['forgotPasswordExpireTime'] = this.forgotPasswordExpireTime;
    data['bio'] = this.bio;
    data['introduction'] = this.introduction;
    data['referenceAndInfo'] = this.referenceAndInfo;
    data['firebaseUserId'] = this.firebaseUserId;
    data['isBlock'] = this.isBlock;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    return data;
  }
}
