
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../../generated/i18n.dart';
import '../../../../../core/util/string_util.dart';
import '../../../../../shared/app_colors.dart';
import '../../../../../shared/components/read_more_text.dart';
import '../../../../../shared/components/rounded_button.dart';
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
    var icon = await ImageUtil.getImage(report.iconPath, width: 78, height: 78);

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /*Text(
            S.of(context).description.capitalize,
            style: kSmallestTextStyle.copyWith(
              color: Colors.grey,
            ),
          ),
          Spaces.verticalMedium(),*/
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: ReadMoreText(
              report?.description ?? "",
              trimCollapsedText: S.of(context).showMore.toLowerCase(),
              trimExpandedText: S.of(context).showLess.toLowerCase(),
              trimLines: 4,
              trimMode: TrimMode.Line,
              colorClickableText: AppColors.blue,
              style: kSmallTextStyle.copyWith(color: AppColors.blueBtnRegister),
            ),
          ),
          Spaces.verticalMedium(),
          Container(
            color: Colors.grey.withOpacity(0.3),
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
          /*RoundedButton(
            title: S.of(context).downloadAttachments.toUpperCase(),
            color: Colors.white,
            elevation: 0.0,
            borderColor: AppColors.red,
            style: TextStyle(
              color: AppColors.red,
            ),
            onPressed: null /*() => Navigator.pushNamed(
              context,
              ReportFilesPage.id,
              arguments: report.filesUrls,
            ),*/
          ),
          Spaces.verticalLarge(),*/
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
            height: 180,
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
