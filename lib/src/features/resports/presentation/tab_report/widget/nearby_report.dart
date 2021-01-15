import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/core/error/failure.dart';
import 'package:smart_cities/src/features/auth/presentation/base/providers/phone_number_auth_provider.dart';
import 'package:smart_cities/src/features/auth/presentation/phone_number/pages/phone_number_page.dart';
import 'package:smart_cities/src/features/resports/domain/entities/report.dart';
import 'package:smart_cities/src/features/resports/presentation/list/provider/nearby_report_provider.dart';
import 'package:smart_cities/src/features/resports/presentation/list/widget/report_list_item.dart';
import 'package:smart_cities/src/features/resports/presentation/report_details/pages/report_details_page.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/components/base_view.dart';
import 'package:smart_cities/src/shared/components/info_alert_dialog.dart';
import 'package:smart_cities/src/shared/components/info_view.dart';
import 'package:smart_cities/src/shared/components/rounded_button.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';




class NearbyReport extends StatefulWidget {
  @override
  _NearbyReportState createState() => _NearbyReportState();
}

class _NearbyReportState extends State<NearbyReport> {
  ScrollController _scrollController;

  List<Report> reports=[];

  @override
  Widget build(BuildContext context) {
    return BaseView<NearbyReportProvider>(
      onProviderReady: (provider)=> provider.loadReports() ,
      builder: (context, provider, child){
        final currentState = provider.currentState;

        if (currentState is Error) {
          final failure = currentState.failure;

          return _buildErrorView(context, failure);
        }

        return ModalProgressHUD(
          inAsyncCall: currentState is Loading,
            child: _buildList(context, currentState, provider),
          );
      }


    );
  }

  Widget _buildList(BuildContext context, ViewState state, NearbyReportProvider provider) {

    if(!(state is Loaded))
      return Container();


    reports = (state as Loaded<List<Report>>).value;

    if(reports.isEmpty){
      return _buildEmpyteView(context);
    }


    return RefreshIndicator(
      onRefresh: provider.refreshData,
      child: ListView.builder(
        itemCount: reports.length,
        controller: _scrollController,
        itemBuilder: (context, index) => ReportListItem(
          report: reports[index],
          isFirst: index == 0,
          isLast: index == reports.length - 1,
          currentLocation: provider.location,
          topAndBottomPaddingEnabled: false,
          onTap: () => Navigator.pushNamed(
            context,
            ReportDetailsPage.id,
            arguments: reports[index],
          ),
          onFollow: ()=>_onFollow(index, reports[index], provider),
        ),
      ),
    );
  }

  Widget _buildEmpyteView(BuildContext context) {
    return InfoView(
      height: MediaQuery.of(context).size.height,
      image: AppImages.iconMessage,
      title: S.of(context).userNotFoundTittle,
      titleStyle: kMediumTitleStyle.copyWith(color: Colors.grey.shade500),
      //description:  S.of(context).userNotFoundMessage,
      descriptionStyle: kNormalStyle.copyWith(color: Colors.grey.shade500),
    );
  }

  Widget _buildErrorView(BuildContext context, Failure failure) {
    return InfoView(
      height: MediaQuery.of(context).size.height,
      image: failure is UserNotFoundFailure ? AppImages.iconMessage : Container(height: 48),
      title: failure is UserNotFoundFailure ? S.of(context).userNotFoundTittle: S.of(context).error,
      titleStyle: kMediumTitleStyle.copyWith(color: Colors.grey.shade500),
      description: failure is UserNotFoundFailure ? S.of(context).userNotFoundMessage : S.of(context).unexpectedErrorMessage,
      descriptionStyle: kNormalStyle.copyWith(color: Colors.grey.shade500),
      child: failure is UserNotFoundFailure ? btnIniciar(context) : Container(),
    );
  }

  Widget btnIniciar(BuildContext context){
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: RoundedButton(
            color: AppColors.blueBtnRegister,
            title: S.of(context).login.toUpperCase(),
            style: kTitleStyle.copyWith(fontFamily: 'Roboto', fontWeight: FontWeight.bold,  color: AppColors.white),
            onPressed: () => //Navigator.pushNamedAndRemoveUntil(context, PhoneNumberPage.id, ModalRoute.withName(PhoneNumberPage.id))
            Navigator.pushReplacementNamed(
              context,
              PhoneNumberPage.id,
              arguments: AuthMethod.login,
            )
        )
    );
  }

  void _onFollow(int index, Report report, NearbyReportProvider provider) async {
    await provider.followReport(report);
    _process(index, provider);
  }

  void _process(int index, NearbyReportProvider provider) {

    final currentState = provider.currentState;

    if (currentState is Loaded<Report>) {
      final reportUpdated = currentState.value;
      reports[index]= reportUpdated;
      setState(() {});
      return;
    }

    if (currentState is Error) {
      showDialog(
        context: context,
        builder: (context) {
          return InfoAlertDialog(
            message: S.of(context).unexpectedErrorMessage,
          );
        },
      );
    }

  }
}
