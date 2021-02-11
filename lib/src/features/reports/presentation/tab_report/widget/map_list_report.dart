import 'package:flutter/material.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smart_cities/src/features/reports/presentation/tab_report/widget/btn_iniciar.dart';

import '../../../../../../generated/i18n.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../shared/app_colors.dart';
import '../../../../../shared/app_images.dart';
import '../../../../../shared/components/base_view.dart';
import '../../../../../shared/components/info_view.dart';
import '../../../../../shared/constant.dart';
import '../../../../../shared/provider/view_state.dart';
import '../../../../auth/domain/entities/user.dart';
import '../../../domain/entities/report.dart';
import '../../list/provider/nearby_report_provider.dart';
import '../../new_report/pages/general_report.dart';
import '../../report_details/pages/report_details_page.dart';

class MapListReport extends StatefulWidget {
  static const _mapZoom = 15.5;
  final Function onNewReport;

  const MapListReport({Key key, this.onNewReport}) : super(key: key);


  @override
  _MapListReportState createState() => _MapListReportState();
}

class _MapListReportState extends State<MapListReport> {
  Report _selectedReport = null;

  GoogleMap _googleMap;
  final _key = GlobalKey<GoogleMapStateBase>();

  List<Report> _reports = [];

  @override
  Widget build(BuildContext context) {
    return BaseView<NearbyReportProvider>(
      onProviderReady: (provider) => provider.loadReports(),
      builder: (context, provider, child) {
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
                      child: Text(
                        S.of(context).reportInLocation,
                        style: kNormalStyle.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ))),

              Positioned(
                bottom: 20,
                right: 30,
                left: 30,
                child: FlatButton(
                  onPressed: () async {
                    var result= await Navigator.pushNamed(context, NewReport.id);
                    if(result!= null && result)
                      widget.onNewReport();
                  },
                  color: AppColors.blueBtnRegister,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    //side: BorderSide(color: AppColors.blueLight)
                  ),
                  child: Text(
                    S.of(context).newReport,
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
        initialPosition:
            GeoCoord(kDefaultLocation.latitude, kDefaultLocation.longitude),
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

    GoogleMap.of(_key).moveCamera(
        GeoCoord(provider.location.latitude, provider.location.longitude),
        animated: true);

    for (var i in _reports) {
      GoogleMap.of(_key).addMarker(Marker(GeoCoord(i.latitude, i.longitude),
          icon: i.iconPath, onTap: (value) => _onTapMarker(i)));
    }

    GoogleMap.of(_key).addMarker(Marker(
        GeoCoord(provider.location.latitude, provider.location.longitude),
        icon: AppImagePaths.mapIcon));
  }

  void _onTapMarker(Report report) {
    Navigator.pushNamed(
      context,
      ReportDetailsPage.id,
      arguments: report,
    );
  }

  Widget _buildErrorView(BuildContext context, Failure failure) {
    return InfoView(
      height: MediaQuery.of(context).size.height*0.7,
      image: AppImages.iconMessage,
      title: failure is UserNotFoundFailure
          ? S.of(context).userNotFoundTittle
          : S.of(context).error,
      titleStyle: kMediumTitleStyle.copyWith(color: Colors.grey.shade500),
      description: failure is UserNotFoundFailure
          ? S.of(context).userNotFoundMessage
          : S.of(context).unexpectedErrorMessage,
      descriptionStyle: kNormalStyle.copyWith(color: Colors.grey.shade500),
      child: failure is UserNotFoundFailure ? BtnLogin() : Container(),
    );
  }

}
