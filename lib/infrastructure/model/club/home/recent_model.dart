import '../../player/favourite/favourite_type_model.dart';
import '../../user_info_model.dart';

class RecentModel {
  int? userId;
  String? playerImage;
  String? playerDescription;
  String? playerName;
  String? playerAge;
  String? playerPosition;
  String? playerDistance;
  String? playerBio;
  String? playerPhoneNumber;
  String? playerEmail;
  String? playerHeight;
  String? playerWeight;
  String? totalFollowers;
  String? uuid;
  String? date;
  List<UserPhotos>? clubPictures;
  String? videos;
  String? advertisementBanner;
  String? advertisementLink;
  String? gender;
  bool isMale = true;
  bool isFromAsset = true;
  bool isAdvertisement = false;
  bool isLiked = false;
  bool followUser = false;

  RecentModel(
      {required this.playerName,
      required this.playerImage,
      required this.userId,
      required this.playerPosition,
      required this.playerAge,
      required this.playerDistance,
      required this.playerDescription,
      required this.date,
      required this.playerEmail,
      required this.playerPhoneNumber,
      required this.playerBio,
      required this.totalFollowers,
      required this.playerWeight,
      required this.playerHeight,
      this.uuid,
      this.gender,
      this.isFromAsset = true,
      this.isLiked = false,
      this.clubPictures,
      this.videos,
      this.isAdvertisement = false,
      this.isMale = true});

  RecentModel.advertisement({this.isAdvertisement = true, this.advertisementBanner , this.advertisementLink});

  RecentModel.forDummyPost(
      {this.playerName = "James Smith",
      this.playerImage =
          "https://iaa.edu.in/public/uploads/admin/faculty/unr_test_161024_0535_9lih90[1]1564210749.png",
      this.playerPosition = "Tall FWD",
      this.playerAge = "35 years",
      this.playerDistance = "488 km",
      this.playerEmail = "testau@gmail.com",
      this.playerPhoneNumber = "987654312",
      this.playerBio =
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
      this.totalFollowers = "181485",
      required this.playerDescription,
      required this.date});
}
