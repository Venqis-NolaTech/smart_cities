import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/resports/presentation/list/provider/general_report_provider.dart';
import 'package:smart_cities/src/features/resports/presentation/list/provider/my_report_provider.dart';
import 'package:smart_cities/src/features/resports/presentation/list/widget/report_list_view.dart';
import 'package:smart_cities/src/features/resports/presentation/new_report/pages/general_report.dart';
import 'package:smart_cities/src/features/resports/presentation/tab_report/widget/all_report.dart';
import 'package:smart_cities/src/features/resports/presentation/tab_report/widget/map_list_report.dart';
import 'package:smart_cities/src/features/resports/presentation/tab_report/widget/my_report.dart';
import 'package:smart_cities/src/features/resports/presentation/tab_report/widget/nearby_report.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/components/tab_bar_container.dart';
import 'package:smart_cities/src/shared/constant.dart';



class ReportsPage extends StatefulWidget {
  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage>  with SingleTickerProviderStateMixin  {


  final List<Widget> _widgetOptions = <Widget>[
    AllReport(),
    NearbyReport(),
    MapListReport(),
    MyReport(),
  ];

  TabController _tabController;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(vsync: this, length: _widgetOptions.length);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: TabBarView(
        controller: _tabController,
        children: _widgetOptions,
        //physics: NeverScrollableScrollPhysics(),
      ),
    );;
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.red,
      centerTitle: true,
      title: Text(S.of(context).menuReport),
      actions: [
        IconButton(
            onPressed: () => Navigator.pushNamed(context, NewReport.id),
            icon: Icon(Icons.add, color: AppColors.white,)
        ),
        /*FlatButton(
            onPressed: () => Navigator.pushNamed(context, NewReport.id),
            child: Icon(Icons.settings_overscan, color: AppColors.white,)
        ),*/
      ],
      bottom: TabBarContainer(
        color: AppColors.white,
        tabBar: TabBar(
          isScrollable: false,
          labelColor: AppColors.blueBtnRegister,
          unselectedLabelColor: AppColors.blueBtnRegister.withAlpha(100),
          indicatorColor: AppColors.blueBtnRegister,
          controller: _tabController,
          tabs: <Widget>[
            Tab(child: Text(S.of(context).all)),
            Tab(child: Text(S.of(context).cercaMi),),
            Tab(child: Text(S.of(context).map)),
            Tab(child: Text(S.of(context).myReports)),
          ],
        ),
      ),
    );
  }
}
