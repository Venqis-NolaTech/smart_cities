import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../../../../../../generated/i18n.dart';
import '../../../../../shared/app_colors.dart';
import '../../../../../shared/app_images.dart';
import '../../../../../shared/components/base_view.dart';
import '../../../../../shared/components/custom_card.dart';
import '../../../../../shared/components/info_alert_dialog.dart';
import '../../../../../shared/components/search_bar/custom_sliver_app_bar.dart';
import '../../../../../shared/constant.dart';
import '../../../../../shared/provider/view_state.dart';
import '../../../domain/entities/survey.dart';
import '../providers/crud_survey_provider.dart';
import '../widgets/crud_survey_form.dart';

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
            onConfirm: () =>
                sucesss ? Navigator.pop(context, true) : null,
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
            appBar: AppBar(
              backgroundColor: AppColors.red,
              title: Text(S.of(context).createSurvey),
              centerTitle: true,
              actions: [
                FlatButton(
                    onPressed: () => _save(provider),
                    child: Text(
                      S.of(context).save.toUpperCase(),
                      style: kSmallTextStyle.copyWith(color: AppColors.white),
                    ))
              ],
            ),
            body: SafeArea(
              child: ModalProgressHUD(
                inAsyncCall: provider.currentState is Loading,
                child: CustomScrollView(
                  slivers: <Widget>[
                    _buildBody(context, provider),
                  ],
                ),
              ),
            ),
          
            floatingActionButton: FloatingActionButton(
              child: Icon(
                MdiIcons.plus,
              ),
              onPressed: () => provider.addStep(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddButton(BuildContext context, CrudSurveyProvider provider) {
    return FlatButton(
      onPressed: () => _save(provider),
      child: Text( S.of(context).save.toUpperCase(), style: kSmallTextStyle.copyWith(color: AppColors.white),),
    );

    /*return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Center(
        child: RoundedButton(
          color: AppColors.red,
          height: 30,
          title: S.of(context).save.toUpperCase(),
          style: kSmallestTextStyle.copyWith(color: Colors.white),
          borderRadius: 100,
          onPressed: () => _save(provider),
        ),
      ),
    );*/


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
          bottom: kBottomNavigationBarHeight + 24.0,
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
}
