import 'package:flutter/material.dart';
import 'package:smart_cities/src/features/resports/domain/entities/report.dart';
import 'package:smart_cities/src/shared/spaces.dart';

import '../app_colors.dart';
import '../constant.dart';

class NumberIdContainer extends StatelessWidget {
  final Report report;

  NumberIdContainer({Key key, @required this.report}) : super(key: key);

  String _createNumberId() => 'ID#${report.number}';


  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryText.withOpacity(0.2)),
          color: AppColors.primaryText.withOpacity(0.05)
      ),
      child: Text(
        _createNumberId(), style: kSmallTextStyle.copyWith(
          color: AppColors.primaryText),),
    );
  }
}
