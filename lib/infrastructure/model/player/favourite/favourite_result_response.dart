class FavouriteResultResponse {
  bool? status;
  int? code;
  List<FavouriteResultResponseData>? data;
  String? message;

  FavouriteResultResponse({this.status, this.code, this.data, this.message});

  FavouriteResultResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    if (json['data'] != null) {
      data = <FavouriteResultResponseData>[];
      json['data'].forEach((v) {
        data!.add(new FavouriteResultResponseData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['code'] = code;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class FavouriteResultResponseData {
  int? id;
  String? name;
  String? email;
  String? address;
  String? profileImage;
  String? gender;
  String? age;
  String? bio;
  String? isBlock;
  String? phoneNumber;
  String? dateOfBirth;
  String? introduction;
  String? referenceAndInfo;
  String? createdAt;
  String? updatedAt;
  int? userSportDetailsId;
  int? locationsId;
  int? isFavourite;
  String? latitude;
  String? longitude;
  String? allLocation;
  String? allGenders;
  String? allSport;
  String? allLevels;
  String? allSportImage;

  FavouriteResultResponseData(
      {this.id,
        this.name,
        this.email,
        this.address,
        this.profileImage,
        this.gender,
        this.age,
        this.bio,
        this.isBlock,
        this.phoneNumber,
        this.dateOfBirth,
        this.introduction,
        this.referenceAndInfo,
        this.createdAt,
        this.updatedAt,
        this.userSportDetailsId,
        this.locationsId,
        this.latitude,
        this.longitude,
        this.allLocation,
        this.allGenders,
        this.allSport,
        this.allLevels,
        this.allSportImage});

  FavouriteResultResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    address = json['address'];
    profileImage = json['profileImage'];
    gender = json['gender'];
    age = json['age'] is int?(json['age']).toString():json['age'];
    isFavourite = json['isFavourite'];
    bio = json['bio'];
    isBlock = json['isBlock'];
    phoneNumber = json['phoneNumber'];
    dateOfBirth = json['dateOfBirth'];
    introduction = json['introduction'];
    referenceAndInfo = json['referenceAndInfo'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userSportDetailsId = json['userSportDetailsId'];
    locationsId = json['locationsId'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    allLocation = json['allLocation'];
    allGenders = json['allGenders'];
    allSport = json['allSport'];
    allLevels = json['allLevels'];
    allSportImage = json['allSportImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['address'] = address;
    data['profileImage'] = profileImage;
    data['gender'] = gender;
    data['age'] = age;
    data['bio'] = bio;
    data['isBlock'] = isBlock;
    data['phoneNumber'] = phoneNumber;
    data['dateOfBirth'] = dateOfBirth;
    data['introduction'] = introduction;
    data['referenceAndInfo'] = referenceAndInfo;
    data['createdAt'] = createdAt;
    data['isFavourite'] = isFavourite;
    data['updatedAt'] = updatedAt;
    data['userSportDetailsId'] = userSportDetailsId;
    data['locationsId'] = locationsId;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['allLocation'] = allLocation;
    data['allGenders'] = allGenders;
    data['allSport'] = allSport;
    data['allLevels'] = allLevels;
    data['allSportImage'] = allSportImage;
    return data;
  }
}