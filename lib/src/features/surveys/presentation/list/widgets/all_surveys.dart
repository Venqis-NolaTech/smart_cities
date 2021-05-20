import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smart_cities/src/features/surveys/presentation/list/providers/surveys_provider.dart';
import 'package:smart_cities/src/features/surveys/presentation/list/widgets/survey_list.dart';
import 'package:smart_cities/src/shared/components/base_view.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';

import '../../list/widgets/survey_list.dart';
import '../../../domain/entities/survey.dart';
import '../../crud/pages/crud_survey_page.dart';

class AllSurveys extends StatefulWidget {
  AllSurveys({Key key}) : super(key: key);

  @override
  _AllSurveysState createState() => _AllSurveysState();
}

class _AllSurveysState extends State<AllSurveys> {
  SurveysProvider _provider;

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
    return BaseView<SurveysProvider>(
        onProviderReady: (provider) => provider.loadData(),
        builder: (context, provider, child) {
          _provider = provider;

          return Scaffold(
            body: ModalProgressHUD(
              inAsyncCall: provider.currentState is Loading,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  _buildBody(),
                ],
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
          allowActions: false,
          gotoCreateSurvey: (value)=> _gotoCreateSurvey(survey: value),
        ),
      ),
    );
  }

  
  void _gotoCreateSurvey({Survey survey}) async {
    final success = await CrudSurveyPage.pushNavigate(
          context,
          args: CrudSurveyArgs(
            survey: survey,
          ),
        ) ??
        false;

    if (success) _provider?.refreshData();
  }


}