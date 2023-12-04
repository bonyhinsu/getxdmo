import 'package:game_on_flutter/infrastructure/model/user_info_model.dart';

class UserPrivacyResponse {
  bool? status;
  int? code;
  List<UserPrivacyResponseData>? data;
  String? message;

  UserPrivacyResponse({this.status, this.code, this.data, this.message});

  UserPrivacyResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    if (json['data'] != null) {
      data = <UserPrivacyResponseData>[];
      json['data'].forEach((v) {
        data!.add(UserPrivacyResponseData.fromJson(v));
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

class UserPrivacyResponseData {
  int? id;
  int? userId;
  int? clubId;
  String? type;
  String? createdAt;
  String? updatedAt;
  bool? isSelected;
  UserDetails? clubDetails;

  UserPrivacyResponseData(
      {this.id,
        this.userId,
        this.clubId,
        this.type,
        this.createdAt,
        this.updatedAt,
        this.isSelected,
        this.clubDetails});

  UserPrivacyResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    clubId = json['clubId'];
    type = json['type'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    isSelected = json['isSelected'];
    clubDetails = json['clubDetails'] != null
        ? UserDetails.fromJson(json['clubDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['userId'] = userId;
    data['clubId'] = clubId;
    data['type'] = type;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['isSelected'] = isSelected;
    if (clubDetails != null) {
      data['clubDetails'] = clubDetails!.toJson();
    }
    return data;
  }
}