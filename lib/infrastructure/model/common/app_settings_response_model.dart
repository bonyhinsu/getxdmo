class AppSettingsResponseModel {
  bool? status;
  int? code;
  List<AppSettingsResponseModelData>? data;
  String? message;

  AppSettingsResponseModel({this.status, this.code, this.data, this.message});

  AppSettingsResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    if (json['data'] != null) {
      data = <AppSettingsResponseModelData>[];
      json['data'].forEach((v) {
        data!.add(AppSettingsResponseModelData.fromJson(v));
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

class AppSettingsResponseModelData {
  int? id;
  String? title;
  int? titleId;
  String? field;
  String? value;
  String? name;
  String? createdAt;
  String? updatedAt;

  AppSettingsResponseModelData(
      {this.id,
      this.title,
      this.titleId,
      this.field,
      this.value,
      this.name,
      this.createdAt,
      this.updatedAt});

  AppSettingsResponseModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    titleId = json['titleId'];
    field = json['field'];
    value = json['value'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['titleId'] = titleId;
    data['field'] = field;
    data['value'] = value;
    data['name'] = name;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
