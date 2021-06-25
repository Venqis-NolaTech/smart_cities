import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/help_line/provider/streaming_provider.dart';
import 'package:smart_cities/src/features/reports/presentation/tab_report/widget/btn_iniciar.dart';
import 'package:smart_cities/src/features/splash/presentation/pages/splash_page.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/components/base_view.dart';
import 'package:smart_cities/src/shared/components/info_view.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;

class StreamingPage extends StatefulWidget {
  static const id = "streaming_page";

  StreamingPage({Key key}) : super(key: key);

  @override
  _StreamingPageState createState() => _StreamingPageState();
}

class _StreamingPageState extends State<StreamingPage> {
  StreamingProvider provider;
  bool readyForCall = false;

  @override
  void initState() {
    _optionAudionStreaming();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<StreamingProvider>(onProviderReady: (_provider) {
      provider = _provider;
      provider.getUser(notify: true);
    }, builder: (context, provider, child) {
      return provider.user != null
          ? Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.red,
                centerTitle: true,
                title: Text(!provider.isJoined ? 'llamando...' : 'in live'),
              ),
              body: Stack(
                children: [
                  !provider.cameraOff
                      ? Center(
                          child: Icon(
                            MdiIcons.account,
                            size: 200,
                            color: AppColors.blueBtnRegister,
                          ),
                        )
                      : provider.isJoined
                          ? RtcLocalView.SurfaceView()
                          : CircularProgressIndicator(),
                  _toolbar()
                ],
              ),
            )
          : _buildEmptyView(context);
    });
  }

  void _optionAudionStreaming() async {
    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);
    provider.initialize(isVideo: false);
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

  Widget _buildEmptyView(BuildContext context) {
    return InfoView(
      height: MediaQuery.of(context).size.height,
      image: AppImages.iconMessage,
      title: 'Aún no existe usuario registrado',
      titleStyle: kMediumTitleStyle.copyWith(color: Colors.grey.shade500),
      description: 'Por favor inicia sesión con tu cuenta',
      descriptionStyle: kNormalStyle.copyWith(color: Colors.grey.shade500),
      child: ButtonLogin(
        title: S.of(context).connectAccount.toUpperCase(),
        actionLogin: () => actionLogin(context),
      ),
    );
  }

  actionLogin(BuildContext context) {
    SplashPage.pushNavigate(context);
  }

  Widget _toolbar() {
    return Column(
      //mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        RawMaterialButton(
          onPressed: () => _onCallEnd(context),
          child: Icon(
            Icons.call_end,
            color: Colors.white,
            size: 35.0,
          ),
          shape: CircleBorder(),
          elevation: 2.0,
          fillColor: AppColors.red,
          padding: const EdgeInsets.all(15.0),
        ),
        Spaces.verticalMedium(),
        Container(
          color: AppColors.red,
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: InkWell(
                  onTap: () => provider.onToggleMute(),
                  child: Container(
                    color: provider.muted
                        ? AppColors.blueBtnRegister
                        : Colors.white,
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(
                      provider.muted ? Icons.mic_off : Icons.mic,
                      color: provider.muted
                          ? Colors.white
                          : AppColors.blueBtnRegister,
                      size: 20.0,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: null,
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    color: provider.cameraOff
                        ? AppColors.blueBtnRegister
                        : Colors.white,
                    child: Icon(
                      !provider.cameraOff
                          ? MdiIcons.cameraOff
                          : MdiIcons.camera,
                      color: provider.cameraOff
                          ? Colors.white
                          : AppColors.blueBtnRegister,
                      size: 20.0,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => provider.onSwitchCamera(),
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(
                      Icons.switch_camera,
                      color: AppColors.blueBtnRegister,
                      size: 20.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }
}
