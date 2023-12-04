import 'package:game_on_flutter/values/app_icons.dart';
import 'package:game_on_flutter/values/app_string.dart';

import '../../../../presentation/screens/club/signup/club_board_members/model/club_member_model.dart';
import '../../../../values/app_images.dart';
import '../../subscription/subscription_sport_model.dart';
import '../home/club_list_model.dart';
import '../home/recent_model.dart';

class SelectionModel {
  String? title;
  String? icon;
  String? description;
  bool isPng = false;
  int itemIndex = -1;
  int itemId = -1;
  int parentSportId = -1;
  bool isSelected = false;
  bool isEnabled = true;

  SelectionModel();

  SelectionModel.withIcon(
      {required this.title,
      required this.icon,
      this.itemId = -1,
      this.isEnabled = true,
      this.isSelected = false,
      this.isPng = false});

  SelectionModel.withoutIcon({
    required this.title,
    this.isSelected = false,
    this.itemId = -1,
  });

  SelectionModel.withDescription({
    required this.title,
    this.isSelected = false,
    this.description,
    this.itemId = -1,
    this.parentSportId = -1,
  });
}

class DataProvider {
  /// Return list of sports.
  List<SubscriptionSportModel> getSportList() {
    return [
      SubscriptionSportModel(
        sportName: AppString.strAFL,
        logoImage: AppIcons.iconAFL,
        subscriptionType: '',
        amount: '\$9.95',
        isFreePlan: true,
        isPng: true,
        isUpgradable: true,
        subscribeToSports: true,
        nextRenewalDate: '2023-08-15 00:00:00',
        subscriptionStartDate: '2023-08-15 00:00:00',
      ),
      SubscriptionSportModel(
        sportName: AppString.soccer,
        logoImage: AppIcons.iconSoccer,
        subscriptionType: '',
        amount: '\$100',
        isFreePlan: false,
        isYearly: true,
        subscribeToSports: true,
        subscriptionStartDate: '2023-01-05 00:00:00',
        nextRenewalDate: '2025-01-05 00:00:00',
      ),
      SubscriptionSportModel(
        sportName: AppString.basketball,
        logoImage: AppIcons.iconBasketBall,
        subscriptionType: '',
        amount: '0',
        subscriptionStartDate: '',
        nextRenewalDate: '',
      ),
      SubscriptionSportModel(
        sportName: AppString.netball,
        logoImage: AppIcons.iconNetBall,
        subscriptionType: '',
        amount: '0',
        subscriptionStartDate: '',
        isPng: true,
        nextRenewalDate: '',
      ),
      SubscriptionSportModel(
        sportName: AppString.cricket,
        logoImage: AppIcons.iconCricket,
        subscriptionType: '',
        amount: '\$9.95',
        isFreePlan: false,
        isYearly: false,
        subscribeToSports: true,
        subscriptionStartDate: '2023-06-30 00:00:00',
        nextRenewalDate: '2023-07-30 00:00:00',
      ),
    ];
  }

