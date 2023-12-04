class ClubMemberResponseModel {
  bool? status;
  int? code;
  ClubMemberResponseModelData? data;
  String? message;

  ClubMemberResponseModel({this.status, this.code, this.data, this.message});

  ClubMemberResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    data = json['data'] != null
        ? ClubMemberResponseModelData.fromJson(json['data'])
        : null;
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

class ClubMemberResponseModelData {
  List<President>? president;
  List<President>? director;
  List<President>? otherInfo;

  ClubMemberResponseModelData({this.president, this.director, this.otherInfo,});

  ClubMemberResponseModelData.fromJson(Map<String, dynamic> json) {
    if (json['President'] != null) {
      president = <President>[];
      json['President'].forEach((v) {
        president!.add(President.fromJson(v));
      });
    }
    if (json['Director'] != null) {
      director = <President>[];
      json['Director'].forEach((v) {
        director!.add(President.fromJson(v));
      });
    }if (json['OtherInfo'] != null) {
      otherInfo = <President>[];
      json['OtherInfo'].forEach((v) {
        otherInfo!.add(President.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (president != null) {
      data['President'] = president!.map((v) => v.toJson()).toList();
    }
    if (otherInfo != null) {
      data['Director'] = otherInfo!.map((v) => v.toJson()).toList();
    }if (otherInfo != null) {
      data['OtherInfo'] = otherInfo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class President {
  int? id;
  int? userId;
  String? name;
  String? email;
  String? contactNumber;
  String? type;
  bool? isOtherContactInfo;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  President(
      {this.id,
      this.userId,
      this.name,
      this.email,
      this.contactNumber,
      this.type,
      this.isOtherContactInfo,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  President.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId =
        json['userId'] is String ? int.parse(json['userId']) : json['userId'];
    name = json['name'];
    email = json['email'];
    contactNumber = json['contactNumber'];
    type = json['type'];
    isOtherContactInfo = json['isOtherContactInfo'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['userId'] = userId;
    data['name'] = name;
    data['email'] = email;
    data['contactNumber'] = contactNumber;
    data['type'] = type;
    data['isOtherContactInfo'] = isOtherContactInfo;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deletedAt'] = deletedAt;
    return data;
  }
}
