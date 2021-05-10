import 'package:flutter/material.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/features/surveys/presentation/list/widgets/welcome.dart';

import '../../../../../shared/components/base_view.dart';
import '../../../../../../generated/i18n.dart';
import '../providers/surveys_provider.dart';
import '../widgets/survey_list.dart';

class RecentSurveysUser extends StatefulWidget {
  static const id = "recents_surverys_page";
  const RecentSurveysUser({Key key}) : super(key: key);

  @override
  _RecentSurveysState createState() => _RecentSurveysState();
}

class _RecentSurveysState extends State<RecentSurveysUser> {
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

          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.red,
              title: Text(S.of(context).surveys),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Welcome()],
                  ),
                  Container(
                      color: AppColors.blueFacebook.withOpacity(0.2),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            child: Text(S.of(context).recentsSurveys,
                                textAlign: TextAlign.start,
                                style: kTitleStyle.copyWith(
                                    color: AppColors.blueBtnRegister,
                                    fontWeight: FontWeight.bold)),
                          ),
                          _buildBody(),
                        ],
                      ))
                ],
              ),
            ),
          );
        });
  }

  Widget _buildBody() {
    return SurveyList(
      scrollController: _scrollController,
      provider: _provider,
      allowActions: false,
    );
  }
}
