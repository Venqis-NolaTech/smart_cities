import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:share/share.dart';
import 'package:smart_cities/src/features/surveys/presentation/list/widgets/welcome.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';
import '../../../../../../app.dart';
import '../../../../../../generated/i18n.dart';
import '../../../../../shared/app_images.dart';
import '../../../../../shared/components/base_view.dart';
import '../../../../../shared/components/info_alert_dialog.dart';
import '../../../../../shared/provider/view_state.dart';
import '../../../domain/entities/survey.dart';
import '../../crud/pages/crud_survey_page.dart';
import '../../list/widgets/survey_list.dart';
import '../providers/surveys_provider.dart';
import '../widgets/survey_item.dart';

class SurveysPage extends StatefulWidget {
  static const id = "surverys_page";

  const SurveysPage({
    Key key,
  }) : super(key: key);


  @override
  _SurveysPageState createState() => _SurveysPageState();
}

class _SurveysPageState extends State<SurveysPage> {
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

  void _onOptionMenuSelected(SurveyMenuOption option, Survey survey) async {
    final template = (remoteParams['publish_survey_template'] ?? "")
        .replaceAll("<name>", survey.name)
        .replaceAll("<link>", survey.link);

    switch (option) {
      case SurveyMenuOption.publish:
        _publishSurvey(survey: survey, template: template);

        break;
      case SurveyMenuOption.edit:
        _gotoCreateSurvey(survey: survey);

        break;
      case SurveyMenuOption.share:
        Share.share(template);

        break;
      case SurveyMenuOption.disable:
        _showConfirmationDialog(
          S.of(context).disableSurveyMessage,
          () => _disableSurvey(survey),
        );

        break;
      case SurveyMenuOption.delete:
        _showConfirmationDialog(
          S.of(context).deleteSurveyMessage,
          () => _deleteSurvey(survey),
        );

        break;
    }
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
          body: Column(
            //controller: _scrollController,
            children: <Widget>[

              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Welcome(),
                  _buildActionCreateSurveys()
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection : Axis.horizontal,
                  child: _buildBody()
                )
              )
                
            ],
          ),
          /*


          floatingActionButton: FloatingActionButton(
            child: Icon(
              MdiIcons.plus,
            ),
            onPressed: () => _gotoCreateSurvey(),
          ),*/
        );
      },
    );
  }

  Widget _buildBody() {
    return SurveyList(
      scrollController: _scrollController,
      onOptionMenuSelected: _onOptionMenuSelected,
    );



    /*return SliverToBoxAdapter(
      child: CustomCard(
        constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height / 1.22),
        shadowColorAlpha: 8,
        blurRadius: 24,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
        padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight + 24.0),
        child: SurveyList(
          scrollController: _scrollController,
          onOptionMenuSelected: _onOptionMenuSelected,
        ),
      ),
    );*/
  }

  Widget _buildActionCreateSurveys() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(S.of(context).titleCreateSurvey, style: kBigTitleStyle.copyWith(
            color: AppColors.blueBtnRegister,
            //fontWeight: FontWeight.bold,
          )),

          Spaces.verticalMedium(),
          RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(80.0),
                side: BorderSide(
                  color: Colors.transparent ,
                  style: BorderStyle.solid,
                  width: 1.0,
                ),
              ),


              color: AppColors.blueBtnRegister,
              elevation: 0,
              child: Text(S.of(context).createSurvey.toUpperCase(), style: kTitleStyle.copyWith( fontWeight: FontWeight.bold, color: AppColors.white)),
              onPressed: _gotoCreateSurvey
          )

        ],
      ),
    );
  }



}
