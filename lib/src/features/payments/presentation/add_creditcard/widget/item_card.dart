import 'package:flutter/material.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';


class ItemCreditCard extends StatelessWidget {
  final Color background;
  final Function onTap;

  const ItemCreditCard({Key key, this.background, this.onTap}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
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
                    Text('Masterd Card', style: kMediumTitleStyle.copyWith(color: AppColors.black)),
                    Spaces.verticalSmall(),
                    Text('02/20', style: kNormalStyle),
                  ],
                ),
              ),

              Text('****12342', style: kBigTitleStyle.copyWith(color: AppColors.black),),

            ],
          ),
        ),
      ),
    );
  }
}
