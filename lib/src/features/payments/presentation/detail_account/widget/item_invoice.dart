import 'package:flutter/material.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';

class ItemInvoice extends StatelessWidget {
  final Color background;
  final Function onTap;

  const ItemInvoice({Key key, this.background, this.onTap}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, right: 16, left: 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ID 1213144', style: kTitleStyle.copyWith(color: AppColors.black)),
                    Spaces.verticalSmallest(),
                    Text('Noviembre 28, 2018 12:20 PM', style: kNormalStyle.copyWith(color:AppColors.primaryTextLight )),
                  ],
                ),
              ),

              Text('\$200.00', style: kMediumTitleStyle.copyWith(color: AppColors.primaryTextLight),),

            ],
          ),
        ),
      ),
    );
  }
}
