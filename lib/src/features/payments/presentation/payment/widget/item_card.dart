import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';


class ItemCreditCard extends StatelessWidget {
  final Color background;
  final Function onTap;
  final bool isSelected;
  const ItemCreditCard({Key key, this.background, this.onTap, this.isSelected}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: isSelected ? AppColors.blueButton: Colors.transparent),
        borderRadius: BorderRadius.all(Radius.circular(0.2)),
      ),
      child: Container(
        color: background,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 16, left: 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Masterd Card', style: kMediumTitleStyle.copyWith(color: AppColors.primaryTextLight)),
                      Spaces.verticalSmall(),
                      Text('02/20', style: kNormalStyle),
                    ],
                  ),
                ),

                Text('****12342', style: kBigTitleStyle.copyWith(color: AppColors.primaryTextLight),),
                Spaces.horizontalSmall(),
                Icon(MdiIcons.trashCanOutline, color: AppColors.greyButtom.withOpacity(0.5))

              ],
            ),
          ),
        ),
      ),
    );
  }
}
