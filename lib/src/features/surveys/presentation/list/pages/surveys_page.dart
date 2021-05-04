import 'package:flutter/material.dart';

import '../../../../../../generated/i18n.dart';
import '../../../../../shared/app_colors.dart';
//import '../../../../../shared/components/info_alert_dialog.dart';
//import '../../../../../shared/provider/view_state.dart';

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

  /*void _showConfirmationDialog(String message, Function action) {
    showDialog(
      context: context,
      builder: (context) {
        return InfoAlertDialog(
          message: message,
          cancelAction: true,
          cancelTitle: S.of(context).no,
          confirmTitle: S.of(context).yes,
          onConfirm: action,
        );
      },
    );
  }

  void _publishSurvey({Survey survey, String template}) async {
    /*
    TODO
    final success = await CrudPostPage.pushNa(
              CrudPostPage.id,
              arguments: CrudPostArgs(
                channel: widget.channel,
                templateTitle: survey.name,
                templatePost: template,
                isSurvey: true,
              ),
            ) ??
        false;

    if (success) _provider?.publish(survey);*/
  }

  void _disableSurvey(Survey survey) async {
    await _provider?.disable(survey);

    _process(S.of(context).surveyWasDisabledMessage);
  }

  void _deleteSurvey(Survey survey) async {
    await _provider?.delete(survey);

    _process(S.of(context).surveyWasDeletedMessage);
  }*/

  /*void _process(String successMessage) {
    final currentState = _provider.currentState;

    Image image = AppImages.success;
    String message = successMessage;
    bool sucesss = true;

    if (currentState is Error) {
      image = AppImages.iconFailed;
      message = S.of(context).unexpectedErrorMessage;
      sucesss = false;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return InfoAlertDialog(
          image: image,
          message: message,
          disableExecuteActions: true,
          onConfirm: () => sucesss ? Navigator.pop(context) : null,
        );
      },
    );
  }*/

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
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: _widgetOptions,
      ),
    );
  }
}
