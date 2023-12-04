class ReportUserListResponse {
  bool? status;
  int? code;
  List<ReportUserListResponseData>? data;
  String? message;

  ReportUserListResponse({this.status, this.code, this.data, this.message});

  ReportUserListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    if (json['data'] != null) {
      data = <ReportUserListResponseData>[];
      json['data'].forEach((v) {
        data!.add(new ReportUserListResponseData.fromJson(v));
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

class ReportUserListResponseData {
  int? id;
  String? name;
  bool isChecked=false;

  ReportUserListResponseData({this.id, this.name});

  ReportUserListResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}