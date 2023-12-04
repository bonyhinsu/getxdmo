class BlockUserResponse {
  bool? status;
  int? code;
  BlockUserResponseData? data;
  String? message;

  BlockUserResponse({this.status, this.code, this.data, this.message});

  BlockUserResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    data = json['data'] != null ? BlockUserResponseData.fromJson(json['data']) : null;
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

class BlockUserResponseData {
  bool? isUserBlockMe;
  bool? isUserBlockByMe;

  BlockUserResponseData({this.isUserBlockMe, this.isUserBlockByMe});

  BlockUserResponseData.fromJson(Map<String, dynamic> json) {
    isUserBlockMe = json['isUserBlockMe'];
    isUserBlockByMe = json['isUserBlockByMe'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isUserBlockMe'] = isUserBlockMe;
    data['isUserBlockByMe'] = isUserBlockByMe;
    return data;
  }
}