  // /// Return Notification List
  // List<NotificationModelList> getNotification() {
  //   return [
  //     NotificationModelList(
  //         message: "Welcome to our club, Wilson Anderson!",
  //         time: "2 min ago",
  //         name: "Wilson Anderson",
  //         logo: AppImages.playerOne),
  //     NotificationModelList(
  //         message: "Welcome to our club, Amelia Margret!",
  //         time: "2 min ago",
  //         name: "Amelia Margret",
  //         logo: AppImages.playerTwo),
  //     NotificationModelList(
  //         message: "Welcome to our club, Hughes Jackson!",
  //         time: "2 min ago",
  //         name: "Hughes Jackson",
  //         logo: AppImages.playerThree),
  //     NotificationModelList(
  //         message: "Welcome to our club, Lawren Celewis!",
  //         time: "2 min ago",
  //         name: "Lawren Celewis",
  //         logo: AppImages.playerOne),
  //     NotificationModelList(
  //         message: "Welcome to our club, Wilson Anderson!",
  //         time: "2 min ago",
  //         name: "Wilson Anderson",
  //         logo: AppImages.playerTwo),
  //     NotificationModelList(
  //         message: "Welcome to our club, Amelia Margret!",
  //         time: "2 min ago",
  //         name: "Amelia Margret",
  //         logo: AppImages.playerThree),
  //     NotificationModelList(
  //         message: "Welcome to our club, Hughes Jackson!",
  //         time: "2 min ago",
  //         name: "Hughes Jackson",
  //         logo: AppImages.playerOne),
  //     NotificationModelList(
  //         message: "Welcome to our club, Lawren Celewis!",
  //         time: "2 min ago",
  //         name: "Lawren Celewis",
  //         logo: AppImages.playerTwo),
  //   ];
  // }
  //
  // /// Return Notification List
  // List<NotificationModelList> getPlayerNotification() {
  //   return [
  //     NotificationModelList(
  //         message: "Welcome to our club, Wilson Anderson!",
  //         time: "2 min ago",
  //         logo: AppImages.clubOne,
  //         name: "Brisbane Lions"),
  //     NotificationModelList(
  //         message: "Welcome to our club, Amelia Margret!",
  //         time: "2 min ago",
  //         logo: AppImages.clubTwo,
  //         name: "Adelaide"),
  //     NotificationModelList(
  //         message: "Welcome to our club, Hughes Jackson!",
  //         time: "2 min ago",
  //         logo: AppImages.clubThree,
  //         name: "Carlton"),
  //     NotificationModelList(
  //         message: "Welcome to our club, Wilson Anderson!",
  //         time: "2 min ago",
  //         logo: AppImages.clubOne,
  //         name: "Brisbane Lions"),
  //     NotificationModelList(
  //         message: "Welcome to our club, Amelia Margret!",
  //         time: "2 min ago",
  //         logo: AppImages.clubTwo,
  //         name: "Adelaide"),
  //     NotificationModelList(
  //         message: "Welcome to our club, Hughes Jackson!",
  //         time: "2 min ago",
  //         logo: AppImages.clubThree,
  //         name: "Carlton"),
  //     NotificationModelList(
  //         message: "Welcome to our club, Wilson Anderson!",
  //         time: "2 min ago",
  //         logo: AppImages.clubOne,
  //         name: "Brisbane Lions"),
  //     NotificationModelList(
  //         message: "Welcome to our club, Amelia Margret!",
  //         time: "2 min ago",
  //         logo: AppImages.clubTwo,
  //         name: "Adelaide"),
  //     NotificationModelList(
  //         message: "Welcome to our club, Hughes Jackson!",
  //         time: "2 min ago",
  //         logo: AppImages.clubThree,
  //         name: "Carlton"),
  //   ];
  // }

  /// Return list of sports.
  List<SelectionModel> getLocation() {
    return [
      SelectionModel.withoutIcon(title: AppString.act),
      SelectionModel.withoutIcon(title: AppString.nsw),
      SelectionModel.withoutIcon(title: AppString.nt),
      SelectionModel.withoutIcon(title: AppString.qld),
      SelectionModel.withoutIcon(title: AppString.tas),
      SelectionModel.withoutIcon(title: AppString.vic),
      SelectionModel.withoutIcon(title: AppString.wa),
    ];
  }

  /// Return list of favorite filter.
  List<SelectionModel> getFavoriteFilterList() {
    return [
      SelectionModel.withoutIcon(title: AppString.myFavoritePlayers),
      SelectionModel.withoutIcon(title: AppString.highPriorityPlayers),
      SelectionModel.withoutIcon(title: AppString.bestPlayers),
      SelectionModel.withoutIcon(title: AppString.soccer),
      SelectionModel.withoutIcon(title: AppString.famous),
      SelectionModel.withoutIcon(title: AppString.bestSkills),
    ];
  }

