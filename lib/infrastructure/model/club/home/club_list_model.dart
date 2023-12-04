import '../../../../presentation/screens/club/signup/club_board_members/controllers/club_board_members.controller.dart';
import '../../../../presentation/screens/club/signup/club_board_members/model/club_member_model.dart';
import '../../../../presentation/screens/player/player_profile_privacy/model/selected_club_model.dart';
import '../../player/favourite/favourite_type_model.dart';

class ClubListModel {
  String? clubName;
  String? clubNumber;
  String? email;
  String? address;
  int? id;
  String? totalFollowers;
  String? clubBio;
  String? clubLogo;
  String? intro;
  String? otherInformation;
  String? level;
  String? sports;
  String? location;
  String? position;
  String? date;
  String? locationCoordinates;
  List<String>? clubPictures;
  List<ClubMemberModel>? presidentList;
  List<ClubDetails>? clubDetail;
  List<ClubMemberModel>? boardMembers;
  List<ClubMemberModel>? otherContactMembers;
  List<ClubMemberModel>? coachingStaffs;
  List<FavouriteTypeModel> favouriteList = [];
  String? videos;
  String? mapImage;
  String? clubUUID;
  String? sportLogo;
  bool isLiked = false;
  bool isSelected = false;

  ClubListModel(
      {this.clubName,
      this.clubNumber,
      this.sportLogo,
      this.email,
      this.address,
      this.totalFollowers,
      this.id,
      this.clubBio,
      this.clubLogo,
      this.intro,
      this.otherInformation,
      this.level,
      this.sports,
      this.isSelected = false,
      this.location,
      this.locationCoordinates,
      this.mapImage,
      this.clubPictures,
      this.position,
      this.isLiked = false,
      this.presidentList,
      this.clubDetail,
      this.clubUUID,
      this.boardMembers,
      this.otherContactMembers,
      this.coachingStaffs,
      this.videos});
}
