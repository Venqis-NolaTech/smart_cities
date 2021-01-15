import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/core/error/failure.dart';
import 'package:smart_cities/src/features/auth/domain/entities/user.dart';
import 'package:smart_cities/src/features/auth/presentation/base/providers/phone_number_auth_provider.dart';
import 'package:smart_cities/src/features/auth/presentation/phone_number/pages/phone_number_page.dart';
import 'package:smart_cities/src/features/resports/presentation/list/provider/my_report_provider.dart';
import 'package:smart_cities/src/features/resports/presentation/list/provider/report_location_provider.dart';
import 'package:smart_cities/src/features/resports/presentation/list/widget/report_list_view.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/components/base_view.dart';
import 'package:smart_cities/src/shared/components/info_view.dart';
import 'package:smart_cities/src/shared/components/rounded_button.dart';
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


}