  /// Return list of player type.
  List<SelectionModel> getPlayerType() {
    return [
      SelectionModel.withoutIcon(title: AppString.mens),
      SelectionModel.withoutIcon(title: AppString.womens),
      SelectionModel.withoutIcon(title: AppString.jnrBoys),
      SelectionModel.withoutIcon(title: AppString.jnrGirls),
    ];
  }

  /// Return list of player position.
  List<SelectionModel> getPlayerLevel() {
    return [
      SelectionModel.withoutIcon(title: AppString.stateLeague),
      SelectionModel.withoutIcon(title: AppString.amateurs),
      SelectionModel.withoutIcon(title: AppString.country),
      SelectionModel.withoutIcon(title: AppString.masters),
      SelectionModel.withoutIcon(title: AppString.juniors),
    ];
  }

  /// Return list of player position.
  List<SelectionModel> getPlayerLevelNew() {
    return [
      SelectionModel.withoutIcon(title: AppString.stateLeague),
      SelectionModel.withoutIcon(title: AppString.amateurs),
      SelectionModel.withoutIcon(title: AppString.country),
      SelectionModel.withoutIcon(title: AppString.masters),
    ];
  }

  /// Return list of player position.
  List<SelectionModel> getPlayerPosition() {
    return [
      SelectionModel.withoutIcon(title: AppString.ruckMan),
      SelectionModel.withoutIcon(title: AppString.smallPressureFWD),
      SelectionModel.withoutIcon(title: AppString.tallFwd),
      SelectionModel.withoutIcon(title: AppString.hybridFWD),
      SelectionModel.withoutIcon(title: AppString.insideMid),
      SelectionModel.withoutIcon(title: AppString.outsideMid),
      SelectionModel.withoutIcon(title: AppString.hybridMid),
    ];
  }

