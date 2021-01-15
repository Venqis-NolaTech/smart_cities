import 'package:flutter/material.dart';

import '../../../../../../generated/i18n.dart';
import '../../../../../shared/app_colors.dart';
import '../../../../../shared/components/number_id_container.dart';
import '../../../../../shared/components/status_container.dart';
import '../../../../../shared/constant.dart';
import '../../../../../shared/spaces.dart';
import '../../../domain/entities/report.dart';

class ReportDetailsSubHeader extends StatelessWidget {
  ReportDetailsSubHeader({
    Key key,
    @required this.report,
    @required this.onFollow,
  }) : super(key: key);

  final Report report;
  final Function onFollow;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(child: StatusContainer(report: report)),
                NumberIdContainer(report: report),
              ],
            ),
          ),
          Container(
            color: Colors.grey.withOpacity(0.3),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                      child: Text(
                    S.of(context).description,
                    style: kNormalStyle.copyWith(
                        color: AppColors.primaryTextLight),
                  )),
                  _buildRightContent(context)
                ],
              ),
            ),
          ),
          Spaces.verticalSmall(),
        ],
      ),
    );
  }

  Widget _buildRightContent(BuildContext context) {
    return GestureDetector(
      onTap: onFollow,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.colorFollow),
            borderRadius: BorderRadius.circular(25),
            color: report.follow ? AppColors.colorFollow : Colors.white),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
          child: Text(
            report.follow ? S.of(context).followTrue : S.of(context).follow,
            textAlign: TextAlign.center,
            style: kSmallTextStyle.copyWith(
                color: report.follow ? Colors.white : AppColors.colorFollow),
          ),
        ),
      ),
    );
  }
}
