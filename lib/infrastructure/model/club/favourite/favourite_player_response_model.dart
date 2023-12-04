import 'package:game_on_flutter/infrastructure/model/user_info_model.dart';

class FavouritePlayerResponsePlayer {
  bool? status;
  int? code;
  List<FavouritePlayerResponsePlayerData>? data;
  String? message;

  FavouritePlayerResponsePlayer({this.status, this.code, this.data, this.message});

  FavouritePlayerResponsePlayer.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    if (json['data'] != null) {
      data = <FavouritePlayerResponsePlayerData>[];
      json['data'].forEach((v) {
        data!.add(FavouritePlayerResponsePlayerData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    data['code'] = code;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class FavouritePlayerResponsePlayerData {
  int? id;
  int? userId;
  int? favouriteUserId;
  int? favouriteListId;
  String? createdAt;
  String? updatedAt;
  FavouriteListDetails? favouriteListDetails;
  UserDetails? favouriteUserDetails;
  List<Positions>? positions;
  List<Locations>? locations;

  FavouritePlayerResponsePlayerData(
      {this.id,
        this.userId,
        this.favouriteUserId,
        this.favouriteListId,
        this.createdAt,
        this.updatedAt,
        this.favouriteListDetails,
        this.favouriteUserDetails,
        this.locations,
        this.positions});

  FavouritePlayerResponsePlayerData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    favouriteUserId = json['favouriteUserId'];
    favouriteListId = json['favouriteListId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    favouriteListDetails = json['favouriteListDetails'] != null
        ? FavouriteListDetails.fromJson(json['favouriteListDetails'])
        : null;
    favouriteUserDetails = json['favouriteUserDetails'] != null
        ? UserDetails.fromJson(json['favouriteUserDetails'])
        : null;
    if (json['positions'] != null) {
      positions = <Positions>[];
      json['positions'].forEach((v) {
        positions!.add(Positions.fromJson(v));
      });
    }
    if (json['locations'] != null) {
      locations = <Locations>[];
      json['locations'].forEach((v) {
        locations!.add(new Locations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['userId'] = userId;
    data['favouriteUserId'] = favouriteUserId;
    data['favouriteListId'] = favouriteListId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (favouriteListDetails != null) {
      data['favouriteListDetails'] = favouriteListDetails!.toJson();
    }
    if (favouriteUserDetails != null) {
      data['favouriteUserDetails'] = favouriteUserDetails!.toJson();
    }
    if (positions != null) {
      data['positions'] = positions!.map((v) => v.toJson()).toList();
    }
    if (locations != null) {
      data['locations'] = locations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FavouriteListDetails {
  int? id;
  int? userId;
  String? name;
  String? createdAt;
  String? updatedAt;

  FavouriteListDetails(
      {this.id, this.userId, this.name, this.createdAt, this.updatedAt});

  FavouriteListDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['userId'] = userId;
    data['name'] = name;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class Positions {
  int? id;
  int? userId;
  int? positionId;
  String? createdAt;
  String? updatedAt;
  PositionData? positionData;

  Positions(
      {this.id,
        this.userId,
        this.positionId,
        this.createdAt,
        this.updatedAt,
        this.positionData});

  Positions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    positionId = json['positionId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    positionData = json['positionData'] != null
        ? PositionData.fromJson(json['positionData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['userId'] = userId;
    data['positionId'] = positionId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (positionData != null) {
      data['positionData'] = positionData!.toJson();
    }
    return data;
  }
}

class PositionData {
  int? id;
  String? name;
  String? description;
  int? sportTypeId;
  String? createdAt;
  String? updatedAt;

  PositionData(
      {this.id,
        this.name,
        this.description,
        this.sportTypeId,
        this.createdAt,
        this.updatedAt});

  PositionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    sportTypeId = json['sportTypeId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['sportTypeId'] = sportTypeId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class Locations {
  int? id;
  int? userSportDetailId;
  int? locationId;
  String? latitude;
  String? longitude;
  String? createdAt;
  String? updatedAt;
  LocationDetails? locationDetails;

  Locations(
      {this.id,
        this.userSportDetailId,
        this.locationId,
        this.latitude,
        this.longitude,
        this.createdAt,
        this.updatedAt,
        this.locationDetails});

  Locations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userSportDetailId = json['userSportDetailId'];
    locationId = json['locationId'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    locationDetails = json['locationDetails'] != null
        ? new LocationDetails.fromJson(json['locationDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['userSportDetailId'] = userSportDetailId;
    data['locationId'] = locationId;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (locationDetails != null) {
      data['locationDetails'] = locationDetails!.toJson();
    }
    return data;
  }
}

class LocationDetails {
  int? id;
  String? name;
  String? status;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  LocationDetails(
      {this.id,
        this.name,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  LocationDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deletedAt'] = deletedAt;
    return data;
  }
}