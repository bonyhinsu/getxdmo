class SelectedClubModel {
  bool? status;
  int? code;
  List<SelectedClubList>? data;
  String? message;

  SelectedClubModel({this.status, this.code, this.data, this.message});

  SelectedClubModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    if (json['data'] != null) {
      data = <SelectedClubList>[];
      json['data'].forEach((v) {
        data!.add(new SelectedClubList.fromJson(v));
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

class SelectedClubList {
  int? id;
  int? userId;
  int? clubId;
  String? type;
  String? createdAt;
  String? updatedAt;
  String? name;
  String? profileImage;
  ClubDetails? clubDetails;

  SelectedClubList(
      {this.id,
        this.userId,
        this.clubId,
        this.type,
        this.name,
        this.profileImage,
        this.createdAt,
        this.updatedAt,
        this.clubDetails});

  SelectedClubList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    clubId = json['clubId'];
    type = json['type'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    clubDetails = json['clubDetails'] != null
        ? new ClubDetails.fromJson(json['clubDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['clubId'] = this.clubId;
    data['type'] = this.type;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.clubDetails != null) {
      data['clubDetails'] = this.clubDetails!.toJson();
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
