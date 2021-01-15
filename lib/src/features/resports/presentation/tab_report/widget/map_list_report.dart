import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/core/error/failure.dart';
import 'package:smart_cities/src/features/auth/domain/entities/user.dart';
import 'package:smart_cities/src/features/auth/presentation/base/providers/phone_number_auth_provider.dart';
import 'package:smart_cities/src/features/auth/presentation/phone_number/pages/phone_number_page.dart';
import 'package:smart_cities/src/features/resports/domain/entities/report.dart';
import 'package:smart_cities/src/features/resports/presentation/list/provider/nearby_report_provider.dart';
import 'package:smart_cities/src/features/resports/presentation/new_report/pages/general_report.dart';
import 'package:smart_cities/src/features/resports/presentation/report_details/pages/report_details_page.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/components/base_view.dart';
import 'package:smart_cities/src/shared/components/info_view.dart';
import 'package:smart_cities/src/shared/components/rounded_button.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/image_utils.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';



class MapListReport extends StatefulWidget {
  static const _mapZoom = 15.5;

  @override
  _MapListReportState createState() => _MapListReportState();
}

class _MapListReportState extends State<MapListReport> {
  Report _selectedReport = null;

  GoogleMap _googleMap;
  final _key = GlobalKey<GoogleMapStateBase>();

  List<Report> _reports=[];

  @override
  Widget build(BuildContext context) {

    return BaseView<NearbyReportProvider>(
      onProviderReady: (provider) => provider.loadReports(),
      builder: (context, provider, child){

        //_provider = provider;
        final currentState = provider.currentState;

        if (currentState is Error) {
          final failure = currentState.failure;

          return _buildErrorView(context, failure);
        }
        if (currentState is Loaded) {

          _buildMarkers(currentState, provider);
        }

        return ModalProgressHUD(
          inAsyncCall: currentState is Loading,
          child: Stack(
            children: [

              /*FutureBuilder<List<Marker>>(
                future: _buildMarkers(currentState),
                initialData: [],
                builder: (context, snapshot) {
                  return _buildMap(provider, snapshot.data ?? []);
                },
              ),*/
              _buildMap(provider),

              Positioned(
                  top: 20,
                  right: 40,
                  left: 40,
                  child: FlatButton(
                      color: AppColors.blueBtnRegister,
                      onPressed: () {},
                      child: Text('Incidentes reportados en tu área',
                        style: kNormalStyle.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),))),


              Positioned(
                bottom: 20,
                right: 30,
                left: 30,
                child: FlatButton(
                  onPressed: () => Navigator.pushNamed(context, NewReport.id),
                  color: AppColors.blueBtnRegister,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    //side: BorderSide(color: AppColors.blueLight)
                  ),
                  child: Text(
                    'Crear Reporte',
                    style: kMediumTitleStyle.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),



              //ConfirmationAccount()
            ],
          ),
        );

      },

    );

  }

  /*void _updateMapCameraByPosition(Position position, {zoom: MapListReport._mapZoom}) async {
    if(!mounted)
      return;
    final GoogleMapController controller = await _mapController.future;

    controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: zoom)));
  }*/

  GoogleMap _buildMap(NearbyReportProvider provider) {
    final location = provider.location != null && _selectedReport == null
        ? provider.location
        : _selectedReport != null
        ? Position(
        latitude: _selectedReport.latitude,
        longitude: _selectedReport.longitude)
        : null;

    if (location != null) {
      //_updateMapCameraByPosition(location);
    }

    if (_googleMap == null) {
      _googleMap = GoogleMap(
        key: _key,
        initialPosition: GeoCoord(kDefaultLocation.latitude, kDefaultLocation.longitude),
        initialZoom: MapListReport._mapZoom,

        mobilePreferences: const MobileMapPreferences(
          trafficEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
        ),
        webPreferences: WebMapPreferences(
          fullscreenControl: true,
        ),

        /*onTap: (_) {
          _resetSelectedReport();
        },*/
      );
    }

    return _googleMap;
  }


  void _buildMarkers(ViewState state, NearbyReportProvider provider) async {
    _reports = (state as Loaded<List<Report>>).value;

    GoogleMap.of(_key).moveCamera(GeoCoord(provider.location.latitude, provider.location.longitude), animated: true);



    for(var i in _reports){

      GoogleMap.of(_key).addMarker(
        Marker(
         GeoCoord( i.latitude, i.longitude),
          icon: i.iconPath,
          onTap: (value)=> _onTapMarker(i)
        )
      );
    }

    GoogleMap.of(_key).addMarker(
        Marker(
            GeoCoord(provider.location.latitude, provider.location.longitude),
            icon: AppImagePaths.mapIcon)
    );


  }

  /*Future<Marker> _buildMarker(Report report) async {
    var markerId = MarkerId(report.id.toString());
    var icon = await ImageUtil.getImage(report.iconPath, width: 78, height: 78);

    return Marker(
      markerId: markerId,
      icon: pinLocationIcon,
      position: LatLng(report.latitude, report.longitude),
      onTap: () => _onTapMarker(report),
    );
  }*/

  void _onTapMarker(Report report) {
    /*setState(() {
      _isVisibleReportGotoBtn = true;
      _selectedReport = report;
    });

    _showBottomSheet();*/


    Navigator.pushNamed(
      context,
      ReportDetailsPage.id,
      arguments: report,
    );
  }

  Widget _buildErrorView(BuildContext context, Failure failure) {
    return InfoView(
      height: MediaQuery.of(context).size.height,
      image: failure is UserNotFoundFailure ? AppImages.iconMessage : Container(height: 48),
      title: failure is UserNotFoundFailure ? S.of(context).userNotFoundTittle: S.of(context).error,
      titleStyle: kMediumTitleStyle.copyWith(color: Colors.grey.shade500),
      description: failure is UserNotFoundFailure ? S.of(context).userNotFoundMessage : S.of(context).unexpectedErrorMessage,
      descriptionStyle: kNormalStyle.copyWith(color: Colors.grey.shade500),
      child: failure is UserNotFoundFailure ? btnIniciar(context) : Container(),
    );
  }

  Widget btnIniciar(BuildContext context){
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: RoundedButton(
            color: AppColors.blueBtnRegister,
            title: S.of(context).login.toUpperCase(),
            style: kTitleStyle.copyWith(fontFamily: 'Roboto', fontWeight: FontWeight.bold,  color: AppColors.white),
            onPressed: () => //Navigator.pushNamedAndRemoveUntil(context, PhoneNumberPage.id, ModalRoute.withName(PhoneNumberPage.id))
            Navigator.pushReplacementNamed(
              context,
              PhoneNumberPage.id,
              arguments: AuthMethod.login,
            )
        )
    );
  }
}
