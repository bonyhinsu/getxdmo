import 'base_response_model.dart';

class ListBaseModel<T extends Serializable> {
  bool? status;
  String? message;
  List<T>? data;

  ListBaseModel({this.status, this.message, this.data});

  factory ListBaseModel.fromJson(
      Map<String, dynamic> json, Function(Map<String, dynamic>) create) {
    List<T>? data = <T>[];
    json['data'].forEach((v) {
      data.add(create(v));
    });
    return ListBaseModel<T>(
      status: json["status"],
      message: json["message"],
      data: data,
    );
  }

  Map<String, dynamic> toJson() => {
        "status": this.status,
        "message": this.message,
        "data": {},
      };
}
