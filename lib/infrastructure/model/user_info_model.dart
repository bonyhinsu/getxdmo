import 'package:game_on_flutter/infrastructure/model/subscription/user_subscription_model.dart';

import 'coaching_staff_response.dart';

class UserDetails {
  int? id;
  String? name;
  String? email;
  String? password;
  String? phoneNumber;
  String? address;
  String? gender;
  String? height;
  String? weight;
  String? dateOfBirth;
  String? video;
  String? profileImage;
  String? type;
  String? age;
  String? bio;
  String? introduction;
  String? referenceAndInfo;
  String? firebaseUserId;
  String? level;
  String? sports;
  String? location;
  List<UserSportsDetails>? userSportsDetails;
  List<PlayerPositionDetails>? playerPositionDetails;
  List<UserPhotos>? userPhotos;
  List<ClubAdminDetails>? clubAdminDetails;
  List<CoachingStaffResponseModelData>? coachingStaffDetails;
  int? isFavourite;
  int? followerCount;
  int? isFollow;
  String commaSeparatedLocations= "";
  String commaSeparatedLevels= "";
  String commaSeparatedSports= "";
  String commaSeparatedPreferredPositions= "";

  UserDetails({
    this.id,
    this.name,
    this.email,
    this.password,
    this.phoneNumber,
    this.address,
    this.gender,
    this.height,
    this.weight,
    this.dateOfBirth,
    this.video,
    this.profileImage,
    this.type,
    this.age,
    this.bio,
    this.introduction,
    this.referenceAndInfo,
  });

  UserDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    gender = json['gender'];
    height = json['height'] is num?json['height'].toString():json['height'];
    weight = json['weight'] is num?json['weight'].toString():json['weight'];
    dateOfBirth = json['dateOfBirth'];
    video = json['video'];
    profileImage = json['profileImage'];
    type = json['type'];
    bio = json['bio'];
    firebaseUserId = json['firebaseUserId'];
    age = json['age'] is int ? json['age'].toString() : json['age'];
    introduction = json['introduction'];
    referenceAndInfo = json['referenceAndInfo'];
    if (json['userSportsDetails'] != null) {
      userSportsDetails = <UserSportsDetails>[];
      json['userSportsDetails'].forEach((v) {
        userSportsDetails!.add(UserSportsDetails.fromJson(v));
      });
    }
    if (json['playerPositionDetails'] != null) {
      playerPositionDetails = <PlayerPositionDetails>[];
      json['playerPositionDetails'].forEach((v) {
        playerPositionDetails!.add(PlayerPositionDetails.fromJson(v));
      });
    }
    if (json['userPhotos'] != null) {
      userPhotos = <UserPhotos>[];
      json['userPhotos'].forEach((v) {
        userPhotos!.add(UserPhotos.fromJson(v));
      });
    }
    if (json['clubAdminDetails'] != null) {
      clubAdminDetails = <ClubAdminDetails>[];
      json['clubAdminDetails'].forEach((v) {
        clubAdminDetails!.add(ClubAdminDetails.fromJson(v));
      });
    }
    if (json['coachingStaffDetails'] != null) {
      coachingStaffDetails = <CoachingStaffResponseModelData>[];
      json['coachingStaffDetails'].forEach((v) {
        coachingStaffDetails!.add(CoachingStaffResponseModelData.fromJson(v));
      });
    }
    isFavourite = json['isFavourite'];
    followerCount = json['followerCount'];
    isFollow = json['isFollow'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['phoneNumber'] = phoneNumber;
    data['address'] = address;
    data['gender'] = gender;
    data['height'] = height;
    data['weight'] = weight;
    data['dateOfBirth'] = dateOfBirth;
    data['video'] = video;
    data['profileImage'] = profileImage;
    data['type'] = type;
    data['bio'] = bio;
    data['age'] = age;
    data['firebaseUserId'] = firebaseUserId;
    data['introduction'] = introduction;
    data['referenceAndInfo'] = referenceAndInfo;
    if (userSportsDetails != null) {
      data['userSportsDetails'] =
          userSportsDetails!.map((v) => v.toJson()).toList();
    }
    if (playerPositionDetails != null) {
      data['playerPositionDetails'] =
          playerPositionDetails!.map((v) => v.toJson()).toList();
    }
    if (userPhotos != null) {
      data['userPhotos'] = userPhotos!.map((v) => v.toJson()).toList();
    }
    if (clubAdminDetails != null) {
      data['clubAdminDetails'] =
          clubAdminDetails!.map((v) => v.toJson()).toList();
    }
    if (coachingStaffDetails != null) {
      data['coachingStaffDetails'] =
          coachingStaffDetails!.map((v) => v.toJson()).toList();
    }
    data['isFavourite'] = isFavourite;
    data['followerCount'] = followerCount;
    data['isFollow'] = isFollow;
    return data;
  }
}

