import '../club_member_response_model.dart';

class AddMemberResponse {
  bool? status;
  int? code;
  President? data;
  String? message;

  AddMemberResponse({this.status, this.code, this.data, this.message});

  AddMemberResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    data = json['data'] != null ? President.fromJson(json['data']) : null;
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
