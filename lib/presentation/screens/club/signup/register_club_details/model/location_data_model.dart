import '../../../../../../infrastructure/network/network_config.dart';

class LocationDataModel {
  int? location;

  LocationDataModel(this.location);

  LocationDataModel.fromJson(Map<String, dynamic> json) {
    location = json[NetworkParams.locationId];
  }

  Map<String, dynamic> toJson() => {
        NetworkParams.locationId: location,
      };
}
