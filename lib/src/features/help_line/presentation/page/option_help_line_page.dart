import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/help_line/provider/streaming_provider.dart';
import 'package:smart_cities/src/features/reports/presentation/tab_report/widget/btn_iniciar.dart';
import 'package:smart_cities/src/features/splash/presentation/pages/splash_page.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/components/base_view.dart';
import 'package:smart_cities/src/shared/components/info_view.dart';
import 'package:smart_cities/src/shared/components/rounded_button.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';
import 'package:smart_cities/src/shared/spaces.dart';

import 'audio_streaming_page.dart';
import 'live_video_streaming_page.dart';



class OptionHelpLinePage extends StatelessWidget {
  static const id = "option_help_line_page";
  StreamingProvider provider;

  OptionHelpLinePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<StreamingProvider>(
        onProviderReady: (provider) => provider.getUser(notify: true),
        builder: (context, provider, child) {

          return ModalProgressHUD(
              inAsyncCall: provider.currentState is Loading,
              child: Scaffold(
                backgroundColor: AppColors.backgroundLight,
                appBar: AppBar(),
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: provider.user != null ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Help Line', style: kMediumTitleStyle.copyWith(color: AppColors.red),),
                        Spaces.verticalLarge(),
                        RoundedButton(
                          onPressed: () => _optionLiveVideo(context),
                          style: kTitleStyle.copyWith(fontWeight: FontWeight.w500, color: AppColors.white),
                          title: 'live Video',
                          color: AppColors.red,
                        ),
                        Spaces.verticalMedium(),

                        RoundedButton(
                          onPressed: () =>_optionAudionStreaming(context),
                          style: kTitleStyle.copyWith(fontWeight: FontWeight.w500, color: AppColors.white),
                          title: 'Audio Streaming',
                          color: AppColors.blueBtnRegister,
                        )
                      ],
                    ) : _buildEmptyView(context),
                  ),
                ),
              )


          );

        }
    );




  }
  Widget _buildEmptyView(BuildContext context) {
    return InfoView(
      height: MediaQuery.of(context).size.height*0.7,
      image: AppImages.iconMessage,
      title: 'Aún no existe usuario registrado',
      titleStyle: kMediumTitleStyle.copyWith(color: Colors.grey.shade500),
      description: 'Por favor inicia sesión con tu cuenta',
      descriptionStyle: kNormalStyle.copyWith(color: Colors.grey.shade500),
      child: ButtonLogin(title: S.of(context).connectAccount.toUpperCase(), actionLogin:()=> actionLogin(context),),
    );
  }

  actionLogin(BuildContext context) {
    SplashPage.pushNavigate(context);
  }


  void _optionAudionStreaming(BuildContext context) async {
    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);
    Navigator.pushNamed(context, AudioStreamingPage.id);
  }

  void _optionLiveVideo(BuildContext context)  async{
    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);
    Navigator.pushNamed(context, LiveStreamingPage.id);
  }


  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

}
