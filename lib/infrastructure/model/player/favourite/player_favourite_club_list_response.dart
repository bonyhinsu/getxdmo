import '../../club/favourite/favourite_player_response_model.dart';

class PlayerFavouriteClubListResponse {
  bool? status;
  int? code;
  List<PlayerFavouriteClubListResponseData>? data;
  String? message;

  PlayerFavouriteClubListResponse(
      {this.status, this.code, this.data, this.message});

  PlayerFavouriteClubListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    if (json['data'] != null) {
      data = <PlayerFavouriteClubListResponseData>[];
      json['data'].forEach((v) {
        data!.add(PlayerFavouriteClubListResponseData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    data['code'] = code;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class PlayerFavouriteClubListResponseData {
  int? id;
  int? userId;
  int? favouriteUserId;
  int? favouriteListId;
  String? createdAt;
  String? updatedAt;
  FavouriteListDetails? favouriteListDetails;
  FavouriteUserDetails? favouriteUserDetails;
  List<Positions>? positions;
  List<Locations>? locations;
  List<Sports>? sports;
  List<Levels>? levels;
  List<Genders>? genders;


  PlayerFavouriteClubListResponseData(
      {this.id,
      this.userId,
      this.favouriteUserId,
      this.favouriteListId,
      this.createdAt,
      this.updatedAt,
      this.favouriteListDetails,
      this.favouriteUserDetails,
      this.positions,
      this.locations});

  PlayerFavouriteClubListResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    favouriteUserId = json['favouriteUserId'];
    favouriteListId = json['favouriteListId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    favouriteListDetails = json['favouriteListDetails'] != null
        ? FavouriteListDetails.fromJson(json['favouriteListDetails'])
        : null;
    favouriteUserDetails = json['favouriteUserDetails'] != null
        ? FavouriteUserDetails.fromJson(json['favouriteUserDetails'])
        : null;
    if (json['positions'] != null) {
      positions = <Positions>[];
      json['positions'].forEach((v) {
        positions!.add(Positions.fromJson(v));
      });
    }
    if (json['locations'] != null) {
      locations = <Locations>[];
      json['locations'].forEach((v) {
        locations!.add(Locations.fromJson(v));
      });
    }

    if (json['sports'] != null) {
      sports = <Sports>[];
      json['sports'].forEach((v) {
        sports!.add(new Sports.fromJson(v));
      });
    }
    if (json['levels'] != null) {
      levels = <Levels>[];
      json['levels'].forEach((v) {
        levels!.add(new Levels.fromJson(v));
      });
    }
    if (json['genders'] != null) {
      genders = <Genders>[];
      json['genders'].forEach((v) {
        genders!.add(new Genders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['userId'] = userId;
    data['favouriteUserId'] = favouriteUserId;
    data['favouriteListId'] = favouriteListId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (favouriteListDetails != null) {
      data['favouriteListDetails'] = favouriteListDetails!.toJson();
    }
    if (favouriteUserDetails != null) {
      data['favouriteUserDetails'] = favouriteUserDetails!.toJson();
    }
    if (positions != null) {
      data['positions'] = positions!.map((v) => v.toJson()).toList();
    }
    if (locations != null) {
      data['locations'] = locations!.map((v) => v.toJson()).toList();
    }
    if (levels != null) {
      data['levels'] = levels!.map((v) => v.toJson()).toList();
    }
    if (genders != null) {
      data['genders'] = genders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FavouriteListDetails {
  int? id;
  int? userId;
  String? name;
  String? createdAt;
  String? updatedAt;

  FavouriteListDetails(
      {this.id, this.userId, this.name, this.createdAt, this.updatedAt});

  FavouriteListDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['userId'] = userId;
    data['name'] = name;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class FavouriteUserDetails {
  int? id;
  String? name;
  String? email;
  String? password;
  String? phoneNumber;
  String? address;
  String? video;
  String? profileImage;
  String? type;
  String? bio;
  String? introduction;
  String? referenceAndInfo;
  String? firebaseUserId;
  String? isBlock;

  FavouriteUserDetails(
      {this.id,
      this.name,
      this.email,
      this.password,
      this.phoneNumber,
      this.address,
      this.video,
      this.profileImage,
      this.type,
      this.bio,
      this.introduction,
      this.referenceAndInfo,
      this.firebaseUserId,
      this.isBlock,
      });

  FavouriteUserDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    video = json['video'];
    profileImage = json['profileImage'];
    type = json['type'];
    bio = json['bio'];
    introduction = json['introduction'];
    referenceAndInfo = json['referenceAndInfo'];
    firebaseUserId = json['firebaseUserId'];
    isBlock = json['isBlock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['phoneNumber'] = phoneNumber;
    data['address'] = address;
    data['video'] = video;
    data['profileImage'] = profileImage;
    data['type'] = type;
    data['bio'] = bio;
    data['introduction'] = introduction;
    data['referenceAndInfo'] = referenceAndInfo;
    data['firebaseUserId'] = firebaseUserId;
    data['isBlock'] = isBlock;
    return data;
  }
}

class Locations {
  int? id;
  int? userSportDetailId;
  int? locationId;
  Null? latitude;
  Null? longitude;
  String? createdAt;
  String? updatedAt;
  LocationDetails? locationDetails;

  Locations(
      {this.id,
      this.userSportDetailId,
      this.locationId,
      this.latitude,
      this.longitude,
      this.createdAt,
      this.updatedAt,
      this.locationDetails});

  Locations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userSportDetailId = json['userSportDetailId'];
    locationId = json['locationId'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    locationDetails = json['locationDetails'] != null
        ? LocationDetails.fromJson(json['locationDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['userSportDetailId'] = userSportDetailId;
    data['locationId'] = locationId;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
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
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  LocationDetails(
      {this.id,
      this.name,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  LocationDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deletedAt'] = deletedAt;
    return data;
  }
}
class Sports {
  int? id;
  int? userId;
  int? sportTypeId;
  String? createdAt;
  String? updatedAt;
  SportTypeDetails? sportTypeDetails;

  Sports(
      {this.id,
        this.userId,
        this.sportTypeId,
        this.createdAt,
        this.updatedAt,
        this.sportTypeDetails});

  Sports.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    sportTypeId = json['sportTypeId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    sportTypeDetails = json['sportTypeDetails'] != null
        ? new SportTypeDetails.fromJson(json['sportTypeDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['userId'] = userId;
    data['sportTypeId'] = sportTypeId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (sportTypeDetails != null) {
      data['sportTypeDetails'] = sportTypeDetails!.toJson();
    }
    return data;
  }
}


class SportTypeDetails {
  int? id;
  String? name;
  String? slug;
  String? logo;
  String? croppedLogo;
  String? status;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  SportTypeDetails(
      {this.id,
        this.name,
        this.slug,
        this.logo,
        this.croppedLogo,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  SportTypeDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    logo = json['logo'];
    croppedLogo = json['croppedLogo'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['logo'] = logo;
    data['croppedLogo'] = croppedLogo;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deletedAt'] = deletedAt;
    return data;
  }
}
class Levels {
  int? id;
  int? userSportDetailId;
  int? levelId;
  String? createdAt;
  String? updatedAt;
  LocationDetails? levelDetails;

  Levels(
      {this.id,
        this.userSportDetailId,
        this.levelId,
        this.createdAt,
        this.updatedAt,
        this.levelDetails});

  Levels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userSportDetailId = json['userSportDetailId'];
    levelId = json['levelId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    levelDetails = json['levelDetails'] != null
        ? new LocationDetails.fromJson(json['levelDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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

class Genders {
  int? id;
  int? userSportDetailId;
  int? genderId;
  String? createdAt;
  String? updatedAt;
  GenderDetails? genderDetails;

  Genders(
      {this.id,
        this.userSportDetailId,
        this.genderId,
        this.createdAt,
        this.updatedAt,
        this.genderDetails});

  Genders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userSportDetailId = json['userSportDetailId'];
    genderId = json['genderId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    genderDetails = json['genderDetails'] != null
        ? new GenderDetails.fromJson(json['genderDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['userSportDetailId'] = userSportDetailId;
    data['genderId'] = genderId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (genderDetails != null) {
      data['genderDetails'] = genderDetails!.toJson();
    }
    return data;
  }
}

class GenderDetails {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  GenderDetails({this.id, this.name, this.createdAt, this.updatedAt});

  GenderDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}