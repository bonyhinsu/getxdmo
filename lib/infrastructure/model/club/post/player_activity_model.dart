import 'package:game_on_flutter/infrastructure/model/club/post/player_activity_model.dart';
import 'package:game_on_flutter/infrastructure/model/club/post/player_activity_model.dart';

class ClubActivityListModel {
  bool? status;
  int? code;
  List<ClubActivityListModelData>? data;
  String? message;

  ClubActivityListModel({this.status, this.code, this.data, this.message});

  ClubActivityListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    if (json['data'] != null) {
      data = <ClubActivityListModelData>[];
      json['data'].forEach((v) {
        data!.add(new ClubActivityListModelData.fromJson(v));
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

class ClubActivityListModelData {
  int? id;
  String? name;
  String? profileImage;
  String? gender;
  String? username;
  String? type;
  int? age;
  String? bio;
  String? referenceAndInfo;
  String? createdAt;
  String? updatedAt;
  int? positionId;
  String? positionsName;
  int? userSportDetailsId;
  String? sportTypeName;
  int? locationsId;
  num? latitude;
  num? longitude;
  List<ClubDetails>? clubDetails;
  String? allLocation;
  String? allLevels;
  int? isFavourite;
  bool? isSelected;

  ClubActivityListModelData(
      {this.id,
      this.name,
      this.profileImage,
      this.gender,
      this.age,
      this.username,
      this.bio,
      this.referenceAndInfo,
      this.createdAt,
      this.clubDetails,
      this.updatedAt,
      this.positionId,
      this.type,
      this.isSelected,
      this.positionsName,
      this.userSportDetailsId,
      this.sportTypeName,
      this.locationsId,
      this.latitude,
      this.longitude,
      this.allLocation,
      this.allLevels,
      this.isFavourite});

  ClubActivityListModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    profileImage = json['profileImage'];
    gender = json['gender'];
    age = json['age'];
    bio = json['bio'];
    referenceAndInfo = json['referenceAndInfo'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    type = json['type'];
    positionId = json['positionId'];
    positionsName = json['positions_name'];
    userSportDetailsId = json['userSportDetailsId'];
    sportTypeName = json['sportTypeName'];
    locationsId = json['locationsId'];
    latitude = json['latitude'];
    isSelected = json['isSelected'];
    longitude = json['longitude'];
    allLocation = json['allLocation'];
    allLevels = json['allLevels'];
    isFavourite = json['isFavourite'];
    username = json['username'];
    if (json['clubDetails'] != null) {
      clubDetails = <ClubDetails>[];
      json['clubDetails'].forEach((v) {
        clubDetails!.add(new ClubDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['profileImage'] = this.profileImage;
    data['gender'] = this.gender;
    data['age'] = this.age;
    data['bio'] = this.bio;
    data['referenceAndInfo'] = this.referenceAndInfo;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['positionId'] = this.positionId;
    data['positions_name'] = this.positionsName;
    data['userSportDetailsId'] = this.userSportDetailsId;
    data['sportTypeName'] = this.sportTypeName;
    data['locationsId'] = this.locationsId;
    data['latitude'] = this.latitude;
    data['isSelected'] = this.isSelected;
    data['longitude'] = this.longitude;
    data['allLocation'] = this.allLocation;
    data['allLevels'] = this.allLevels;
    data['type'] = this.type;
    data['isFavourite'] = this.isFavourite;
    data['username'] = this.username;

    if (this.clubDetails != null) {
      data['clubDetails'] = this.clubDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ClubDetails {
  int? id;
  String? name;
  String? profileImage;
  String? type;

  ClubDetails({this.id, this.name, this.profileImage, this.type});

  ClubDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    profileImage = json['profileImage'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['profileImage'] = this.profileImage;
    data['type'] = this.type;
    return data;
  }
}
