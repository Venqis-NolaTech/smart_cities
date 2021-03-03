import 'package:flutter/material.dart';
import 'package:smart_cities/src/features/main/presentation/pages/main_page.dart';

import '../../../../../generated/i18n.dart';
import '../../../../core/error/failure.dart';
import '../../../../shared/app_colors.dart';
import '../../../../shared/app_images.dart';
import '../../../../shared/components/base_view.dart';
import '../../../../shared/components/info_alert_dialog.dart';
import '../../../../shared/components/logo.dart';
import '../../../../shared/components/rounded_button.dart';
import '../../../../shared/constant.dart';
import '../../../../shared/provider/view_state.dart';
import '../providers/splash_provider.dart';

class SplashPage extends StatefulWidget {
  static const id = "splash_page";

  static pushNavigate(BuildContext context) =>
      Navigator.pushNamedAndRemoveUntil(context, id, (route) => false);


  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  String _buildErrorMessage(BuildContext context, Failure failure) {
    switch (failure.runtimeType) {
      case NotConnectionFailure:
        return S.of(context).notConnectionMessage;
      default:
        return S.of(context).unexpectedErrorMessage;
    }
  }

  var initialRoute;

  @override
  Widget build(BuildContext context) {
    return BaseView<SplashProvider>(
      onProviderReady: (provider) {
        provider.initializeApp(callback: (route) {
          initialRoute = route;
          if(initialRoute==MainPage.id)
            Navigator.pushReplacementNamed(context, initialRoute);
        });
      },
      builder: (context, provider, child) {
        final currentState = provider.currentState;

        if (currentState is Error) {
          final failure = currentState.failure;

          if (!(failure is UserNotFoundFailure)) {
            Future.delayed(
              Duration(milliseconds: 250),
              () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return InfoAlertDialog(
                      textAlign: TextAlign.center,
                      message: _buildErrorMessage(context, failure),
                      onConfirm: () => Navigator.pop(context),
                    );
                  },
                );
              },
            );
          }
        }

        return Scaffold(
          body: Stack(
            alignment: Alignment.center,
            children: [
              _buildBackground(context),
              _buildGradiente(context),
              Logo(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 80),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    currentState is Loading
                        ? SizedBox(
                            height: 24.0,
                            width: 24.0,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : _buildButtomStart(context)
                  ],
                ),
              )
              //currentState is Loading ? _buildLoading() : SizedBox.shrink(),
              //currentState is Loading ? _buildLoading() : _buildButtomStart(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildButtomStart(BuildContext context) {
    return RoundedButton(
        color: Colors.transparent,
        borderColor: AppColors.white,
        title: S.of(context).start.toUpperCase(),
        style: kNormalStyle.copyWith(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            color: AppColors.white),
        onPressed: () => Navigator.pushReplacementNamed(context, initialRoute));
  }

  Widget _buildBackground(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(AppImagePaths.homeBackground), fit: BoxFit.fill),
      ),
      // child: Logo(),
    );
  }

  Widget _buildGradiente(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: AppImages.splashBackground,
    );
  }
}