  List<ClubListModel> getClubListForSearch() {
    return [
      ClubListModel(
          clubBio:
              'The club\'s athletes have consistently broken records and achieved remarkable individual accomplishments, including representing their country and earning scholarships for their outstanding performances.',
          clubNumber: '987456321',
          email: 'Brisbane@gmail.com',
          address: 'Brisbane',
          totalFollowers: '0',
          presidentList: presidentData,
          boardMembers: directors,
          otherContactMembers: otherContactDetail,
          coachingStaffs: buildCoachList,
          clubLogo: AppImages.clubOne,
          clubName: 'Brisbane Lions',
          clubPictures: clubImages,
          position: 'Small FWD',
          intro:
              'Club is a premier sports club dedicated to fostering athletic excellence, teamwork, and personal growth. With a focus on sports, we provide a dynamic and inclusive environment for athletes of all skill levels to thrive and achieve their goals.',
          level: 'State League',
          location: 'WA',
          locationCoordinates: '',
          otherInformation:
              'Over the years, many athletes who have trained with Club have gone on to achieve remarkable success. Several have represented their country at international competitions, earned college scholarships, or pursued professional careers in the sport. These success stories are a testament to the quality of our training programs and the dedication of our athletes.',
          sports: 'AFL',
          clubUUID: 'pUf1X7sQP4hcoiH8Qk64aP4aBDu2',
          mapImage:
              'https://k8q3f6p8.rocketcdn.me/wp-content/uploads/2019/05/Google-Maps-Tips.png',
          videos: clubVideo),
      ClubListModel(
          clubNumber: '4523687898',
          email: 'Adelaide@gmail.com',
          address: 'Adelaide',
          totalFollowers: '45',
          clubBio:
              'The club\'s athletes have consistently broken records and achieved remarkable individual accomplishments, including representing their country and earning scholarships for their outstanding performances.',
          clubLogo: AppImages.clubTwo,
          clubName: 'Adelaide',
          clubPictures: clubImages,
          presidentList: presidentData,
          boardMembers: directors,
          otherContactMembers: otherContactDetail,
          coachingStaffs: buildCoachList,
          clubUUID: 'wiVXysL5wPYhX6b7JKYcuPA9ksY2',
          position: 'Small FWD',
          mapImage:
              'https://k8q3f6p8.rocketcdn.me/wp-content/uploads/2019/05/Google-Maps-Tips.png',
          intro:
              'Club is a premier sports club dedicated to fostering athletic excellence, teamwork, and personal growth. With a focus on sports, we provide a dynamic and inclusive environment for athletes of all skill levels to thrive and achieve their goals.',
          level: 'State League',
          location: 'WA',
          locationCoordinates: '',
          otherInformation:
              'Over the years, many athletes who have trained with Club have gone on to achieve remarkable success. Several have represented their country at international competitions, earned college scholarships, or pursued professional careers in the sport. These success stories are a testament to the quality of our training programs and the dedication of our athletes.',
          sports: 'AFL',
          videos: clubVideo),
      ClubListModel(
          clubLogo: AppImages.clubThree,
          clubName: 'Carlton',
          clubNumber: '44567891235',
          email: 'Carlton@gmail.com',
          address: 'Carlton',
          totalFollowers: '2625',
          position: 'Small FWD',
          mapImage:
              'https://k8q3f6p8.rocketcdn.me/wp-content/uploads/2019/05/Google-Maps-Tips.png',
          clubBio:
              'The club\'s athletes have consistently broken records and achieved remarkable individual accomplishments, including representing their country and earning scholarships for their outstanding performances.',
          clubPictures: clubImages,
          presidentList: presidentData,
          boardMembers: directors,
          otherContactMembers: otherContactDetail,
          coachingStaffs: buildCoachList,
          intro:
              'Club is a premier sports club dedicated to fostering athletic excellence, teamwork, and personal growth. With a focus on sports, we provide a dynamic and inclusive environment for athletes of all skill levels to thrive and achieve their goals.',
          level: 'State League',
          location: 'WA',
          clubUUID: 'u4CTcSpOoeTvugYRwtChrFOKgQu1',
          locationCoordinates: '',
          otherInformation:
              'Over the years, many athletes who have trained with Club have gone on to achieve remarkable success. Several have represented their country at international competitions, earned college scholarships, or pursued professional careers in the sport. These success stories are a testament to the quality of our training programs and the dedication of our athletes.',
          sports: 'AFL',
          videos: clubVideo),
    ];
  }

