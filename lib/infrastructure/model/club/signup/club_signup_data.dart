import 'package:game_on_flutter/infrastructure/model/club/signup/selection_model.dart';
import 'package:game_on_flutter/infrastructure/storage/preference_manager.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:get_it/get_it.dart';

class SignUpData {
  List<SelectionModel>? sportType;
  List<SelectionModel>? location;
  List<SelectionModel>? playerType;
  List<SelectionModel>? playerLevel;
  List<SelectionModel>? playerPosition;
  String? clubLogoURL;
  String clubName = "";
  String clubPhoneNumber = "";
  String clubAddress = "";
  String clubEmail = "";
  String? clubPassword = "";
  String? clubVideo;
  List<String>? clubImages;
  String? clubIntro;
  String? clubBio;
  String? clubOtherInformation;
  String playerName = "";
  String playerPhoneNumber = "";
  String playerAddress = "";
  String playerEmail = "";
  String? playerPassword = "";
  String? playerVideo;
  List<String>? playerImages;
  String? intro;
  String? bio;
  String? dob;
  String? height;
  String? weight;
  String? playerGender;
  String? reference;
  String? playerProfileURL;
  double? latitude;
  double? longitude;
  bool isDummyData = false;

  SignUpData();

  SignUpData.prepareDummyData() {
   /* sportType = [
      SelectionModel.withoutIcon(title: AppString.cricket),
    ];
    location = [
      SelectionModel.withoutIcon(title: AppString.tas),
    ];
    playerType = [
      SelectionModel.withoutIcon(title: AppString.womens),
      SelectionModel.withoutIcon(title: AppString.mens),
    ];
    playerLevel = [
      SelectionModel.withoutIcon(title: AppString.country),
      SelectionModel.withoutIcon(title: AppString.amateurs),
    ];
    clubLogoURL = GetIt.I<PreferenceManager>().userProfilePicture;
    clubName = GetIt.I<PreferenceManager>().userName;
    clubEmail = GetIt.I<PreferenceManager>().userEmail;
    clubPhoneNumber = "94432259";
    clubAddress = "Leederville Oval-246 Vincent Street LEEDERVILLE 6007";
    clubPassword = "User@123";
    clubVideo = "https://www.youtube.com/watch?v=ARbOByl-uFk";
    clubImages = [
      "https://www.swaraajsports.com/images/bg-video.jpg",
      "https://www.swaraajsports.com/images/bg-video.jpg",
      "https://www.swaraajsports.com/images/bg-video.jpg"
    ];
    clubIntro =
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut l";
    clubBio =
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut l";
    clubOtherInformation =
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut l";
    isDummyData = true;*/
  }

  SignUpData.prepareDummyDataForPlayer() {
    /*sportType = [
      SelectionModel.withoutIcon(title: AppString.cricket),
    ];
    location = [
      SelectionModel.withoutIcon(title: AppString.tas),
    ];
    playerType = [
      SelectionModel.withoutIcon(title: AppString.mens),
    ];
    playerLevel = [
      SelectionModel.withoutIcon(title: AppString.country),
      SelectionModel.withoutIcon(title: AppString.amateurs),
    ];
    playerProfileURL = GetIt.I<PreferenceManager>().userProfilePicture;
    playerName = GetIt.I<PreferenceManager>().userName;
    playerPhoneNumber = "94432259";
    playerAddress = "Leederville Oval-246 Vincent Street LEEDERVILLE 6007";
    playerEmail = GetIt.I<PreferenceManager>().userEmail;
    playerPassword = "User@123";
    dob = "05/06/1996";
    height = "5'3\"";
    weight = '373 lbh';
    playerVideo = "https://www.youtube.com/watch?v=ARbOByl-uFk";
    playerImages = [
      "https://www.swaraajsports.com/images/bg-video.jpg",
      "https://www.swaraajsports.com/images/bg-video.jpg",
      "https://www.swaraajsports.com/images/bg-video.jpg"
    ];
    intro =
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut l";
    bio =
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut l";
    reference =
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut l";
    isDummyData = true;*/
  }
}
/*

class PlayerSignUpData {
  List<SelectionModel>? sportType;
  List<SelectionModel>? location;
  List<SelectionModel>? playerType;
  List<SelectionModel>? playerLevel;
  String? playerProfileURL;
  String playerName="";
  String playerPhoneNumber="";
  String playerAddress="";
  String playerEmail="";
  String? playerPassword="";
  String? playerVideo;
  List<String>? playerImages;
  String? intro;
  String? bio;
  String? dob;
  String? height;
  String? weight;
  String? reference;
  bool isDummyData = false;

  PlayerSignUpData();

  PlayerSignUpData.prepareDummyData() {
    sportType = [
      SelectionModel.withoutIcon(title: AppString.cricket),
      SelectionModel.withoutIcon(title: AppString.soccer)
    ];
    location = [
      SelectionModel.withoutIcon(title: AppString.tas),
    ];
    playerType = [
      SelectionModel.withoutIcon(title: AppString.female),
      SelectionModel.withoutIcon(title: AppString.male),
    ];
    playerLevel = [
      SelectionModel.withoutIcon(title: AppString.country),
      SelectionModel.withoutIcon(title: AppString.amateurs),
    ];
    playerProfileURL =
    "https://media.istockphoto.com/id/1309328823/photo/headshot-portrait-of-smiling-male-employee-in-office.webp?b=1&s=170667a&w=0&k=20&c=MRMqc79PuLmQfxJ99fTfGqHL07EDHqHLWg0Tb4rPXQc=";
    playerName = "Marion Soccer";
    playerPhoneNumber = "94432259";
    playerAddress = "Leederville Oval-246 Vincent Street LEEDERVILLE 6007";
    playerEmail = "myemail@example.com";
    playerPassword = "User@123";
    dob = "05/06/2022";
    height = "5'6''";
    weight = "654";
    playerVideo = "https://www.youtube.com/watch?v=ARbOByl-uFk";
    playerImages = ["https://www.swaraajsports.com/images/bg-video.jpg","https://www.swaraajsports.com/images/bg-video.jpg","https://www.swaraajsports.com/images/bg-video.jpg"];
    intro =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut l";
    bio =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut l";
    reference =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut l";
    isDummyData = true;
  }
}
*/
