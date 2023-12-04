class ApiResponse<T extends Serializable> {
  bool? status;
  String? message;
  T? data;

  ApiResponse({this.status, this.message, this.data});

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, Function(Map<String, dynamic>) create) {

    return ApiResponse<T>(
      status: json["status"],
      message: json["message"],
      data: create(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "status": this.status,
        "message": this.message,
        "data": this.data?.toJson(),
      };
}

abstract class Serializable {
  Map<String, dynamic> toJson();
}
