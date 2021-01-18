import 'package:flutter/material.dart';
import 'package:smart_cities/src/features/find_route/presentation/pages/route_page.dart';
import 'package:smart_cities/src/features/home/presentation/page/home_page.dart';
import 'package:smart_cities/src/features/payments/presentation/pages/payments_page.dart';
import 'package:smart_cities/src/features/resports/presentation/tab_report/pages/resports_page.dart';

import '../../../auth/presentation/profile/pages/profile_page.dart';
import '../widgets/main_bottom_navigation_bar.dart';


class MainPage extends StatefulWidget {
  static const id = "main_page";

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
      HomePage(),
      RoutePage(),
      ReportsPage(),
      PaymentsPage(),
      Container()
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
}
