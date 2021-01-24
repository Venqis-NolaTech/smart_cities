import 'package:flutter/material.dart';
import 'package:smart_cities/src/features/resports/domain/entities/report.dart';

import '../../../../../shared/app_colors.dart';
import '../../../../../shared/constant.dart';


class FilterItemView extends StatelessWidget {
  final FilterReportItem item;
  final Function(bool) onChanged;

  FilterItemView({Key key, this.item, this.onChanged}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          ListTile(
            title: Text(item.title,   style: kTitleStyle.copyWith(color: AppColors.blueBtnRegister),
              textAlign: TextAlign.start),
            trailing: Switch(
                value: item.value,
                activeColor: AppColors.blueLight,
                onChanged: (value)=> onChanged(value)),

          ),
          Divider(), //
        ],
      ),
    );
  }
}
