import 'package:game_on_flutter/infrastructure/model/user_info_model.dart';

class UserDetailResponseModel {
  bool? status;
  int? code;
  UserDetails? data;
  String? message;

  UserDetailResponseModel({this.status, this.code, this.data, this.message});

  UserDetailResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    data = json['data'] != null ? UserDetails.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}
