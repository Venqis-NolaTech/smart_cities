import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:share/share.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/surveys/domain/entities/survey.dart';
import 'package:smart_cities/src/features/surveys/presentation/list/widgets/survey_item.dart';
import 'package:smart_cities/src/features/surveys/presentation/list/widgets/survey_list.dart';
import 'package:smart_cities/src/shared/components/info_alert_dialog.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';
import 'package:smart_cities/src/shared/app_colors.dart';




import '../../../../../shared/app_images.dart';
import '../../../../../../app.dart';
import '../../../../../shared/components/base_view.dart';
import '../providers/my_surveys_provider.dart';
import '../../crud/pages/crud_survey_page.dart';


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
            gotoCreateSurvey: (value) => _gotoCreateSurvey(survey: value),
            onOptionMenuSelected: _onOptionMenuSelected,
          )
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

  void _onOptionMenuSelected(SurveyMenuOption option, Survey survey) async {


    switch (option) {
      case SurveyMenuOption.publish:
      //_publishSurvey(survey: survey, template: template);

        break;
      case SurveyMenuOption.edit:
        //_gotoCreateSurvey(survey: survey);

        break;
      case SurveyMenuOption.share:
        if(remoteParams!=null && remoteParams.isNotEmpty){
          final template = (remoteParams['publish_survey_template'] ?? "")
            .replaceAll("{name}", survey.name)
            .replaceAll("{link}", survey.link);
          Share.share(template);
        }
          
        break;

      case SurveyMenuOption.disable:
        /*_showConfirmationDialog(
          S.of(context).disableSurveyMessage,
          () => _disableSurvey(survey),
        );*/

        break;
      case SurveyMenuOption.delete:
        _showConfirmationDialog(
          S.of(context).deleteSurveyMessage,
          () => _deleteSurvey(survey),
        );

        break;
    }
  }


    void _showConfirmationDialog(String message, Function action) {
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

    void _deleteSurvey(Survey survey) async {
    await _provider?.delete(survey);

    _process(S.of(context).surveyWasDeletedMessage);
  }

  void _process(String successMessage) {
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
  }



}