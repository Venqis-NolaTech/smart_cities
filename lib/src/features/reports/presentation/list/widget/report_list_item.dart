import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/auth/domain/entities/user.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/components/firebase_storage_image.dart';
import 'package:smart_cities/src/shared/components/number_id_container.dart';
import 'package:smart_cities/src/shared/components/status_container.dart';
import 'package:smart_cities/src/shared/map_utils.dart';

import '../../../../../shared/components/custom_card.dart';
import '../../../../../shared/constant.dart';
import '../../../../../shared/spaces.dart';
import '../../../domain/entities/report.dart';

class ReportListItem extends StatelessWidget {
  ReportListItem({
    Key key,
    @required this.report,
    this.isFirst = false,
    this.isLast = false,
    this.isMyReport = false,
    this.topAndBottomPaddingEnabled = false,
    this.onTap,
    this.onFollow,
    this.currentLocation
  }) : super(key: key);

  final Report report;
  final bool isFirst;
  final bool isLast;
  final bool isMyReport;
  final bool topAndBottomPaddingEnabled;
  final Function onTap;
  final Function onFollow;
  final Position currentLocation;

  String _creatAtFormatted(BuildContext context) =>
      DateFormat('d MMMM y')
          .format(DateTime.parse(report.createdAt).toLocal());


  @override
  Widget build(BuildContext context) {
    var referenceUrl = report.images?.first;

    return CustomCard(
      margin: EdgeInsets.only(
        top: isFirst && topAndBottomPaddingEnabled
            ? 70.0
            : isFirst && !topAndBottomPaddingEnabled
            ? 16.0
            : 0.0,
        bottom: isLast && topAndBottomPaddingEnabled ? 86.0 : 16.0,
        left: 16.0,
        right: 16.0,
      ),
      //padding: EdgeInsets.all(16.0),
      onTap: onTap,
      child: Column(
        children: [

          Container(
            height: 120,
            width: double.infinity,
            child: Material(
              child: referenceUrl != null
                  ? FirebaseStorageImage(
                referenceUrl: referenceUrl,
                fit: BoxFit.fitWidth,
                errorWidget: Image.asset(AppImagePaths.defaultImage, fit: BoxFit.fitWidth),
                fallbackWidget: CircularProgressIndicator(),
                //errorWidget: AppImages.defaultImage,
              )
                  : Image.asset(AppImagePaths.defaultImage, fit: BoxFit.fitWidth),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 10),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                      report.title,
                      style: kTitleStyle.copyWith(
                          color: AppColors.blueBtnRegister),
                    )),
                NumberIdContainer(report: report),
              ],

            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                _creatAtFormatted(context),
                textAlign: TextAlign.start,
                style: kSmallTextStyle.copyWith(
                    color: AppColors.blueBtnRegister.withOpacity(0.5)),
              ),
            ),
          ),

          Spaces.verticalSmall(),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: Row(
              children: [

                _buildLeftContent(context),
                Spaces.horizontalSmall(),
                _buildCenterWidget(context),
                !isMyReport ? _buildRightContent(context) : Container(),
              ],
            ),
          )
          //_buildButtomFollow(context),



        ],
      ),
    );
  }

  Widget _buildCenterWidget(BuildContext context){

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            S.of(context).status,
            style: kSmallTextStyle.copyWith(color: AppColors.primaryTextLight),
          ),
          Spaces.verticalSmallest(),
          StatusContainer(report: report),

        ],
      ),
    );

  }

  Widget _buildLeftContent(BuildContext context) {
    return Expanded(
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            S.of(context).distance,
            style: kSmallTextStyle.copyWith(color: AppColors.primaryTextLight),
          ),
          Spaces.verticalSmallest(),
          FutureBuilder<int>(
              future: MapsUtils.distanceInMeters(currentLocation.latitude,
                  currentLocation.longitude, report.latitude, report.longitude),
              builder: (_, snapshot) {
                if (snapshot.hasData)
                  return _buildDistance(snapshot.data);
                else
                  return Container();
              }),
        ],
      ),
    );
  }


  Widget _buildDistance(int data) {
    String unidad= 'Mts';
    int distancia= data;

    if (data>1000) {
      distancia = (data / 1000).round();
      unidad = 'Km';
    }


    return   Padding(
      padding: const EdgeInsets.only(right: 30),
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
              //border: Border.all(color: AppColors.blueLight),
              color: AppColors.blueLight.withOpacity(0.6)),
          child: Text('$distancia $unidad',
              style: kSmallTextStyle.copyWith(color: AppColors.white))
      ),
    );

  }

  Widget _buildRightContent(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onFollow,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.colorFollow),
              borderRadius: BorderRadius.circular(25),
              color: report.follow ? AppColors.colorFollow : Colors.white
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
            child: Text(
              report.follow ? S.of(context).followTrue : S.of(context).follow,
              textAlign: TextAlign.center,
              style: kSmallTextStyle.copyWith(color: report.follow ? Colors.white : AppColors.colorFollow),
            ),
          ),
        ),
      )
    );



  }




}
