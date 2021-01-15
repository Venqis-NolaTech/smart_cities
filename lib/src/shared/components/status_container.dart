import 'package:flutter/material.dart';
import 'package:smart_cities/src/features/resports/domain/entities/report.dart';
import 'package:smart_cities/src/shared/spaces.dart';

import '../app_colors.dart';
import '../constant.dart';

class StatusContainer extends StatelessWidget {
  StatusContainer({Key key, @required this.report}) : super(key: key);

  final Report report;

  Color getColor() {
    switch (report.reportStatus) {
      case ReportStatus.Open:
        return AppColors.openStatus;
      case ReportStatus.OnProcess:
        return AppColors.inProgressStatus;
      case ReportStatus.Closed:
        return AppColors.closedStatus;
    }
    return AppColors.openStatus;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
              color: getColor(),
              shape: BoxShape.circle,
            ),
          ),
          Spaces.horizontalSmall(),
          Text(
            report?.reportStatus?.id ?? "",
            style: kSmallestTextStyle.copyWith(
              color: AppColors.primaryTextLight.withOpacity(0.5)
            ),
          ),
        ],
      ),
    );
  }
}
