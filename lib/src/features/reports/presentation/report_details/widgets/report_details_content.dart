import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../../generated/i18n.dart';
import '../../../../../shared/app_colors.dart';
import '../../../../../shared/constant.dart';
import '../../../../../shared/image_utils.dart';
import '../../../../../shared/spaces.dart';
import '../../../domain/entities/report.dart';

class ReportDetailsContent extends StatelessWidget {
  ReportDetailsContent({
    Key key,
    @required this.report,
  }) : super(key: key);

  final Report report;

  LatLng _getLocation() {
    final lat = report?.latitude;
    final logn = report?.longitude;

    if (lat != 0 && logn != 0) return LatLng(lat, logn);

    return null;
  }

  Future<Marker> _buildMarker() async {
    
    var markerId = MarkerId(report.id.toString());
    var icon = await ImageUtil.getImage(Platform.isAndroid ? report.iconPath : report.iconPathiOS, width: 78, height: 78);

    return Marker(
      markerId: markerId,
      icon: icon,
      position: _getLocation(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Spaces.verticalMedium(),
          Container(
            color: Colors.grey.withOpacity(0.1),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Row(
                children: [
                  Expanded(child: Text(S.of(context).category, style: kNormalStyle.copyWith(color: AppColors.primaryTextLight),)),
                ],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primaryText.withOpacity(0.2))
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      report?.category?.value,
                      textAlign: TextAlign.center,
                      style: kSmallTextStyle.copyWith(
                        color: AppColors.primaryText),),
                  ),
                ],
              ),
            ),
          ),

          ..._buildMap(context),
        ],
      ),
    );
  }

  List<Widget> _buildMap(BuildContext context) {
    final reportLocation = _getLocation();
    final children = List<Widget>();

    if (reportLocation != null) {
      children.addAll(
        [
          Container(
            height: 250,
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
                    target: reportLocation,
                    zoom: 14,
                  ),
                  mapType: MapType.normal,
                );
              },
            ),
          ),
          Spaces.verticalLarge(),
        ],
      );
    }

    return children;
  }
}