class UserSportsDetails {
  int? id;
  int? userId;
  int? sportTypeId;
  SportTypeDetails? sportTypeDetails;
  List<UserLocationDetails>? userLocationDetails;
  List<UserLevelDetails>? userLevelDetails;
  List<PlayerCategory>? userPlayerCategory;
  List<SubscriptionDetails>? subscriptionDetails;

  UserSportsDetails(
      {this.id,
      this.userId,
      this.sportTypeId,
      this.sportTypeDetails,
      this.userPlayerCategory,
      this.userLocationDetails,
      this.subscriptionDetails,
      this.userLevelDetails});

  UserSportsDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    sportTypeId = json['sportTypeId'];
    sportTypeDetails = json['sportTypeDetails'] != null
        ? SportTypeDetails.fromJson(json['sportTypeDetails'])
        : null;
    if (json['userLocationDetails'] != null) {
      userLocationDetails = <UserLocationDetails>[];
      json['userLocationDetails'].forEach((v) {
        userLocationDetails!.add(UserLocationDetails.fromJson(v));
      });
    }
    if (json['userPlayerCategory'] != null) {
      userPlayerCategory = <PlayerCategory>[];
      json['userPlayerCategory'].forEach((v) {
        userPlayerCategory!.add(PlayerCategory.fromJson(v));
      });
    }
    if (json['userLevelDetails'] != null) {
      userLevelDetails = <UserLevelDetails>[];
      json['userLevelDetails'].forEach((v) {
        userLevelDetails!.add(UserLevelDetails.fromJson(v));
      });
    }
    if (json['userSubscriptionDetails'] != null) {
      subscriptionDetails = <SubscriptionDetails>[];
      json['userSubscriptionDetails'].forEach((v) {
        subscriptionDetails!.add(SubscriptionDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['sportTypeId'] = sportTypeId;
    if (sportTypeDetails != null) {
      data['sportTypeDetails'] = sportTypeDetails!.toJson();
    }
    if (userLocationDetails != null) {
      data['userLocationDetails'] =
          userLocationDetails!.map((v) => v.toJson()).toList();
    }
    if (userLevelDetails != null) {
      data['userLevelDetails'] =
          userLevelDetails!.map((v) => v.toJson()).toList();
    }
    if (userPlayerCategory != null) {
      data['userPlayerCategory'] =
          userPlayerCategory!.map((v) => v.toJson()).toList();
    }
    if (subscriptionDetails != null) {
      data['userSubscriptionDetails'] =
          subscriptionDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SportTypeDetails {
  int? id;
  String? name;
  String? slug;
  String? logo;
  String? status;

  SportTypeDetails({
    this.id,
    this.name,
    this.slug,
    this.logo,
    this.status,
  });

  SportTypeDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    logo = json['logo'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['logo'] = logo;
    data['status'] = status;
    return data;
  }
}

class PlayerCategory {
  int? id;
  String? name;
  String? slug;
  int? genderId;
  String? status;

  PlayerCategory({
    this.id,
    this.name,
    this.slug,
    this.genderId,
    this.status,
  });

  PlayerCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    genderId = json['genderId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['genderId'] = genderId;
    data['status'] = status;
    return data;
  }
}

class UserLocationDetails {
  int? id;
  int? userSportDetailId;
  int? locationId;
  num? latitude;
  num? longitude;
  LocationDetails? locationDetails;

  UserLocationDetails(
      {this.id,
      this.userSportDetailId,
      this.locationId,
      this.latitude,
      this.longitude,
      this.locationDetails});

  UserLocationDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userSportDetailId = json['userSportDetailId'];
    locationId = json['locationId'];
    latitude = json['latitude'] is String
        ? num.parse(json['latitude'] ?? "0")
        : json['latitude'];
    longitude = json['longitude'] is String
        ? num.parse(json['longitude'] ?? "0")
        : json['longitude'];
    locationDetails = json['locationDetails'] != null
        ? LocationDetails.fromJson(json['locationDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userSportDetailId'] = userSportDetailId;
    data['locationId'] = locationId;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    if (locationDetails != null) {
      data['locationDetails'] = locationDetails!.toJson();
    }
    return data;
  }
}

class LocationDetails {
  int? id;
  String? name;
  String? status;

  LocationDetails({
    this.id,
    this.name,
    this.status,
  });

  LocationDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['status'] = status;
    return data;
  }
}

class UserLevelDetails {
  int? id;
  int? userSportDetailId;
  int? levelId;
  String? createdAt;
  String? updatedAt;
  LocationDetails? levelDetails;

  UserLevelDetails(
      {this.id,
      this.userSportDetailId,
      this.levelId,
      this.createdAt,
      this.updatedAt,
      this.levelDetails});

  UserLevelDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userSportDetailId = json['userSportDetailId'];
    levelId = json['levelId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    levelDetails = json['levelDetails'] != null
        ? LocationDetails.fromJson(json['levelDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userSportDetailId'] = userSportDetailId;
    data['levelId'] = levelId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (levelDetails != null) {
      data['levelDetails'] = levelDetails!.toJson();
    }
    return data;
  }
}

class ClubAdminDetails {
  int? id;
  int? userId;
  String? name;
  String? email;
  String? contactNumber;
  String? type;
  bool? isOtherContactInfo;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  ClubAdminDetails(
      {this.id,
      this.userId,
      this.name,
      this.email,
      this.contactNumber,
      this.type,
      this.isOtherContactInfo,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  ClubAdminDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    name = json['name'];
    email = json['email'];
    contactNumber = json['contactNumber'];
    type = json['type'];
    isOtherContactInfo = json['isOtherContactInfo'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['name'] = name;
    data['email'] = email;
    data['contactNumber'] = contactNumber;
    data['type'] = type;
    data['isOtherContactInfo'] = isOtherContactInfo;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deletedAt'] = deletedAt;
    return data;
  }
}
class PlayerPositionDetails {
  int? id;
  int? userId;
  int? positionId;
  String? createdAt;
  String? updatedAt;
  PositionData? positionData;

  PlayerPositionDetails(
      {this.id,
        this.userId,
        this.positionId,
        this.createdAt,
        this.updatedAt,
        this.positionData});

  PlayerPositionDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    positionId = json['positionId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    positionData = json['positionData'] != null
        ? new PositionData.fromJson(json['positionData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['positionId'] = this.positionId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.positionData != null) {
      data['positionData'] = this.positionData!.toJson();
    }
    return data;
  }
}

class PositionData {
  int? id;
  String? name;
  String? description;
  int? sportTypeId;
  String? createdAt;
  String? updatedAt;

  PositionData(
      {this.id,
        this.name,
        this.description,
        this.sportTypeId,
        this.createdAt,
        this.updatedAt});

  PositionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    sportTypeId = json['sportTypeId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['sportTypeId'] = this.sportTypeId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
class UserPhotos {
  int? id;
  int? userId;
  String? image;
  String? createdAt;
  String? updatedAt;

  UserPhotos(
      {this.id, this.userId, this.image, this.createdAt, this.updatedAt});

  UserPhotos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    image = json['image'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['image'] = this.image;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}