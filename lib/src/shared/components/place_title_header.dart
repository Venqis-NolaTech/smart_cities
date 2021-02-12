import 'package:flutter/material.dart';

import 'package:smart_cities/src/features/places/domain/entities/place.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';
import 'package:smart_cities/src/shared/app_colors.dart';

class PlaceTitleHeader extends StatelessWidget {
  final Place place;
  const PlaceTitleHeader({Key key, this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 24.0, right: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            place.name,
            textAlign: TextAlign.start,
            style: kBigTitleStyle.copyWith(
              color: AppColors.blueBtnRegister,
            ),
          ),
          Spaces.verticalSmall(),
          Text(
            place.address ?? '',
            textAlign: TextAlign.start,
            style: kSmallTextStyle.copyWith(
              color: AppColors.blueBtnRegister,
            ),
          ),
        ],
      ),
    );
  }
}
