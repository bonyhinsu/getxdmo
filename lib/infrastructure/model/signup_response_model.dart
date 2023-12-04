import 'package:game_on_flutter/infrastructure/model/user_info_model.dart';

class SignupResponse {
  bool? status;
  int? code;
  SignupResponseData? data;
  String? message;

  SignupResponse({this.status, this.code, this.data, this.message});

  SignupResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    data =
        json['data'] != null ? SignupResponseData.fromJson(json['data']) : null;
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

class SignupResponseData {
  String? token;
  UserDetails? user;

  SignupResponseData({this.token, this.user});

  SignupResponseData.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null ? UserDetails.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
