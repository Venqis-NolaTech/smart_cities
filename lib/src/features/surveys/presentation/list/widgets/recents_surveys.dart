import 'package:flutter/material.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';

import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/features/surveys/presentation/list/widgets/welcome.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';

import '../../../../../shared/components/base_view.dart';
import '../../../../../../generated/i18n.dart';
import '../providers/surveys_provider.dart';
import '../../../domain/entities/survey.dart';
import '../../crud/pages/crud_survey_page.dart';
import '../../list/widgets/survey_list.dart';

class RecentSurveys extends StatefulWidget {
  const RecentSurveys({Key key}) : super(key: key);

  @override
  _RecentSurveysState createState() => _RecentSurveysState();
}

class _RecentSurveysState extends State<RecentSurveys> {
  ScrollController _scrollController;
  SurveysProvider _provider;

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

          return SingleChildScrollView(
            child: Column(
              //controller: _scrollController,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Welcome(), _buildActionCreateSurveys()],
                ),
                Container(
                    color: AppColors.blueFacebook.withOpacity(0.2),
                    child: _buildBody())
              ],
            ),
          );

          /*return Scaffold(
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

        );*/
        });
  }

  
  Widget _buildBody() {
    return SurveyList(
          scrollController: _scrollController,
          provider: _provider,
          allowActions: false,
        );
  }


  Widget _buildActionCreateSurveys() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(S.of(context).titleCreateSurvey,
              style: kBigTitleStyle.copyWith(
                color: AppColors.blueBtnRegister,
                //fontWeight: FontWeight.bold,
              )),
          Spaces.verticalMedium(),
          RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(80.0),
                side: BorderSide(
                  color: Colors.transparent,
                  style: BorderStyle.solid,
                  width: 1.0,
                ),
              ),
              color: AppColors.blueBtnRegister,
              elevation: 0,
              child: Text(S.of(context).createSurvey.toUpperCase(),
                  style: kTitleStyle.copyWith(
                      fontWeight: FontWeight.bold, color: AppColors.white)),
              onPressed: _gotoCreateSurvey)
        ],
      ),
    );
  }

  /*Widget _buildBody() {
    return SliverToBoxAdapter(
      child: Container(
        color: AppColors.blueFacebook.withOpacity(0.2),
        padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight + 24.0),
        child: SurveyList(
          scrollController: _scrollController,
          provider: _provider,
          allowActions: false,
        ),
      ),
    );
  }*/

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
