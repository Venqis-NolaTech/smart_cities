import 'package:flutter/material.dart';

import '../../features/reports/domain/entities/report.dart';
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
          border: Border.all(color: AppColors.primaryText.withOpacity(0.01)),
          color: AppColors.primaryText.withOpacity(0.03)),
      child: Text(
        _createNumberId(),
        style: kSmallestTextStyle.copyWith(color: AppColors.primaryText),
      ),
    );
  }
}
