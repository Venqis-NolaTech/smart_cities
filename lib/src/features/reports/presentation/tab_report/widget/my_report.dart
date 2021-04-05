import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/core/error/failure.dart';
import 'package:smart_cities/src/features/auth/domain/entities/user.dart';
import 'package:smart_cities/src/features/auth/presentation/sign_in/pages/sign_in_page.dart';
import 'package:smart_cities/src/features/reports/presentation/list/provider/my_report_provider.dart';
import 'package:smart_cities/src/features/reports/presentation/list/provider/report_location_provider.dart';
import 'package:smart_cities/src/features/reports/presentation/list/widget/report_list_view.dart';
import 'package:smart_cities/src/features/reports/presentation/tab_report/widget/btn_iniciar.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/components/base_view.dart';
import 'package:smart_cities/src/shared/components/info_view.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';




class MyReport extends StatelessWidget {
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
    return ReportListView<MyReportProvider>(
      currentLocation: data,
      topAndBottomPaddingEnabled: false,
      isMyReport: true,
    );
  }

  Widget _buildErrorView(BuildContext context, Failure failure) {
    return InfoView(
      height: MediaQuery.of(context).size.height * 0.7,
      image: AppImages.iconMessage,
      title: S.of(context).empyteReport,
      titleStyle: kMediumTitleStyle.copyWith(color: Colors.grey.shade500),
      description: failure is UserNotFoundFailure
          ? S.of(context).userNotFoundMessage
          : S.of(context).unexpectedErrorMessage,
      descriptionStyle: kNormalStyle.copyWith(color: Colors.grey.shade500),
      child: failure is UserNotFoundFailure
          ? ButtonLogin(
              title: S.of(context).login.toUpperCase(),
              actionLogin: () => SignInPage.pushNavigate(context),
            )
          : Container(),
    );
  }
}