  List<RecentModel> getUserListForSearch() {
    return [
      // RecentModel(
      //     playerName: "Jacob Msando",
      //     playerImage: AppImages.playerOne,
      //     userId: 1,
      //     playerPosition: "Tall FWD",
      //     playerAge: "28 year",
      //     playerDistance: "10 Km",
      //     playerDescription:
      //         "Welcome to Jacob Msando, who has just joined our EPFC club as a Tall FWD, traveling all the way from NSW. We wish Jacob Msando all the best for the upcoming AFL season!",
      //     date: '2023-06-17 00:00:00',
      //     playerEmail: 'jacob@gmail.com',
      //     playerPhoneNumber: '1234126975',
      //     playerBio: AppString.loremIpsum,
      //     totalFollowers: '65',
      //     uuid: 'sl4SgBSXNwT4AbRHdqC2MIoJxG42',
      //     clubPictures: clubImages,
      //     videos: clubVideo,
      //     playerWeight: '78 kg',
      //     playerHeight: '158 cm'),
      // RecentModel(
      //     userId: 2,
      //     playerName: "Sam Van Diemen",
      //     playerImage: AppImages.playerTwo,
      //     playerPosition: "Tall FWD",
      //     playerAge: "32 year",
      //     playerDistance: "12 Km",
      //     playerDescription:
      //         "Welcome to Sam Van Diemen, who has just joined our EPFC club as a Hybrid FWD, traveling all the way from NSW. We wish Sam Van Diemen all the best for the upcoming AFL season!",
      //     date: '2023-06-20 00:00:00',
      //     playerEmail: 'sam@gmail.com',
      //     playerPhoneNumber: '1234456975',
      //     playerBio: AppString.loremIpsum,
      //     totalFollowers: '78',
      //     playerHeight: '164 cm',
      //     clubPictures: clubImages,
      //     videos: clubVideo,
      //     uuid: 'zsYhh0ECeOaISmjT9ViQSDbXTwF3',
      //     playerWeight: '69 kg'),
      // RecentModel(
      //     userId: 3,
      //     playerName: "Harrison Macreadie",
      //     playerImage: AppImages.playerThree,
      //     playerPosition: "Tall FWD",
      //     playerAge: "20 year",
      //     playerDistance: "0.6 Km",
      //     playerDescription:
      //         "Welcome to Harrison Macreadie, who has just joined our EPFC club as a Inside Mid, traveling all the way from NSW. We wish Harrison Macreadie all the best for the upcoming AFL season!",
      //     date: '2023-06-07 00:00:00',
      //     playerEmail: 'harrison@gmail.com',
      //     playerPhoneNumber: '1237746975',
      //     playerBio: AppString.loremIpsum,
      //     totalFollowers: '69',
      //     playerHeight: '170 cm',
      //     clubPictures: clubImages,
      //     videos: clubVideo,
      //     uuid: 'LhLiz41QLwaiHowjsZbTstzx82g1',
      //     playerWeight: '82 kg'),
      // RecentModel(
      //     userId: 4,
      //     playerName: "Bradley Fullgrabe",
      //     playerImage: AppImages.playerOne,
      //     playerPosition: "Tall FWD",
      //     playerAge: "25 year",
      //     playerDistance: "8 Km",
      //     playerDescription:
      //         "Welcome to Bradley Fullgrabe, who has just joined our EPFC club as a Tall FWD, traveling all the way from NSW. We wish Bradley Fullgrabe all the best for the upcoming AFL season!",
      //     date: '2023-05-17 00:00:00',
      //     playerEmail: 'bradley@gmail.com',
      //     playerPhoneNumber: '1277346975',
      //     playerBio: AppString.loremIpsum,
      //     totalFollowers: '675',
      //     playerHeight: '168 cm',
      //     clubPictures: clubImages,
      //     videos: clubVideo,
      //     uuid: 'rScFovSB0XctKtxMJDSK48YkKF52',
      //     playerWeight: '65 kg'),
    ];
  }

