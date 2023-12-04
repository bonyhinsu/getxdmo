class CoachingStaffResponseModel{
  bool? status;
  int? code;
  List<CoachingStaffResponseModelData>? data;
  String? message;

  CoachingStaffResponseModel({this.status, this.code, this.data, this.message});

  CoachingStaffResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    if (json['data'] != null) {
      data = <CoachingStaffResponseModelData>[];
      json['data'].forEach((v) {
        data!.add(CoachingStaffResponseModelData.fromJson(v));
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
class CoachingStaffResponseModelData{
  int? id;
  int? userId;
  String? name;
  String? email;
  String? contactNumber;
  String? dateOfBirth;
  String? gender;
  String? experience;
  String? speciality;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  CoachingStaffResponseModelData(
      {this.id,
        this.userId,
        this.name,
        this.email,
        this.contactNumber,
        this.dateOfBirth,
        this.gender,
        this.experience,
        this.speciality,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  CoachingStaffResponseModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    name = json['name'];
    email = json['email'];
    contactNumber = json['contactNumber'];
    dateOfBirth = json['dateOfBirth'];
    gender = json['gender'];
    experience = json['experience'];
    speciality = json['speciality'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['contactNumber'] = this.contactNumber;
    data['dateOfBirth'] = this.dateOfBirth;
    data['gender'] = this.gender;
    data['experience'] = this.experience;
    data['speciality'] = this.speciality;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    return data;
  }
}