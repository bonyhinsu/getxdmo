class SubscriptionPlanModel{
  String? planTitle;
  String? planAmount;
  String? planFeatures;

  SubscriptionPlanModel({this.planTitle, this.planAmount, this.planFeatures});
}
class SubscriptionPlanResponseModel {
  bool? status;
  int? code;
  List<SubscriptionPlanResponseData>? data;
  String? message;

  SubscriptionPlanResponseModel(
      {this.status, this.code, this.data, this.message});

  SubscriptionPlanResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    if (json['data'] != null) {
      data = <SubscriptionPlanResponseData>[];
      json['data'].forEach((v) {
        data!.add(new SubscriptionPlanResponseData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class SubscriptionPlanResponseData {
  int? id;
  String? subscriptionType;
  String? planType;
  String? description;
  num? amount;
  int? timeInMonth;
  String? createdAt;
  String? updatedAt;

  SubscriptionPlanResponseData(
      {this.id,
        this.subscriptionType,
        this.planType,
        this.description,
        this.amount,
        this.timeInMonth,
        this.createdAt,
        this.updatedAt});

  SubscriptionPlanResponseData.fromJson(Map<String, dynamic> json) {
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