class SubscriptionDetailModel {
  bool? status;
  int? code;
  SubscriptionDetailModelData? data;
  String? message;

  SubscriptionDetailModel({this.status, this.code, this.data, this.message});

  SubscriptionDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    data = json['data'] != null ? SubscriptionDetailModelData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    data['code'] = code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class SubscriptionDetailModelData {
  UserSportDetail? userSportDetail;
  List<GetSubscriptionHistory>? getSubscriptionHistory;
  String? nextPaymentDate;
  String? firstPaymentDate;
  num? subscriptionPlanAmount;
  String? subscriptionPlanDuration;
  num? avgMonthly;

  SubscriptionDetailModelData(
      {this.userSportDetail,
        this.getSubscriptionHistory,
        this.nextPaymentDate,
        this.firstPaymentDate,
        this.subscriptionPlanAmount,
        this.subscriptionPlanDuration,
        this.avgMonthly});

  SubscriptionDetailModelData.fromJson(Map<String, dynamic> json) {
    userSportDetail = json['userSportDetail'] != null
        ? UserSportDetail.fromJson(json['userSportDetail'])
        : null;
    if (json['getSubscriptionHistory'] != null) {
      getSubscriptionHistory = <GetSubscriptionHistory>[];
      json['getSubscriptionHistory'].forEach((v) {
        getSubscriptionHistory!.add(GetSubscriptionHistory.fromJson(v));
      });
    }
    nextPaymentDate = json['nextPaymentDate'];
    firstPaymentDate = json['firstPaymentDate'];
    subscriptionPlanAmount = json['subscriptionPlanAmount'];
    subscriptionPlanDuration = json['subscriptionPlanDuration'];
    avgMonthly = json['avgMonthly'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (userSportDetail != null) {
      data['userSportDetail'] = userSportDetail!.toJson();
    }
    if (getSubscriptionHistory != null) {
      data['getSubscriptionHistory'] =
          getSubscriptionHistory!.map((v) => v.toJson()).toList();
    }
    data['nextPaymentDate'] = nextPaymentDate;
    data['firstPaymentDate'] = firstPaymentDate;
    data['subscriptionPlanAmount'] = subscriptionPlanAmount;
    data['subscriptionPlanDuration'] = subscriptionPlanDuration;
    data['avgMonthly'] = avgMonthly;
    return data;
  }
}

class UserSportDetail {
  int? id;
  int? userId;
  int? sportTypeId;
  String? createdAt;
  String? updatedAt;
  SportTypeDetails? sportTypeDetails;

  UserSportDetail(
      {this.id,
        this.userId,
        this.sportTypeId,
        this.createdAt,
        this.updatedAt,
        this.sportTypeDetails});

  UserSportDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    sportTypeId = json['sportTypeId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    sportTypeDetails = json['sportTypeDetails'] != null
        ? SportTypeDetails.fromJson(json['sportTypeDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['sportTypeId'] = sportTypeId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (sportTypeDetails != null) {
      data['sportTypeDetails'] = sportTypeDetails!.toJson();
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

  SportTypeDetails(
      {this.id,
        this.name,
        this.slug,
        this.logo,
        this.status,
        this.createdAt,
        this.updatedAt,
      });

  SportTypeDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    logo = json['logo'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['logo'] = logo;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class GetSubscriptionHistory {
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
  GetSubscriptionHistory(
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
        this.updatedAt,});

  GetSubscriptionHistory.fromJson(Map<String, dynamic> json) {
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['userSportDetailId'] = userSportDetailId;
    data['subscriptionId'] = subscriptionId;
    data['activateDate'] = activateDate;
    data['expiryDate'] = expiryDate;
    data['paidAmount'] = paidAmount;
    data['isCancel'] = isCancel;
    data['isExpire'] = isExpire;
    data['status'] = status;
    data['cancelledDate'] = cancelledDate;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}