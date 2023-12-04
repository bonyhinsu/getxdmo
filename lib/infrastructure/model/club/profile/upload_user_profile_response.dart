class UploadUserProfileResponse {
  bool? status;
  int? code;
  UploadUserProfileResponseData? data;
  String? message;

  UploadUserProfileResponse({this.status, this.code, this.data, this.message});

  UploadUserProfileResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    data = json['data'] != null ? UploadUserProfileResponseData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class UploadUserProfileResponseData {
  String? url;

  UploadUserProfileResponseData({this.url});

  UploadUserProfileResponseData.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    return data;
  }
}