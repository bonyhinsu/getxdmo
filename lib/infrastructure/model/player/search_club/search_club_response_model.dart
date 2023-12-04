class SearchClubResponseModel {
  bool? status;
  int? code;
  List<SearchClubResponseModelData>? data;
  String? message;

  SearchClubResponseModel({this.status, this.code, this.data, this.message});

  SearchClubResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    if (json['data'] != null) {
      data = <SearchClubResponseModelData>[];
      json['data'].forEach((v) {
        data!.add(SearchClubResponseModelData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class SearchClubResponseModelData {
  int? id;
  String? name;
  String? profileImage;
  String? type;
  String? advertisementLink;
  String? advertisementBanner;
  bool isAdvertisement=false;

  SearchClubResponseModelData({this.id, this.name, this.profileImage, this.type});

  SearchClubResponseModelData.advertisement({this.isAdvertisement = true, this.advertisementBanner , this.advertisementLink});

  SearchClubResponseModelData.fromJson(Map<String, dynamic> json) {
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