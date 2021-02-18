import 'package:flutter/material.dart';
import 'package:smart_cities/src/features/places/domain/entities/place.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/app_colors.dart';

import '../../../../../shared/app_colors.dart';


class ScheduleItem extends StatelessWidget {
  final Schedule item;
  final bool selected;
  const ScheduleItem({Key key, this.item, this.selected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        border: selected ?  Border.all(
         color: AppColors.blueButton
        ) : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: Text(item.dayEs, style: kNormalStyle.copyWith(color: AppColors.blueBtnRegister),),
            ),
            Text('${item.from} - ${item.to} ${int.parse(item.to.split(':').first.toString()) >= 12 ? 'pm' : 'am'}', style: kNormalStyle.copyWith(color: AppColors.blueBtnRegister))
          ],
        ),
      ),
    );
  }
}
