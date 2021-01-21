import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/core/error/failure.dart';
import 'package:smart_cities/src/features/auth/domain/entities/user.dart';
import 'package:smart_cities/src/features/resports/presentation/list/provider/general_report_provider.dart';
import 'package:smart_cities/src/features/resports/presentation/list/provider/report_location_provider.dart';
import 'package:smart_cities/src/features/resports/presentation/list/widget/report_list_view.dart';
import 'package:smart_cities/src/features/resports/presentation/tab_report/widget/btn_iniciar.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/components/base_view.dart';
import 'package:smart_cities/src/shared/components/info_view.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';




class AllReport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<ReportLocationProvider>(
      onProviderReady: (provider)=> provider.initData() ,
      builder: (context, provider, child){
        final currentState = provider.currentState;

        if (currentState is Error) {
          final failure = currentState.failure;

          return _buildErrorView(context, failure);
        }

        return ModalProgressHUD(
          inAsyncCall: currentState is Loading,
          child: _buildList(provider.currentLocation),
        );
      }


    );
  }

  Widget _buildList(Position data) {
    return ReportListView<GeneralReportProvider>(
      currentLocation: data,
      topAndBottomPaddingEnabled: false
    );
  }


  Widget _buildErrorView(BuildContext context, Failure failure) {
    return InfoView(
      height: MediaQuery.of(context).size.height*0.7,
      image: AppImages.iconMessage,
      title: S.of(context).empyteReport,
      titleStyle: kMediumTitleStyle.copyWith(color: Colors.grey.shade500),
      description: failure is UserNotFoundFailure ? S.of(context).userNotFoundMessage : S.of(context).unexpectedErrorMessage,
      descriptionStyle: kNormalStyle.copyWith(color: Colors.grey.shade500),
      child: failure is UserNotFoundFailure ? BtnLogin() : Container(),
    );
  }



}
