import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smart_cities/src/shared/components/rounded_button.dart';
import 'package:smart_cities/src/shared/spaces.dart';

import '../../../../../../generated/i18n.dart';
import '../../../../../shared/app_colors.dart';
import '../../../../../shared/app_images.dart';
import '../../../../../shared/components/base_view.dart';
import '../../../../../shared/components/custom_card.dart';
import '../../../../../shared/components/info_alert_dialog.dart';
import '../../../../../shared/constant.dart';
import '../../../../../shared/provider/view_state.dart';
import '../../../domain/entities/survey.dart';
import '../providers/crud_survey_provider.dart';
import '../widgets/crud_survey_form.dart';
import '../widgets/crud_survey_settings.dart';

class CrudSurveyArgs {
  final Survey survey;

  CrudSurveyArgs({
    this.survey,
  });
}

class CrudSurveyPage extends StatefulWidget {
  static const id = "crud_survey_page";

  CrudSurveyPage({
    Key key,
    @required this.args,
  }) : super(key: key);

  final CrudSurveyArgs args;

  static Future<T> pushNavigate<T extends Object>(
    BuildContext context, {
    CrudSurveyArgs args,
  }) =>
      Navigator.pushNamed(context, id, arguments: args);

  @override
  _CrudSurveyPageState createState() => _CrudSurveyPageState();
}

class _CrudSurveyPageState extends State<CrudSurveyPage> {
  final _crudSurveyKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();

  CrudSurveyArgs _args;

  @override
  void initState() {
    _args = widget.args;

    super.initState();
  }

  void _save(CrudSurveyProvider provider) async {
    final formCurrentState = _formKey.currentState;

    if (formCurrentState.validate()) {
      formCurrentState.save();

      await provider.save();

      _process(provider);
    }
  }

  void _process(CrudSurveyProvider provider) {
    final currentState = provider.currentState;

    Image image = AppImages.success;
    String message = S.of(context).saveSurveySuccessMenssage;
    bool sucesss = true;

    if (currentState is Error) {
      image = AppImages.iconFailed;
      message = S.of(context).saveSurveyFailureMessage;
      sucesss = false;
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return InfoAlertDialog(
            image: image,
            message: message,
            onConfirm: () => sucesss ? Navigator.pop(context, true) : null,
          );
        });
  }

  Future<bool> _handleClose(BuildContext context) async {
    return (await showDialog(
          context: context,
          builder: (context) {
            return InfoAlertDialog(
              title: S.of(context).exitSurveryTitleMessage,
              message: S.of(context).exitSurveryMessage,
              disableExecuteActions: true,
              cancelAction: true,
              confirmTitle: S.of(context).yes,
              cancelTitle: S.of(context).no,
              onCancel: () {
                FocusScope.of(context).requestFocus(new FocusNode());

                Navigator.pop(context, false);
              },
              onConfirm: () => Navigator.pop(context, true),
            );
          },
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<CrudSurveyProvider>(
      onProviderReady: (provider) => provider.initSurvey(
        survey: _args.survey,
      ),
      builder: (context, provider, child) {
        return WillPopScope(
          onWillPop: () async => await _handleClose(context),
          child: Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              backgroundColor: AppColors.red,
              title: Text(S.of(context).createSurvey),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: _showSettings,
                  icon: Icon(
                    Icons.tune,
                    color: AppColors.white,
                ))
              ],
            ),
            body: Stack(
              children: [
                SafeArea(
                  child: ModalProgressHUD(
                    inAsyncCall: provider.currentState is Loading,
                    child: CustomScrollView(
                      slivers: <Widget>[
                        _buildBody(context, provider),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: double.infinity,
                        color: Colors.white,
                        child: FlatButton.icon(
                            onPressed: _showSettings,
                            icon: Icon(MdiIcons.tune, color: AppColors.blueButton),
                            label: Text('Ajustes Encuesta', style: kSmallTextStyle.copyWith(color: AppColors.blueButton),))
                            ),

                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 12),
                      child: _buildBottom(provider),
                    )
                  ],
                )
              ],
            ),

            /*floatingActionButton: FloatingActionButton(
              child: Icon(
                MdiIcons.plus,
              ),
              onPressed: () => provider.addStep(),
            ),*/
          ),
        );
      },
    );
  }

  Widget _buildBottom(CrudSurveyProvider provider) {
    return RoundedButton(
      title: S.of(context).saveSurvey.toUpperCase(),
      style: kTitleStyle.copyWith(
          fontWeight: FontWeight.bold, color: AppColors.white),
      color: AppColors.blueBtnRegister,
      onPressed: () => _save(provider),
    );
  }

  Widget _buildBody(BuildContext context, CrudSurveyProvider provider) {
    return SliverToBoxAdapter(
      child: CustomCard(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - kToolbarHeight,
        ),
        shadowColorAlpha: 8,
        blurRadius: 24,
        padding: const EdgeInsets.only(
          top: 16.0,
          bottom: kBottomNavigationBarHeight + 60.0,
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
        child: CrudSurveyForm(
          key: _crudSurveyKey,
          provider: provider,
          formKey: _formKey,
        ),
      ),
    );
  }

  void _showSettings() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CrudSurveySettings();
        });
  }
}
