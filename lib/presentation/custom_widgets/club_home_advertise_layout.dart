import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:game_on_flutter/infrastructure/model/common/app_fields.dart';
import 'package:get/get.dart';

import '../../values/app_values.dart';

class ClubHomeAdvertiseLayout extends StatelessWidget {
  Function(String link) onClick;

  String advertisementBanner;
  String advertisementLink;

  ClubHomeAdvertiseLayout(
      {required this.onClick,
      required this.advertisementBanner,
      required this.advertisementLink,
      Key? key})
      : super(key: key);

  late TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    Get.log('advertisementBanner ::: -$advertisementBanner');
    return advertisementBanner.isNotEmpty
        ? ListTile(
            onTap: () => onClick(advertisementLink),
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppValues.roundedButtonRadius)),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: 170,
                    width: double.maxFinite,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppValues.smallRadius),
                    )),
                    child: CachedNetworkImage(
                      imageUrl:
                          '${AppFields.instance.imagePrefix}$advertisementBanner',
                      fit: BoxFit.fill,
                    )),
              ],
            ),
          )
        : Container();
  }
}
