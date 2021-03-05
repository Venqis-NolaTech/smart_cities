import 'package:flutter/material.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:smart_cities/src/shared/constant.dart';

class RealTime extends StatelessWidget {
  GoogleMap _googleMap;
  static const _mapZoom = 11.0;
  final _key = GlobalKey<GoogleMapStateBase>();

  RealTime({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        _buildMap()
      ],
     
    );
  }


  Widget _buildMap() {


    if (_googleMap == null) {
      _googleMap = GoogleMap(
        key: _key,
        initialPosition: GeoCoord(
            /*location != null ? location.latitude :*/ kDefaultLocation.latitude,
            /*location != null ? location.longitude :*/ kDefaultLocation.longitude),
        initialZoom: _mapZoom,
        mobilePreferences: const MobileMapPreferences(
          trafficEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
        ),
        webPreferences: WebMapPreferences(
          fullscreenControl: true,
        ),
        onTap: (_) {

        },
      );
    }

    return _googleMap;
  }
}