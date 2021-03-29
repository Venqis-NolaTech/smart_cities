import 'package:flutter/material.dart';
import 'package:smart_cities/src/features/places/domain/entities/place.dart';
import 'package:smart_cities/src/features/auth/domain/entities/user.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/components/custom_card.dart';
import 'package:smart_cities/src/shared/components/firebase_storage_image.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/map_utils.dart';

import '../../../../../shared/spaces.dart';


class PlaceItem extends StatelessWidget {


  final Place place;
  final bool isFirst;
  final bool isLast;
  final bool topAndBottomPaddingEnabled;
  final Function onTap;
  final Position currentLocation;

  const PlaceItem(
      {Key key,
      @required this.place,
      this.isFirst= false,
      this.isLast= false,
      this.topAndBottomPaddingEnabled= false,
      this.onTap,
      this.currentLocation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var referenceUrl = place.images.isNotEmpty ? place.images.first : null;



    return CustomCard(
      margin: EdgeInsets.only(
        top: isFirst && topAndBottomPaddingEnabled
            ? 70.0
            : isFirst && !topAndBottomPaddingEnabled
            ? 16.0
            : 0.0,
        bottom: isLast && topAndBottomPaddingEnabled ? 86.0 : 16.0,
        left: 16.0,
        right: 16.0,
      ),
      onTap: onTap,
      child: Column(
        children: [

          Container(
            height: 100,
            width: double.infinity,
            child: Material(
              child:  place.images.isEmpty || referenceUrl != null
                  ? FirebaseStorageImage(
                referenceUrl: referenceUrl,
                fit: BoxFit.fitWidth,
                errorWidget: Image.asset(AppImagePaths.defaultImage, fit: BoxFit.fitWidth),
                fallbackWidget: CircularProgressIndicator(),
                //errorWidget: AppImages.defaultImage,
              )
                  : Image.asset(AppImagePaths.defaultImage, fit: BoxFit.fitWidth),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(
                          place.name,
                          style: kTitleStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.blueBtnRegister),
                        )),

                  ],

                ),

                Spaces.verticalSmall(),

                Flexible(
                  child: Text(
                    place.aboutTitle ?? '',
                    maxLines: 2,
                    textAlign: TextAlign.left,
                    style: kNormalStyle.copyWith(
                        color: AppColors.blueBtnRegister),
                  ),
                ),

                Spaces.verticalSmall(),

                currentLocation !=null ? FutureBuilder<int>(
                    future: MapsUtils.distanceInMeters(currentLocation.latitude,
                        currentLocation.longitude, place.latitude, place.longitude),
                    builder: (_, snapshot) {
                      if (snapshot.hasData)
                        return _buildDistance(snapshot.data);
                      else
                        return Container();
                    }) : Container(),


              ],
            ),
          ),









        ],
      ),
    );
  }



  Widget _buildDistance(int data) {
    String unidad= 'Mts';
    int distancia= data;

    if (data>1000) {
      distancia = (data / 1000).round();
      unidad = 'Km';
    }


    return   Row(
      children: [
        Text('$distancia $unidad',
            style:  kNormalStyle.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.blueBtnRegister),),
      ],
    );

  }

}
