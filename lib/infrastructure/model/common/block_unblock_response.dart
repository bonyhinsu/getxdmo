import 'package:game_on_flutter/infrastructure/model/user_info_model.dart';

class BlockUnblockUserResponse {
  bool? status;
  int? code;
  List<BlockUnblockUserResponseData>? data;
  String? message;

  BlockUnblockUserResponse({this.status, this.code, this.data, this.message});

  BlockUnblockUserResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    if (json['data'] != null) {
      data = <BlockUnblockUserResponseData>[];
      json['data'].forEach((v) {
        data!.add(new BlockUnblockUserResponseData.fromJson(v));
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

class BlockUnblockUserResponseData {
  int? id;
  int? userId;
  int? blockUserId;
  String? createdAt;
  String? updatedAt;
  UserDetails? blockUserDetails;

  BlockUnblockUserResponseData(
      {this.id,
        this.userId,
        this.blockUserId,
        this.createdAt,
        this.updatedAt,
        this.blockUserDetails});

  BlockUnblockUserResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    blockUserId = json['blockUserId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    blockUserDetails = json['blockUserDetails'] != null
        ? UserDetails.fromJson(json['blockUserDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['userId'] = userId;
    data['blockUserId'] = blockUserId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (blockUserDetails != null) {
      data['blockUserDetails'] = blockUserDetails!.toJson();
    }
    return data;
  }
}