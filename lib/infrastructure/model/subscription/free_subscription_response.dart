class FreeSubscriptionResponse {
  bool? status;
  int? code;
  FreeSubscriptionResponseData? data;
  String? message;

  FreeSubscriptionResponse({this.status, this.code, this.data, this.message});

  FreeSubscriptionResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    data = json['data'] != null ? new FreeSubscriptionResponseData.fromJson(json['data']) : null;
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

class FreeSubscriptionResponseData {
  int? id;
  int? userSportDetailId;
  int? subscriptionId;
  String? activateDate;
  String? expiryDate;
  int? paidAmount;
  String? isCancel;
  String? isExpire;
  String? status;
  String? cancelledDate;
  String? isAllowChat;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  FreeSubscriptionResponseData(
      {this.id,
        this.userSportDetailId,
        this.subscriptionId,
        this.activateDate,
        this.expiryDate,
        this.paidAmount,
        this.isCancel,
        this.isExpire,
        this.status,
        this.cancelledDate,
        this.isAllowChat,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  FreeSubscriptionResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userSportDetailId = json['userSportDetailId'];
    subscriptionId = json['subscriptionId'];
    activateDate = json['activateDate'];
    expiryDate = json['expiryDate'];
    paidAmount = json['paidAmount'];
    isCancel = json['isCancel'];
    isExpire = json['isExpire'];
    status = json['status'];
    cancelledDate = json['cancelledDate'];
    isAllowChat = json['isAllowChat'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userSportDetailId'] = this.userSportDetailId;
    data['subscriptionId'] = this.subscriptionId;
    data['activateDate'] = this.activateDate;
    data['expiryDate'] = this.expiryDate;
    data['paidAmount'] = this.paidAmount;
    data['isCancel'] = this.isCancel;
    data['isExpire'] = this.isExpire;
    data['status'] = this.status;
    data['cancelledDate'] = this.cancelledDate;
    data['isAllowChat'] = this.isAllowChat;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    return data;
  }
}