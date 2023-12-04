import 'package:game_on_flutter/infrastructure/model/club/post/post_list_model.dart';

import '../../../../presentation/screens/player/player_home/controllers/player_home.controller.dart';

class PostModel {
  int? index;
  int? clubId;
  List<PostImages>? postImage = [];
  String? title;
  String? postDescription;
  String? eventImage;
  String? resultImage;
  String? clubName;
  String? clubLogo;
  String? adImage;
  String? time;
  String? eventDate;
  String? eventTime;
  String? location;
  String? leagueName;
  String? positionName;
  String? postDate;
  String age = "";
  String gender = "";
  String skill = "";
  String level = "";
  String references = "";
  String highlight = "";
  String otherDetails = "";
  String teamA = "";
  String teamB = "";
  String eventType = "";
  String score = "";
  PostViewType viewType;
  bool isAdvertisement = false;
  bool isLoading = false;

  // Only for Test data
  bool loadLiveImage = false;
  String? advertisementBanner;
  String? advertisementLink;

  PostModel({required this.index,
    required this.postDescription,
    this.postImage,
    required this.clubName,
    required this.clubLogo,
    required this.clubId,
    required this.time,
    required this.postDate,
    this.isAdvertisement = false,
    this.leagueName = "",
    this.loadLiveImage = false,
    this.viewType = PostViewType.post});

  PostModel.forAdvertisement({
  this.isAdvertisement = true, this.advertisementBanner , this.advertisementLink,
    this.viewType = PostViewType.adv
  });

  PostModel.forOpenPosition({required this.positionName,
    required this.age, required this.index,
    required this.gender,
    required this.location,
    required this.references,
    required this.skill,
    required this.level,
    required this.time,
    required this.postDate,
    required this.clubName,
    required this.clubLogo,
    required this.clubId,
    this.postDescription,
    this.viewType = PostViewType.openPosition});

  PostModel.forResult({
    required this.index,
    required this.title,
    required this.location,
    required this.leagueName,
    required this.time,
    required this.score,
    required this.eventDate,
    required this.clubName,
    required this.clubLogo,
    required this.clubId,
    required this.highlight,
    required this.postDate,
    required this.otherDetails,
    this.resultImage,
    required this.teamA,
    required this.teamB,
    this.postDescription,
    this.viewType = PostViewType.result});

  PostModel.forEvent({
    required this.index,
    required this.title,
    required this.location,
    required this.leagueName,
    required this.time,
    required this.eventTime,
    required this.clubName,
    required this.clubLogo,
    required this.clubId,
    required this.eventDate,
    required this.postDate,
    this.eventImage,
    required this.teamA,
    required this.teamB,
    required this.eventType,
    this.postDescription,
    this.viewType = PostViewType.event});

  PostModel.forShimmer(this.postDescription,
      {this.viewType = PostViewType.event});

  PostModel.forLoading({required this.isLoading,this.viewType = PostViewType.loading});
}
