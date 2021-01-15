import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/constant.dart';

import '../../../../../generated/i18n.dart';
import '../../../../shared/app_icons.dart';

class MainBottomNavigationBar extends StatelessWidget {
  MainBottomNavigationBar({
    Key key,
    @required this.selectedIndex,
    @required this.onItemTapped,
  }) : super(key: key);

  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(MdiIcons.homeOutline),
          title: Text(
            S.of(context).menuHomeTile,
            textAlign: TextAlign.center,
            style: kSmallestTextStyle.copyWith(fontWeight: FontWeight.w600,),
          ),
        ),

        BottomNavigationBarItem(
          icon: Icon(MdiIcons.shieldOutline),
          title: Text(
              S.of(context).menuRoute,
              textAlign: TextAlign.center,
              style: kSmallestTextStyle.copyWith(fontWeight: FontWeight.w600,),
          ),
        ),


        BottomNavigationBarItem(
          icon: Icon(MdiIcons.magnify),
          title: Text(
            S.of(context).menuReport,
            textAlign: TextAlign.center,
            style: kSmallestTextStyle.copyWith(fontWeight: FontWeight.w600,),
          ),
          //label: S.of(context).menuReportsAndStatisticsTitle,
        ),

        BottomNavigationBarItem(
          icon: Icon(MdiIcons.currencyUsdCircleOutline),
          title: Text(
            S.of(context).menuPay,
            textAlign: TextAlign.center,
            style: kSmallestTextStyle.copyWith(fontWeight: FontWeight.w600,),
          ),
          //label: S.of(context).menuReportsAndStatisticsTitle,
        ),
        BottomNavigationBarItem(
          icon: Icon(MdiIcons.dotsGrid),
          title: Text(
            S.of(context).menuTittle,
            textAlign: TextAlign.center,
            style: kSmallestTextStyle.copyWith(fontWeight: FontWeight.w600,),
          ),
          //label: S.of(context).menuProfileTitle,
        ),
      ],
      currentIndex: selectedIndex,
      onTap: onItemTapped,
    );
  }
}
