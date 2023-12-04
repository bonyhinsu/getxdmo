class ClubMemberModel {
  int? userId;
  int? itemId;
  String? userName;
  String? role;
  String? email;
  String? phone;
  String? dateOfBirth;
  String? totalExperience;
  int? gender;

  ClubMemberModel();

  ClubMemberModel.member(this.userName, this.role, this.email, this.phone);

  ClubMemberModel.coach(
      {this.userName = "",
        this.role = "",
        this.email = "",
        this.phone = "",
        this.dateOfBirth = "",
        this.totalExperience = "",
        this.itemId = -1,
        this.gender = 1});
}
