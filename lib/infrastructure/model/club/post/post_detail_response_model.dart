import 'package:game_on_flutter/infrastructure/model/club/post/post_list_model.dart';

class PostDetailResponseModel {
  bool? status;
  int? code;
  PostListResponseData? data;
  String? message;

  PostDetailResponseModel({this.status, this.code, this.data, this.message});

  PostDetailResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    data = json['data'] != null ? PostListResponseData.fromJson(json['data']) : null;
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