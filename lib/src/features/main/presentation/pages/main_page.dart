import 'package:flutter/material.dart';
import 'package:smart_cities/src/features/auth/presentation/profile/pages/profile_page.dart';
import 'package:smart_cities/src/features/home/presentation/page/home_page.dart';
import 'package:smart_cities/src/features/main/presentation/widgets/menu_page.dart';
import 'package:smart_cities/src/features/payments/presentation/linked_accounts/page/linked_accounts_page.dart';
import 'package:smart_cities/src/features/reports/presentation/tab_report/pages/resports_page.dart';
import 'package:smart_cities/src/features/route/presentation/see_route/pages/route_page.dart';

import '../widgets/main_bottom_navigation_bar.dart';


class MainPage extends StatefulWidget {
  static const id = "main_page";


  static pushNavigate(BuildContext context, {replace = false}) {
    replace
        ? Navigator.pushReplacementNamed(context, id)
        : Navigator.pushNamed(context, id);
  }

  MainPage({
    Key key,
  }) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions;

  @override
  void initState() {
    _widgetOptions = <Widget>[
      HomePage(
        toProfile: ()=> Navigator.pushNamed(context, ProfilePage.id),
        toRoute: ()=> moveTo(1),
        moveToPayment: ()=> moveTo(3),
      ),
      RoutePage(),
      ReportsPage(onBackPress: onBackPressReport),
      LinkedAccountsPage(
        onBackPress: onBackPressReport,
      ),
      MenuPage(
        onFunctionPickup: onFunctionPickup,
        onFunctionPayment: onFunctionPayment,
      )
    ];

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void moveTo(int index) {
    _onItemTapped(index);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: MainBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  void onBackPressReport() {
    print('on back press icon');
    setState(() {
      _selectedIndex=0;
    });
  }


  void onFunctionPickup() {
    moveTo(1);
  }

  void onFunctionPayment() {
    moveTo(3);
  }
  
}
