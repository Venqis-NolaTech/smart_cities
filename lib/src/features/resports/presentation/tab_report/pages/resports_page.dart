import 'package:flutter/material.dart';
import 'package:smart_cities/src/features/resports/presentation/filter_report/page/filter_page.dart';

import '../../../../../../generated/i18n.dart';
import '../../../../../shared/app_colors.dart';
import '../../../../../shared/components/tab_bar_container.dart';
import '../../new_report/pages/general_report.dart';
import '../widget/all_report.dart';
import '../widget/map_list_report.dart';
import '../widget/my_report.dart';
import '../widget/nearby_report.dart';

class ReportsPage extends StatefulWidget {
  final Function onBackPress;

  const ReportsPage({Key key, this.onBackPress}) : super(key: key);

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage>
    with SingleTickerProviderStateMixin {
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
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: _widgetOptions,
      ),
    );
    ;
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.red,
      centerTitle: true,
      title: Text(S.of(context).menuReport),
      leading: GestureDetector(onTap: widget.onBackPress, child: Icon(Icons.arrow_back)),
      actions: [

        IconButton(
            onPressed: () async {
              await Navigator.pushNamed(context, FilterReportPage.id);
              //TODO ACTUALIZAR NUEVAMENTE LISTADO CON LOS FILTROS MODIFICADOS
            },
            icon: Icon(
              Icons.tune,
              color: AppColors.white,
            )),

        IconButton(
            onPressed: () => Navigator.pushNamed(context, NewReport.id),
            icon: Icon(
              Icons.add,
              color: AppColors.white,
            )),

      ],
      bottom: TabBarContainer(
        color: AppColors.white,
        tabBar: TabBar(
          isScrollable: true,
          labelColor: AppColors.blueBtnRegister,
          unselectedLabelColor: AppColors.blueBtnRegister.withAlpha(100),
          indicatorColor: AppColors.blueBtnRegister,
          controller: _tabController,
          tabs: <Widget>[
            Tab(child: SizedBox(width: 80, child: Text(S.of(context).all, textAlign: TextAlign.center,))),
            Tab(child: SizedBox(width: 80, child: Text(S.of(context).cercaMi, textAlign: TextAlign.center ))),
            Tab(child: SizedBox(width: 80, child: Text(S.of(context).map, textAlign: TextAlign.center))),
            Tab(child: SizedBox(width: 80, child: Text(S.of(context).myReports, textAlign: TextAlign.center))),
          ],
        ),
      ),
    );
  }
}
