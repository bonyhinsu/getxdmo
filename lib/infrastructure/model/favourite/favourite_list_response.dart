class FavouriteListResponse {
  bool? status;
  int? code;
  List<FavouriteListResponseData>? data;
  String? message;

  FavouriteListResponse({this.status, this.code, this.data, this.message});

  FavouriteListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    if (json['data'] != null) {
      data = <FavouriteListResponseData>[];
      json['data'].forEach((v) {
        data!.add(FavouriteListResponseData.fromJson(v));
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

class FavouriteListResponseData {
  int? id;
  int? userId;
  String? name;
  int? favouriteListId;

  FavouriteListResponseData({this.id, this.userId, this.name,this.favouriteListId});

  FavouriteListResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    name = json['name'];
    favouriteListId = json['favouriteListId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['name'] = name;
    data['favouriteListId'] = favouriteListId;
    return data;
  }
}
