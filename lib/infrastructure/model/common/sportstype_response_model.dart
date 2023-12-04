import 'base_response_model.dart';

class SportTypeListResponseModel {
  bool? status;
  int? code;
  String? message;
  List<SportTypeResponseModelData>? data;

  SportTypeListResponseModel({this.status, this.message, this.data});

  SportTypeListResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    if (json['data'] != null) {
      data = <SportTypeResponseModelData>[];
      json['data'].forEach((v) {
        data!.add(SportTypeResponseModelData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() => {
    "code": code,
    "status": status,
    "message": message,
    "data": {},
  };
}

class SportTypeResponseModelData{
  int? id;
  String? name;
  String? slug;
  String? logo;
  String? description;
  String? createdAt;
  String? updatedAt;

  SportTypeResponseModelData(
      {this.id,
        this.name,
        this.slug,
        this.logo,
        this.description,
        this.createdAt,
        this.updatedAt});

  SportTypeResponseModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    logo = json['logo'];
    description = json['description'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['logo'] = logo;
    data['description'] = description;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}