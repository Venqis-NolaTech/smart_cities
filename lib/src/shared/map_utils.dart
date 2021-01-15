import 'dart:io';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class MapsUtils {
  static launchGoogleMapsApp(LatLng position) async {
    String googleMapAppUrl =
        'comgooglemaps://?center=${position.latitude},${position.longitude}&zoom=14&views=traffic&q=${position.latitude},${position.longitude}';
    String googleMapUrl =
        'http://maps.google.com/maps?zoom=14&views=traffic&q=${position.latitude},${position.longitude}';

    if (await canLaunch("comgooglemaps://")) {
      await launch(googleMapAppUrl);
    } else if (await canLaunch(googleMapUrl)) {
      await launch(googleMapUrl);
    } else {
      throw 'Could not launch url';
    }
  }

  static Future<int> distanceInMeters(double currentLatitud,double currentLongitud,  double endLatitud,  double endLongitude) async{
    double distanceInMeters = await Geolocator.distanceBetween(
        currentLatitud,
        currentLongitud,
        endLatitud,
        endLongitude);

    return distanceInMeters.round();
  }


  static launchOnMaps(LatLng position) async {
    final lat = position.latitude;
    final long = position.longitude;

    final googleMapURLScheme = "comgooglemaps://";
    final googleWebMapUrl =
        'http://maps.google.com/maps?zoom=14&views=traffic&q=$lat,$long';

    String mainMapUrl = Platform.isAndroid
        ? 'geo:0,0?q=$lat,$long'
        : '$googleMapURLScheme?center=$lat,$long&zoom=14&views=traffic&q=$lat,$long';

    if (await canLaunch(mainMapUrl)) {
      await launch(mainMapUrl);
    } else if (await canLaunch(googleWebMapUrl)) {
      await launch(googleWebMapUrl);
    } else {
      throw 'Could not launch url';
    }
  }
}
