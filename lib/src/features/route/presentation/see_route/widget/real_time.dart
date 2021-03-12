import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/route/presentation/see_route/provider/route_provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_cities/src/features/route/presentation/see_route/widget/card_route.dart';
import 'package:smart_cities/src/features/route/presentation/see_route/widget/route_options_modal.dart';
import 'package:smart_cities/src/features/select_sector/presentation/page/select_sector_page.dart';
import 'package:smart_cities/src/features/route/presentation/when_take_out_trash/page/take_out_trash_page.dart';
import 'package:smart_cities/src/shared/app_images.dart';


import 'package:smart_cities/src/shared/components/base_view.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/image_utils.dart';


class RealTime extends StatefulWidget {
  RealTime({Key key}) : super(key: key);

  @override
  _RealTimeState createState() => _RealTimeState();
}

class _RealTimeState extends State<RealTime> {
  GoogleMap _googleMap;
  static const _mapZoom = 15.0;

  Completer<GoogleMapController> _mapController = Completer();

  Map<PolygonId, Polygon> polygons = <PolygonId, Polygon>{};
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  //List<Marker> markers=[];

  int _polygonIdCounter = 0;
  int _polylineIdCounter = 0;
  int _markersIdCounter = 0;



  @override
  void initState() {
    // TODO: implement initState
    //_buildDataMap();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return BaseView<RouteProvider>(
        builder: (context, provider, child ) {
          final currentState = provider.currentState;


          return Stack(
            children: [

              //_buildMap(),
              FutureBuilder<List<Marker>>(
                future: _buildDataMap(),
                initialData: [],
                builder: (context, snapshot) {
                  return _buildMap(snapshot.data ?? []);
                },
              ),

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
                    selectedDate: DateTime.now(),
                    selectedSector: provider.realTimeSector,
                    isMunicipality: provider.isMunicipality,
                    textButtom: S.of(context).menuAboutUsDescription,
                    onChange: () async {
                      if(provider.isMunicipality){
                        await changeSector(context, provider);
                      }else{
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                        return RouteOptionsModal(
                          changeSector: ()=>changeSector(context, provider),
                          onSelectSector: (){
                            Navigator.pushNamed(context, WhenTakeOutTrashPage.id, arguments:provider.realTimeSector);
                          }
                        );
                      },
                        );
                      }


                    },
                  ),
                ],
              ),

            ],

          );

        }
    );
  }

  Future changeSector(BuildContext context, RouteProvider provider) async {
     var result= await Navigator.pushNamed(context, SelectSectorPage.id);
    print('sector seleccionado $result');
    if(result!=null) {
      provider.realTimeSector = result;
    }
  }


  Widget _buildMap(List<Marker> markers) {
    if(markers.isEmpty)
      return Container();

      _googleMap = GoogleMap(
        initialCameraPosition: CameraPosition(
          target: kDefaultLocation,
          zoom: _mapZoom,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        markers: Set<Marker>.of(markers),
        polygons: Set<Polygon>.of(polygons.values),
        polylines: Set<Polyline>.of(polylines.values),
        onMapCreated: (controller) {
          _mapController.complete(controller);
        },
        onTap: (_) {

        },
      );

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
      strokeColor: AppColors.blue,
      strokeWidth: 1,
      fillColor: AppColors.blue.withOpacity(0.05),
      points: _createPoints(),
      onTap: () {

      },
    );

    polygons[polygonId] = polygon;
    _polygonIdCounter++;
  }


  void _addPolyline() {
    final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
    _polylineIdCounter++;
    final PolylineId polylineId = PolylineId(polylineIdVal);

    final Polyline polyline = Polyline(
      polylineId: polylineId,
      consumeTapEvents: true,
      color: AppColors.fillColorMap,
      width: 2,
      points: _createPointsLine(),
      onTap: () {

      },
    );
    polylines[polylineId] = polyline;
  }

  List<LatLng> _createPointsLine() {
    final List<LatLng> points = <LatLng>[];

    points.add(_createLatLng(8.98889, -79.55123)); //
    points.add(_createLatLng(8.99665, -79.55926)); //
    points.add(_createLatLng(9.00322, -79.54441)); //
    points.add(_createLatLng(8.99851, -79.53814)); //
    points.add(_createLatLng(8.9969, -79.54308));
    return points;
  }


  Future<List<Marker>> _buildMarkers() {
    var points=_createPointsLine();
    points.addAll(_createPointsLine2());

    final markers = points.map((i) async {
      final String markersIdVal = 'markers_id_$_markersIdCounter';
      _markersIdCounter++;
      final marker = await _buildMarker(markersIdVal, i.latitude, i.longitude);
      return marker;
    }).toList();

    return Future.wait(markers);

  }

  Future<Marker> _buildMarker(String id, double latitude, double longitude) async {
    var markerId = MarkerId(id);
    var icon = await ImageUtil.getImage(AppImagePaths.camionIcon, width: 78, height: 78);

    return Marker(
      markerId: markerId,
      icon: icon,
      position: LatLng(latitude, longitude),
      onTap: () => {},
    );
  }


  void _addPolyline2() {
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
      width: 2,
      points: _createPointsLine2(),
      onTap: () {

      },
    );
    polylines[polylineId] = polyline;
  }

  List<LatLng> _createPointsLine2() {
    final List<LatLng> points = <LatLng>[];
    points.add(_createLatLng(8.96297, -79.5416));
    points.add(_createLatLng(8.96687, -79.54469));
    points.add(_createLatLng(8.97043, -79.54066));
    points.add(_createLatLng(8.97619, -79.53911));
    return points;
  }

  // solo para simular datos de momento
  List<LatLng> _createPoints() {
    final List<LatLng> points = <LatLng>[];

    points.add(_createLatLng(9.00322, -79.54441));
    points.add(_createLatLng(8.9844, -79.58578));
    points.add(_createLatLng(8.97465, -79.58175));
    points.add(_createLatLng(8.97423, -79.5681));
    points.add(_createLatLng(8.96016, -79.54501));
    points.add(_createLatLng(8.97983, -79.51386));

    return points;
  }

  LatLng _createLatLng(double lat, double lng) {
    return LatLng(lat, lng);
  }

  Future<List<Marker>> _buildDataMap() async {
    _addPolyline();
    _addPolyline2();
    _add();
    return _buildMarkers();
  }
}