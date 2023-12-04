class SubscriptionListModel {
  bool? status;
  int? code;
  List<SubscriptionListData>? data;
  String? message;

  SubscriptionListModel({this.status, this.code, this.data, this.message});

  SubscriptionListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    if (json['data'] != null) {
      data = <SubscriptionListData>[];
      json['data'].forEach((v) {
        data!.add(SubscriptionListData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['code'] = code;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class SubscriptionListData {
  int? id;
  int? userId;
  int? sportTypeId;
  String? createdAt;
  String? updatedAt;
  SportTypeDetails? sportTypeDetails;
  SubscriptionData? subscriptionData;

  SubscriptionListData(
      {this.id,
        this.userId,
        this.sportTypeId,
        this.createdAt,
        this.updatedAt,
        this.sportTypeDetails,
        this.subscriptionData,});

  SubscriptionListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    sportTypeId = json['sportTypeId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    sportTypeDetails = json['sportTypeDetails'] != null
        ? new SportTypeDetails.fromJson(json['sportTypeDetails'])
        : null;
    subscriptionData = json['subscriptionData'] != null
        ? new SubscriptionData.fromJson(json['subscriptionData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['sportTypeId'] = this.sportTypeId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.sportTypeDetails != null) {
      data['sportTypeDetails'] = this.sportTypeDetails!.toJson();
    }
    if (this.subscriptionData != null) {
      data['subscriptionData'] = this.subscriptionData!.toJson();
    }
    return data;
  }
}

class SportTypeDetails {
  int? id;
  String? name;
  String? slug;
  String? logo;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  SportTypeDetails(
      {this.id,
        this.name,
        this.slug,
        this.logo,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  SportTypeDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    logo = json['logo'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['logo'] = this.logo;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    return data;
  }
}

class SubscriptionData {
  int? id;
  int? userSportDetailId;
  int? subscriptionId;
  String? activateDate;
  String? expiryDate;
  num? paidAmount;
  String? isCancel;
  String? isExpire;
  String? status;
  String? cancelledDate;
  String? createdAt;
  String? updatedAt;
  SubscriptionDetails? subscriptionDetails;

  SubscriptionData(
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
        this.createdAt,
        this.updatedAt,
        this.subscriptionDetails});

  SubscriptionData.fromJson(Map<String, dynamic> json) {
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
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    subscriptionDetails = json['subscriptionDetails'] != null
        ? new SubscriptionDetails.fromJson(json['subscriptionDetails'])
        : null;
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
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (subscriptionDetails != null) {
      data['subscriptionDetails'] = subscriptionDetails!.toJson();
    }
    return data;
  }
}

class SubscriptionDetails {
  int? id;
  String? subscriptionType;
  String? planType;
  String? description;
  num? amount;
  int? timeInMonth;
  String? createdAt;
  String? updatedAt;

  SubscriptionDetails(
      {this.id,
        this.subscriptionType,
        this.planType,
        this.description,
        this.amount,
        this.timeInMonth,
        this.createdAt,
        this.updatedAt});

  SubscriptionDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subscriptionType = json['subscriptionType'];
    planType = json['planType'];
    description = json['description'];
    amount = json['Amount'];
    timeInMonth = json['timeInMonth'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subscriptionType'] = this.subscriptionType;
    data['planType'] = this.planType;
    data['description'] = this.description;
    data['Amount'] = this.amount;
    data['timeInMonth'] = this.timeInMonth;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}