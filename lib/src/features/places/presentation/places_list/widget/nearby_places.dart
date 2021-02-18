import 'dart:async';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/core/error/failure.dart';
import 'package:smart_cities/src/features/places/domain/entities/place.dart';
import 'package:smart_cities/src/features/places/presentation/places_list/provider/places_provider.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/components/base_view.dart';
import 'package:smart_cities/src/shared/components/info_view.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';

import '../../../../../../app.dart';

class NearbyPlaces extends StatefulWidget {
  NearbyPlaces({
    Key key,
    @required this.category,
  }) : super(key: key);

  final String category;

  @override
  _NearbyPlacesState createState() => _NearbyPlacesState();
}

class _NearbyPlacesState extends State<NearbyPlaces> {
  GoogleMap _googleMap;
  static const _mapZoom = 11.0;
  final _key = GlobalKey<GoogleMapStateBase>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BaseView<PlacesProvider>(
      onProviderReady: (provider) => provider.loadNearbyPlace(
          category: widget.category,
          municipality: currentUser.municipality.key),


      builder: (context, provider, child){
        final currentState = provider.currentState;

        if (currentState is Error) {
          final failure = currentState.failure;

          return _buildErrorView(context, failure);
        }


       if (currentState is Loaded) {
          _buildMarkers(provider);
        }



        return ModalProgressHUD(
            inAsyncCall: currentState is Loading,
            child: Stack(
              children: [



                _buildMap(provider),
                Positioned(
                    top: 20,
                    right: 40,
                    left: 40,
                    child: FlatButton(
                        color: AppColors.blueBtnRegister,
                        onPressed: () {},
                        child: Text(
                          S.of(context).placesInLocation,
                          style: kNormalStyle.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ))),

              ],
            )
        );
      },
    );
  }

  Widget _buildMap(PlacesProvider provider) {
    final location = provider.currentLocation;

    if (location != null) {
      //_updateMapCameraByPosition(location);
    }


    if (_googleMap == null) {
      _googleMap = GoogleMap(
        key: _key,
        initialPosition: GeoCoord(
            location != null ? location.latitude : kDefaultLocation.latitude,
            location != null ? location.longitude : kDefaultLocation.longitude),
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


  Future<void> _buildMarkers(PlacesProvider provider) async {

    GoogleMap.of(_key).moveCamera(
        GeoCoord(provider.currentLocation.latitude, provider.currentLocation.longitude),
        animated: true);

    for (var i in provider.placesList) {
      GoogleMap.of(_key).addMarker(Marker(GeoCoord(i.latitude, i.longitude),
          icon: AppImagePaths.openStatus, onTap: (value) => _onTapMarker(i)));
    }

    GoogleMap.of(_key).addMarker(Marker(
        GeoCoord(provider.currentLocation.latitude, provider.currentLocation.longitude),
        icon: AppImagePaths.mapIcon));
  }




  Widget _buildErrorView(BuildContext context, Failure failure) {
    return InfoView(
      height: MediaQuery.of(context).size.height*0.7,
      image: AppImages.iconMessage,
      title: S.of(context).error,
      titleStyle: kMediumTitleStyle.copyWith(color: Colors.grey.shade500),
      description: S.of(context).unexpectedErrorMessage,
      descriptionStyle: kNormalStyle.copyWith(color: Colors.grey.shade500),
    );
  }

  void _onTapMarker(Place place) {

  }
}
