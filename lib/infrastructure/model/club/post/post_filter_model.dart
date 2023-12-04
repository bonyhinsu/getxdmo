class PostFilterModel {
  String? title;
  int? itemId;
  int? parentSportId;
  bool isSelected = false;
  bool enable = true;

  PostFilterModel({this.itemId=-1,this.parentSportId=-1,this.isSelected=false,required this.title, this.enable=true});
}
