import 'package:flutter/material.dart';

import '../../../../../values/app_colors.dart';
import '../../../../../values/app_string.dart';
import '../../../../../values/app_values.dart';

class MapContainerWidget extends StatefulWidget {
  String mapUrl;

  MapContainerWidget({required this.mapUrl, Key? key}) : super(key: key);

  @override
  State<MapContainerWidget> createState() => _MapContainerWidgetState();
}

class _MapContainerWidgetState extends State<MapContainerWidget> {
  // final Completer<GoogleMapController> _controller =
  //     Completer<GoogleMapController>();
  //
  // static const CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 14.4746,
  // );
  //
  // static const CameraPosition _kLake = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(37.43296265331129, -122.08832357078792),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);

  /// text theme
  late TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(
          left: AppValues.padding_4,
          top: AppValues.height_20,
          right: AppValues.padding_4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [buildClubUserActionButtonRow(), buildMapView()],
      ),
    );
  }

  /// build club action button row.
  Widget buildClubUserActionButtonRow() => Padding(
        padding: const EdgeInsets.only(top: AppValues.height_16),
        child: buildTitle(),
      );

  /// build title button.
  Widget buildTitle() => Text(
        AppString.location,
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        style:
            textTheme.headlineMedium?.copyWith(color: AppColors.textColorWhite),
      );

  Widget buildMapView() => Container(
        height: 170,
        margin: const EdgeInsets.only(top: AppValues.height_6),
        width: double.infinity,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppValues.radius)),
        child: widget.mapUrl.isNotEmpty
            ? Image.network(
                widget.mapUrl,
                fit: BoxFit.cover,
              )
            : _noLocationAvailable(),
      );

  /// No location available
  Widget _noLocationAvailable() {
    return SizedBox(
      height: 100,
      child: Center(
          child: Text(AppString.noLocationAvailable,
              style: textTheme.displaySmall
                  ?.copyWith(color: AppColors.textColorTernary))),
    );
  }
}
