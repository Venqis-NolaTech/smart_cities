import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_cities/src/features/route/presentation/see_route/provider/route_provider.dart';
import 'package:smart_cities/src/features/route/presentation/see_route/widget/card_route.dart';
import 'package:smart_cities/src/features/select_sector/presentation/page/select_sector_page.dart';

import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/app_colors.dart';


class MapSeeRoute extends StatefulWidget {
  final RouteProvider provider;
  static const _mapZoom = 13.0;

  MapSeeRoute({Key key, @required this.provider}) : super(key: key);

  @override
  _MapSeeRouteState createState() => _MapSeeRouteState();
}

class _MapSeeRouteState extends State<MapSeeRoute> {
  GoogleMap _googleMap;

  Completer<GoogleMapController> _mapController = Completer();

  Map<PolygonId, Polygon> polygons = <PolygonId, Polygon>{};
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};

  int _polygonIdCounter = 0;
  int _polylineIdCounter = 0;

  @override
  void initState() {
    // TODO: implement initState
    _buildDataMap();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildMap(),
        /*FutureBuilder(
          future: _buildDataMap(),
          initialData: null,
          builder: (context, snapshot) {
            return _buildMap();
          },
        ),*/
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: FloatingActionButton(
                  backgroundColor: AppColors.white,
                  child: Icon(
                    MdiIcons.crosshairsGps,
                    color: AppColors.blueBtnRegister,
                  ),
                  onPressed: () {}),
            ),
            CardOptionRoute(
              selectedDate: widget.provider.selectedDate,
              selectedSector: widget.provider.selectedSector,
              isMunicipality: false,
              textButtom: S.of(context).change,
              onChange: ()async {

                var result= await Navigator.pushNamed(context, SelectSectorPage.id);
                print('sector seleccionado $result');
                if(result!=null) {
                  widget.provider.selectedSector = result;
                }

              }
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMap() {

    if(polygons.isEmpty && polylines.isEmpty)
      return Container();


    if(_googleMap==null) {
      _googleMap = GoogleMap(
        initialCameraPosition: CameraPosition(
          target: kDefaultLocation,
          zoom: MapSeeRoute._mapZoom,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        polygons: Set<Polygon>.of(polygons.values),
        polylines: Set<Polyline>.of(polylines.values),
        onMapCreated: (controller) {
          _mapController.complete(controller);
        },
        onTap: (_) {

        },
      );
    }

    return _googleMap;
  }


  // solo para simular datos de momento
  void _add() {
    final int polygonCount = polygons.length;

    if (polygonCount == 12) {
      return;
    }

    final String polygonIdVal = 'polygon_id_$_polygonIdCounter';
    final PolygonId polygonId = PolygonId(polygonIdVal);

    final Polygon polygon = Polygon(
      polygonId: polygonId,
      consumeTapEvents: true,
      strokeColor: AppColors.strokeColorMap,
      strokeWidth: 1,
      fillColor: AppColors.fillColorMap.withOpacity(0.3),
      points: _createPoints(),
      onTap: () {

      },
    );

    polygons[polygonId] = polygon;
    _polygonIdCounter++;
  }
  // solo para simular datos de momento
  void _addPolyline() {
    final int polylineCount = polylines.length;

    if (polylineCount == 12) {
      return;
    }

    final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
    _polylineIdCounter++;
    final PolylineId polylineId = PolylineId(polylineIdVal);

    final Polyline polyline = Polyline(
      polylineId: polylineId,
      consumeTapEvents: true,
      color: AppColors.fillColorMap,
      width: 5,
      points: _createPointsLine(),
      onTap: () {

      },
    );
    polylines[polylineId] = polyline;
  }

  // solo para simular datos de momento
  List<LatLng> _createPointsLine() {
    final List<LatLng> points = <LatLng>[];

    points.add(_createLatLng(8.98889, -79.55123)); //
    points.add(_createLatLng(8.99665, -79.55926)); //
    points.add(_createLatLng(9.00322, -79.54441)); //
    points.add(_createLatLng(8.99851, -79.53814)); //
    points.add(_createLatLng(8.9969, -79.54308));
    return points;
  }

  // solo para simular datos de momento
  List<LatLng> _createPoints() {
    final List<LatLng> points = <LatLng>[];

    points.add(_createLatLng(8.97983, -79.51386)); //
    points.add(_createLatLng(8.94829, -79.57737)); //
    points.add(_createLatLng(8.97966, -79.56072)); //
    points.add(_createLatLng(8.9844, -79.58578)); //
    points.add(_createLatLng(9.00322, -79.54441));
    return points;
  }

  LatLng _createLatLng(double lat, double lng) {
    return LatLng(lat, lng);
  }

  _buildDataMap() {
    _addPolyline();
    _add();
  }

}
