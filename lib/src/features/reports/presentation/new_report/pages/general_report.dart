import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/core/error/failure.dart';
import 'package:smart_cities/src/features/main/presentation/pages/main_page.dart';
import 'package:smart_cities/src/features/reports/presentation/new_report/providers/create_report_provider.dart';
import 'package:smart_cities/src/features/reports/presentation/new_report/widget/bottom_navigation.dart';
import 'package:smart_cities/src/features/reports/presentation/new_report/widget/description_report.dart';
import 'package:smart_cities/src/features/reports/presentation/new_report/widget/location_report.dart';
import 'package:smart_cities/src/features/reports/presentation/new_report/widget/map_report.dart';
import 'package:smart_cities/src/features/reports/presentation/new_report/widget/report_files.dart';
import 'package:smart_cities/src/features/reports/presentation/new_report/widget/report_type.dart';
import 'package:smart_cities/src/features/reports/presentation/new_report/widget/summary_report.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/components/base_view.dart';
import 'package:smart_cities/src/shared/components/info_alert_dialog.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';
import 'package:smart_cities/src/features/auth/domain/entities/user.dart';


class NewReportParams{
  final double latitude;
  final double longitude;

  NewReportParams({this.latitude, this.longitude});
}



class NewReport extends StatefulWidget {
  static const id = "rew_report_page";
  final NewReportParams params;

  const NewReport({Key key, this.params}) : super(key: key);

  @override
  _NewReportState createState() => _NewReportState();
}

class _NewReportState extends State<NewReport> {
  int _stepIndex = 0;
  int _lengthIndex = 5;
  bool _actionsAreDisabled = false;


  @override
  Widget build(BuildContext context) {

    return BaseView<CreateReportProvider>(
      onProviderReady: (provider) {
        if(widget.params!=null)
          provider.location= Position(latitude: widget.params.latitude,  longitude: widget.params.longitude );
        provider.initData();
      },
      builder: (context, provider, child ){

        final currentState = provider.currentState;
        var failure;

        if (currentState is Error) {
          failure = currentState.failure;

          if(failure is LocationServiceFailure){
            //showInfoDialog('Enciende servicio de geolocalizacion para mejores resultados');

            Future.delayed(
              Duration(milliseconds: 250),
                  () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return InfoAlertDialog(
                      textAlign: TextAlign.center,
                      message: S.of(context).locationDisable,
                      onConfirm: () {},
                    );
                  },
                );
              },
            );
          }//else
            //return _buildErrorView(context, failure);
        }

        return WillPopScope(
          onWillPop: ()async{
            if (!_actionsAreDisabled) _onBackPressed();

            return false;
          },
          child: ModalProgressHUD(
            inAsyncCall: provider.currentState is Loading,
            child:   Scaffold(
                appBar: AppBar(
                  backgroundColor: AppColors.red,
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  title: Text(_getTitle()),
                  actions: [
                    FlatButton(
                        onPressed: _onBackPressed,
                        child: Text(
                          S.of(context).cancel,
                          style: kSmallTextStyle.copyWith(color: AppColors.white),
                        ))
                  ],
                ),
                body: Stack(
                  children: [
                    IndexedStack(
                      index: _stepIndex,
                      children: [
                        MapReport(provider: provider),
                        ReportType(provider: provider),
                        LocationReport(provider: provider),
                        DescriptionReport(provider: provider),
                        ReportFiles(provider: provider,  addBottomPadding: true),
                        SummaryReport(provider: provider)
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        BottomNavigationReport(
                          textOnBack: _stepIndex == 0
                              ? ' '
                              : S.of(context).back.toUpperCase(),
                          textOnNext: _stepIndex == _lengthIndex
                              ? S.of(context).finalize.toUpperCase()
                              : S.of(context).nextPage.toUpperCase(),
                          onBack: previewStep,
                          onNext: () => nextStep(provider),
                        )
                      ],
                    )
                  ],
                )
            ),
          ),
        );
      },


    );



  }

  nextStep(CreateReportProvider provider) async {
    FocusScope.of(context).requestFocus(new FocusNode());

    if (_stepIndex == 0) {
      provider.location= provider.provisionalLocation;
    }


    if (_stepIndex == 1 && provider.selectedCategory ==
        null) { // validar que se ha seleccionado una categoria
      showInfoDialog(S
          .of(context)
          .categoryValid);
      return;
    }


    if (_stepIndex == 2 && !provider.isValidLocation()) {
      showInfoDialog(S
          .of(context)
          .completeForm);
      return;
    }

    if (_stepIndex == 3 && !provider.isValidDescription()) {
      showInfoDialog(S
          .of(context)
          .completeForm);
      return;
    }

      if(_stepIndex<_lengthIndex) {
        _stepIndex++;
        setState(() {});
      }else
      if(_stepIndex==_lengthIndex) {
        await provider.submitData();
        _process(provider);
      }


  }

  previewStep() {
    setState(() {
      if(_stepIndex>0)
        _stepIndex--;
    });
  }


  void _onBackPressed() {
    _showCancelDialog();
    /*if (_stepIndex > 0) {
      previewStep();
    } else {
      _showCancelDialog();
    }*/
  }


  void _showCancelDialog() {
    showInfoDialog(
      S.of(context).newReportCancelMessage,
      confirmTitle: S.of(context).yes,
      cancelTitle: S.of(context).no,
      cancelAction: true,
      onConfirm: () => Navigator.of(context).popUntil(
        ModalRoute.withName(MainPage.id),
      ),
    );
  }

  void showInfoDialog(
    String message, {
    String confirmTitle,
    String cancelTitle,
    bool cancelAction = false,
    Function onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => InfoAlertDialog(
        message: message,
        confirmTitle: confirmTitle,
        cancelTitle: cancelTitle,
        cancelAction: cancelAction,
        buttomStyle: TextStyle(color: AppColors.primaryTextLight),
        onConfirm: () {
          if (onConfirm != null) onConfirm();
        },
      ),
    );
  }


  void _process(CreateReportProvider provider) {
    final currentState = provider.currentState;

    Widget image =  Image.asset(AppImagePaths.createReport, height: 120);
    String title = S.of(context).reportCreatedSuccessMessage;
    String message = S.of(context).infoCreateReport;
    bool sucesss = true;

    if (currentState is Error) {
      title = S.of(context).unexpectedErrorMessage;
      sucesss = false;
      image= AppImages.iconFailed;
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return InfoAlertDialog(
            image: image,
            title: title,
            message: sucesss ? message : '',
            onConfirm: sucesss
                ? () {
              Navigator.pop(context, true);
            }
                : null,
          );
        });
  }

  String _getTitle() {
    if(_stepIndex==4)
      return S.of(context).photos;
    if(_stepIndex==5)
      return S.of(context).summary;
    else
      return S.of(context).newReport;
  }

}
