import 'package:flutter/material.dart';

import '../../../../../../generated/i18n.dart';
import '../../../../../shared/app_colors.dart';
import 'package:smart_cities/src/shared/components/tab_bar_container.dart';
import '../widgets/recents_surveys.dart';
import '../widgets/all_surveys.dart';
import '../widgets/my_surveys.dart';


class SurveysPage extends StatefulWidget {
  static const id = "surverys_page";

  const SurveysPage({
    Key key,
  }) : super(key: key);

  @override
  _SurveysPageState createState() => _SurveysPageState();
}

class _SurveysPageState extends State<SurveysPage>
    with SingleTickerProviderStateMixin {
  List<Widget> _widgetOptions;
  TabController _tabController;


  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[RecentSurveys(), MySurveys(), AllSurveys()];

    _tabController = TabController(vsync: this, length: _widgetOptions.length);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.red,
        title: Text(S.of(context).surveys),
        centerTitle: true,
        bottom: TabBarContainer(
          color: AppColors.white,
          tabBar: TabBar(
          isScrollable: false,
          labelColor: AppColors.blueBtnRegister,
          unselectedLabelColor: AppColors.blueBtnRegister.withAlpha(100),
          indicatorColor: AppColors.blueBtnRegister,
          controller: _tabController,
          tabs: <Widget>[
            Tab(
                child: SizedBox(
                    width: 120,
                    child: Text(
                      S.of(context).createSurvey,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ))),
            Tab(
                child: SizedBox(
                    width: 120,
                    child: Text(S.of(context).mySurveys,
                        textAlign: TextAlign.center, maxLines: 1))),
            Tab(
                child: SizedBox(
                    width: 120,
                    child: Text(S.of(context).alls,
                        textAlign: TextAlign.center, maxLines: 1))),
          ],
        )
        ),
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: _widgetOptions,
      ),
    );
  }
}
