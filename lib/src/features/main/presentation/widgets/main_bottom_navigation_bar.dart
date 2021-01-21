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

  Color _getBackgroundColor(int index) =>
      selectedIndex == index ? AppColors.blueBtnRegister : Colors.white;

  Color _getItemColor(int index) =>
      selectedIndex == index ? Colors.white : AppColors.blueBtnRegister;

  final _icons = [
    MdiIcons.homeOutline,
    MdiIcons.shieldOutline,
    MdiIcons.magnify,
    MdiIcons.currencyUsdCircleOutline,
    MdiIcons.dotsGrid
  ];




  @override
  Widget build(BuildContext context) {
    final items = {
      _icons[0]: S.of(context).menuHomeTile,
      _icons[1]: S.of(context).menuRoute,
      _icons[2]: S.of(context).menuReport,
      _icons[3]: S.of(context).menuPay,
      _icons[4]: S.of(context).menuTittle,
    };




    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 0,
      unselectedFontSize: 0,
      showUnselectedLabels: false,
      showSelectedLabels: false,
      items: items.entries
          .map(
            (e) => BottomNavigationBarItem(
          label: e.value,
          icon: _buildIcon(
            context,
            e.key,
            e.value,
            _icons.indexOf(e.key),
          ),
        ),
      ).toList(),
      currentIndex: selectedIndex,
      onTap: onItemTapped,
    );
  }

  Widget _buildIcon(
      BuildContext context, IconData iconData, String text, int index) {
    final itemColor = _getItemColor(index);
    final data = MediaQuery.of(context);

    return Container(
      width: double.infinity,
      height: kBottomNavigationBarHeight * 1,
      child: Material(
        color: _getBackgroundColor(index),
        child: InkWell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                color: itemColor,
              ),
              Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: data.textScaleFactor > 1
                    ? kSmallestTextStyle.copyWith(
                  color: itemColor,
                  fontWeight: FontWeight.w600,
                )
                    : kSmallTextStyle.copyWith(
                  color: itemColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          onTap: () => onItemTapped(index),
        ),
      ),
    );
  }
}
