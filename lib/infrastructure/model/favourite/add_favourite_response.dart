class AddFavouriteResponse {
  bool? status;
  int? code;
  AddFavouriteResponseData? data;
  String? message;

  AddFavouriteResponse({this.status, this.code, this.data, this.message});

  AddFavouriteResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    data = json['data'] != null ? new AddFavouriteResponseData.fromJson(json['data']) : null;
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

class AddFavouriteResponseData {
  int? id;
  String? name;

  AddFavouriteResponseData({this.id, this.name});

  AddFavouriteResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}