import 'package:flutter/material.dart';
import 'package:smart_cities/src/features/route/presentation/see_route/widget/real_time.dart';
import 'package:smart_cities/src/features/route/presentation/see_route/widget/see_route.dart';
import 'package:smart_cities/src/features/select_sector/presentation/page/select_sector_page.dart';



import '../../../../../../generated/i18n.dart';
import '../../../../../shared/app_colors.dart';
import '../../../../../shared/components/tab_bar_container.dart';



class RoutePage extends StatefulWidget {
  @override
  _RoutePageState createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage>  with SingleTickerProviderStateMixin {
  List<Widget> _widgetOptions;
  TabController _tabController;
  var widget1= RealTime();
  var widget2= SeeRoute();



  @override
  void initState() { 
    super.initState();
    _widgetOptions = <Widget>[widget1, widget2];

    _tabController = TabController(vsync: this, length: _widgetOptions.length);
  }

  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
      appBar: _buildAppBar(context),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: _widgetOptions,
      ),
    );

  }

    Widget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.red,
      centerTitle: true,
      title: Text(S.of(context).route),
      actions: [

        IconButton(
            onPressed: () async {
              var result= await Navigator.pushNamed(context, SelectSectorPage.id);
              widget1.changeSector2(result);
            },
            icon: Icon(
              Icons.tune,
              color: AppColors.white,
            )),

      ],
      bottom: TabBarContainer(
        color: AppColors.white,
        tabBar: TabBar(
          //isScrollable: true,
          labelColor: AppColors.blueBtnRegister,
          unselectedLabelColor: AppColors.blueBtnRegister.withAlpha(100),
          indicatorColor: AppColors.blueBtnRegister,
          controller: _tabController,
          tabs: <Widget>[
            Tab(child: SizedBox(width: 90, child: Text(S.of(context).realTime, textAlign: TextAlign.center, maxLines: 1,))),
            Tab(child: SizedBox(width: 90, child: Text(S.of(context).routeSee, textAlign: TextAlign.center, maxLines: 1 ))),
          ],
        ),
      ),
    );
  }
}
