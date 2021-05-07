import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smart_cities/src/features/surveys/presentation/list/widgets/survey_list.dart';
import 'package:smart_cities/src/shared/components/custom_card.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';
import 'package:smart_cities/src/shared/app_colors.dart';

import '../../../../../shared/components/base_view.dart';
import '../providers/my_surveys_provider.dart';

class MySurveys extends StatefulWidget {

  MySurveys({Key key}) : super(key: key);

  @override
  _MySurveysState createState() => _MySurveysState();
}

class _MySurveysState extends State<MySurveys> {
  MySurveysProvider _provider;
  ScrollController _scrollController;


  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {

    return BaseView<MySurveysProvider>(
      onProviderReady: (provider) => provider.loadData(),
      builder: (context, provider, child) {
        _provider = provider;

        return Scaffold(
          body: ModalProgressHUD(
            inAsyncCall: provider.currentState is Loading,
            child: Container(
              color: AppColors.backgroundLight,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  _buildBody(),
                ],
              ),
            ),
          ),

        );


      }
    );




  }


  Widget _buildBody() {
    return SliverToBoxAdapter(
      child: Container(
          padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight + 24.0),
          child: SurveyList(
            scrollController: _scrollController,
            provider: _provider,
            allowActions: true,
          )
      ),
    );
  }


}