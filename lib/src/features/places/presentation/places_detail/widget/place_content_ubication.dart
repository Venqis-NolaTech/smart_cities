import 'package:flutter/material.dart';
import 'package:smart_cities/src/features/places/domain/entities/place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/image_utils.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/spaces.dart';

class PlaceContentUbication extends StatelessWidget {
  final Place place;

  const PlaceContentUbication({Key key, this.place}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          child: Text(
            S.of(context).location,
            textAlign: TextAlign.start,
            style: kTitleStyle.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.blueButton),
          ),
        ),
        Spaces.verticalSmall(),
        _buildMap(context)
      ],
    );
  }


   Widget _buildMap(BuildContext context) {
    final placeLocation = _getLocation();

    if (placeLocation != null) {
      return Container(
            height: 150,
            child: FutureBuilder<Marker>(
              future: _buildMarker(),
              initialData: null,
              builder: (context, snapshot) {
                final markers = Set<Marker>.of(
                  snapshot.data != null ? [snapshot.data] : [],
                );

                return GoogleMap(
                  scrollGesturesEnabled: false,
                  zoomGesturesEnabled: false,
                  rotateGesturesEnabled: false,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  markers: markers,
                  initialCameraPosition: CameraPosition(
                    target: placeLocation,
                    zoom: 14,
                  ),
                  mapType: MapType.normal,
                );
              },
            ),
          );
    }

    return Container();
  }



  LatLng _getLocation() {
    final lat = place?.latitude;
    final logn = place?.longitude;

    if (lat != 0 && logn != 0) return LatLng(lat, logn);

    return null;
  }

  Future<Marker> _buildMarker() async {
    var markerId = MarkerId(place.id.toString());
    var icon = await ImageUtil.getImage(AppImagePaths.openStatus, width: 78, height: 78);

    return Marker(
      markerId: markerId,
      icon: icon,
      position: _getLocation(),
    );
  }

}
