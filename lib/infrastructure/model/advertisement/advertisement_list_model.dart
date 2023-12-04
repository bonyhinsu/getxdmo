class AdvertisementListModel {
  bool? status;
  int? code;
  List<AdvertisementListModelData>? data;
  String? message;

  AdvertisementListModel({this.status, this.code, this.data, this.message});

  AdvertisementListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    if (json['data'] != null) {
      data = <AdvertisementListModelData>[];
      json['data'].forEach((v) {
        data!.add(AdvertisementListModelData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class AdvertisementListModelData {
  int? id;
  String? title;
  String? description;
  String? image;
  String? croppedImage;
  String? link;
  String? status;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  AdvertisementListModelData(
      {this.id,
        this.title,
        this.description,
        this.image,
        this.croppedImage,
        this.link,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  AdvertisementListModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    croppedImage = json['croppedImage'];
    link = json['link'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['image'] = image;
    data['croppedImage'] = croppedImage;
    data['link'] = link;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deletedAt'] = deletedAt;
    return data;
  }
}