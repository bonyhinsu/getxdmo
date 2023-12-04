import '../../user_info_model.dart';

class PostListResponse {
  bool? status;
  int? code;
  List<PostListResponseData>? data;
  String? message;

  PostListResponse({this.status, this.code, this.data, this.message});

  PostListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    if (json['data'] != null) {
      data = <PostListResponseData>[];
      json['data'].forEach((v) {
        data!.add(PostListResponseData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class PostListResponseData {
  int? id;
  int? userId;
  int? postTypeId;
  String? title;
  String? selectTime;
  String? selectDate;
  String? score;
  String? age;
  String? gender;
  String? location;
  String? level;
  String? typeOfEvent;
  String? participantsA;
  String? profileImage;
  String? username;
  String? participantsB;
  String? image;
  String? otherDetails;
  String? highlights;
  String? references;
  String? skill;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? allPostImages;
  String? imagePost;
  PostTypeDetails? postTypeDetails;
  UserDetails? userDetails;
  List<PostImages>? postImages;

  PostListResponseData(
      {this.id,
      this.userId,
      this.postTypeId,
      this.title,
      this.selectTime,
      this.selectDate,
      this.score,
      this.age,
      this.gender,
      this.location,
      this.level,
      this.imagePost,
      this.typeOfEvent,
      this.participantsA,
      this.participantsB,
      this.image,
      this.otherDetails,
      this.highlights,
      this.references,
      this.skill,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.postTypeDetails,
      this.allPostImages,
      this.username,
      this.profileImage,
      this.userDetails,
      this.postImages});

  PostListResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    postTypeId = json['postTypeId'];
    title = json['title'];
    selectTime = json['selectTime'];
    selectDate = json['selectDate'];
    score = json['score'];
    age = json['age'];
    gender = json['gender'];
    location = json['location'];
    level = json['level'];
    typeOfEvent = json['typeOfEvent'];
    participantsA = json['participantsA'];
    participantsB = json['participantsB'];
    image = json['image'];
    otherDetails = json['otherDetails'];
    highlights = json['highlights'];
    references = json['references'];
    skill = json['skill'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    allPostImages = json['allPostImages'];
    username = json['username'];
    profileImage = json['profileImage'];
    imagePost = json['imagePost'];
    postTypeDetails = json['postTypeDetails'] != null
        ? new PostTypeDetails.fromJson(json['postTypeDetails'])
        : null;
    userDetails = json['userDetails'] != null
        ? UserDetails.fromJson(json['userDetails'])
        : null;
    if (json['postImages'] != null) {
      postImages = <PostImages>[];
      json['postImages'].forEach((v) {
        postImages!.add(PostImages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['postTypeId'] = postTypeId;
    data['title'] = title;
    data['selectTime'] = selectTime;
    data['selectDate'] = selectDate;
    data['score'] = score;
    data['age'] = age;
    data['gender'] = gender;
    data['location'] = location;
    data['level'] = level;
    data['typeOfEvent'] = typeOfEvent;
    data['participantsA'] = participantsA;
    data['participantsB'] = participantsB;
    data['image'] = image;
    data['otherDetails'] = otherDetails;
    data['highlights'] = highlights;
    data['references'] = references;
    data['skill'] = skill;
    data['allPostImages'] = allPostImages;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deletedAt'] = deletedAt;
    data['profileImage'] = profileImage;
    data['username'] = username;
    data['imagePost'] = imagePost;
    if (postTypeDetails != null) {
      data['postTypeDetails'] = postTypeDetails!.toJson();
    }
    if (userDetails != null) {
      data['userDetails'] = userDetails!.toJson();
    }
    if (this.postImages != null) {
      data['postImages'] = postImages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PostTypeDetails {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  PostTypeDetails({this.id, this.name, this.createdAt, this.updatedAt});

  PostTypeDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class PostImages {
  int? id;
  String? image;
  bool isUrl = true;
  String deletedImageUrl = '';

  bool get imageAvailable => (image ?? "").isNotEmpty;

  PostImages({this.id, this.image, this.isUrl = false});

  void convertToDelete() {
    deletedImageUrl = image ?? "";
    image = "";
    isUrl = false;
  }

  PostImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['image'] = image;
    return data;
  }
}
