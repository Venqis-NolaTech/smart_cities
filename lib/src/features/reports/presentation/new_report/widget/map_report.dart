import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/auth/domain/entities/user.dart';
import 'package:smart_cities/src/features/reports/presentation/new_report/providers/create_report_provider.dart';
import 'package:smart_cities/src/features/reports/presentation/new_report/widget/header_report.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/constant.dart';


class MapReport extends StatefulWidget {
  final CreateReportProvider provider;

  MapReport({Key key, this.provider}) : super(key: key);

  @override
  _MapReportState createState() => _MapReportState();
}

class _MapReportState extends State<MapReport> {
  Completer<GoogleMapController> _mapController = Completer();
  GoogleMap _googleMap;
  static const _mapZoom = 15.5;

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        HeaderReport( numberStep: S.of(context).one, tittle: S.of(context).ubicationPin),

        Expanded(
          child: Container(
            child: Stack(
              children: [
                buildGoogleMap(),
                Center(
                  child: Image.asset(AppImagePaths.mapPoint, height: 70, fit: BoxFit.contain),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildGoogleMap() {


    if (widget.provider.location != null) {
      _updateMapCameraByPosition(widget.provider.location );
    }


    if (_googleMap == null)
      return GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.provider.location != null
              ? LatLng(widget.provider.location.latitude, widget.provider.location.latitude)
              : kDefaultLocation,
          zoom: _mapZoom,
        ),
        //myLocationEnabled: true,
        //myLocationButtonEnabled: true,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        onMapCreated: (controller) {
          if (!_mapController.isCompleted) {
            _mapController.complete(controller);
          }
        },
        onCameraMove: (CameraPosition position) {
          print(position.toString());
          //widget.provider.location=Position(latitude: position.)
        },
      );

    else
      return _googleMap;
  }

  void _updateMapCameraByPosition(Position position, {zoom: _mapZoom}) async {
    final GoogleMapController controller = await _mapController.future;

    controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: zoom)));
  }
}