  List<String> clubImages = [
    'https://www.shutterstock.com/image-photo/interior-modern-tennis-european-sport-260nw-205695373.jpg',
    'https://www.shutterstock.com/image-photo/interior-modern-tennis-european-sport-260nw-205695373.jpg',
    'https://www.getactivesports.com/wp-content/uploads/2017/11/1.jpg',
    'https://www.shutterstock.com/image-photo/interior-modern-tennis-european-sport-260nw-205695373.jpg',
    'https://www.shutterstock.com/image-photo/interior-modern-tennis-european-sport-260nw-205695373.jpg',
    'https://content.jdmagicbox.com/comp/ernakulam/x9/0484px484.x484.180602142234.p5x9/catalogue/nedumbassery-arts-and-sports-club-mekkad-ernakulam-sports-clubs-t33o43kbtc.jpg',
    'https://www.getactivesports.com/wp-content/uploads/2017/11/1.jpg',
    'https://www.shutterstock.com/image-photo/interior-modern-tennis-european-sport-260nw-205695373.jpg',
    'https://www.shutterstock.com/image-photo/interior-modern-tennis-european-sport-260nw-205695373.jpg',
    'https://content.jdmagicbox.com/comp/ernakulam/x9/0484px484.x484.180602142234.p5x9/catalogue/nedumbassery-arts-and-sports-club-mekkad-ernakulam-sports-clubs-t33o43kbtc.jpg',
    'https://www.getactivesports.com/wp-content/uploads/2017/11/1.jpg',
    'https://www.shutterstock.com/image-photo/interior-modern-tennis-european-sport-260nw-205695373.jpg',
    'https://www.shutterstock.com/image-photo/interior-modern-tennis-european-sport-260nw-205695373.jpg',
    'https://content.jdmagicbox.com/comp/ernakulam/x9/0484px484.x484.180602142234.p5x9/catalogue/nedumbassery-arts-and-sports-club-mekkad-ernakulam-sports-clubs-t33o43kbtc.jpg',
    'https://www.getactivesports.com/wp-content/uploads/2017/11/1.jpg',
    'https://www.shutterstock.com/image-photo/interior-modern-tennis-european-sport-260nw-205695373.jpg',
    'https://www.shutterstock.com/image-photo/interior-modern-tennis-european-sport-260nw-205695373.jpg',
    'https://content.jdmagicbox.com/comp/ernakulam/x9/0484px484.x484.180602142234.p5x9/catalogue/nedumbassery-arts-and-sports-club-mekkad-ernakulam-sports-clubs-t33o43kbtc.jpg',
    'https://www.getactivesports.com/wp-content/uploads/2017/11/1.jpg',
    'https://www.shutterstock.com/image-photo/interior-modern-tennis-european-sport-260nw-205695373.jpg',
  ];

  String clubVideo =
      'https://img.freepik.com/free-vector/gradient-halftone-basketball-youtube-thumbnail_23-2149354206.jpg?size=626&ext=jpg&ga=GA1.2.704593638.1688122618&semt=ais';
  List<ClubMemberModel> presidentData = [
    ClubMemberModel.member(
      "Bronte Howson",
      "",
      "brownte@example.com",
      "9876543211",
    ),
  ];
  List<ClubMemberModel> directors = [
    ClubMemberModel.member(
      "Tom Percy QC",
      "",
      "tomp@example.com",
      "9876543211",
    ),
    ClubMemberModel.member(
      "Joe Barbaro",
      "",
      "jbosh@example.com",
      "9876543211",
    ),
    ClubMemberModel.member(
      "Geoff Bailey",
      "",
      "gbaily@example.com",
      "9876543211",
    ),
  ];

  List<ClubMemberModel> otherContactDetail = [
    ClubMemberModel.member(
      "Martin Mileham",
      "CEO",
      "mmham@example.com",
      "9876543211",
    ),
    ClubMemberModel.member(
      "James Sansalone",
      "Marketing manager",
      "mmham@example.com",
      "9876543211",
    ),
  ];

  List<ClubMemberModel> buildCoachList = [
    ClubMemberModel.coach(
        userName: "Martin Mileham",
        role: "Defence",
        email: "mmham@example.com",
        phone: "9876543211",
        dateOfBirth: '09/11/1990',
        totalExperience: "3 year exp"),
  ];

// List<FavouriteTypeModel> getFavouriteList = [
//   FavouriteTypeModel(title: 'My Favourite Clubs', itemId: ''),
//   FavouriteTypeModel(title: 'High Priority Clubs', itemId: ''),
//   FavouriteTypeModel(title: 'AFL', itemId: ''),
//   FavouriteTypeModel(title: 'Best Clubs', itemId: ''),
//   FavouriteTypeModel(title: 'Most Famous', itemId: ''),
//   FavouriteTypeModel(title: 'Friend Reference', itemId: ''),
// ];
//
// List<FavouriteTypeModel> getFavouriteListForDummyList = [
//   FavouriteTypeModel(title: 'High Priority Clubs', itemId: ''),
//   FavouriteTypeModel(title: 'Best Clubs', itemId: ''),
//   FavouriteTypeModel(title: 'Friend Reference', itemId: ''),
// ];
}
