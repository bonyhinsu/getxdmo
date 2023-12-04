class SubscriptionSportModel {
  int itemId =-1;
  int userSportDetailId =-1;
  String sportName = "";
  String logoImage = "";
  String amount = "";
  String nextRenewalDate = "";
  String subscriptionStartDate = "";
  String subscriptionType = "";
  bool isFreePlan = true;
  bool isYearly = false;
  bool isUpgradable = false;
  bool isPng = false;
  bool isCancelled = false;
  bool canRenew = false;
  bool subscribeToSports = false;
  List<SubscriptionHistory> subscriptionDates = [];

  SubscriptionSportModel({
    this.itemId = -1,
    this.userSportDetailId = -1,
    required this.sportName,
    required this.logoImage,
    required this.amount,
    this.isPng=false,
    required this.nextRenewalDate,
    required this.subscriptionStartDate,
    required this.subscriptionType,
    this.isFreePlan = true,
    this.isCancelled = true,
    this.canRenew = true,
    this.isYearly = false,
    this.isUpgradable = false,
    this.subscribeToSports = false,
  });

  SubscriptionSportModel.blank();
}
class SubscriptionHistory{
  String date = '';
  String amount = '';

  SubscriptionHistory(this.date, this.amount);
}