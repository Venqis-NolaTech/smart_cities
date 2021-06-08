import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:smart_cities/src/features/help_line/provider/streaming_provider.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/components/base_view.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';




class LiveStreamingPage extends StatefulWidget {
  static const id = "live_streaming_page";
  LiveStreamingPage({Key key}) : super(key: key);

  @override
  _LiveStreamingPageState createState() => _LiveStreamingPageState();
}

class _LiveStreamingPageState extends State<LiveStreamingPage> {
  StreamingProvider provider;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    provider?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return BaseView<StreamingProvider>(
        onProviderReady: (provider) {
          this.provider = provider;
          provider.initialize(isVideo: true);
        },

        builder: (context, provider, child) {

          return Scaffold(
            body: Stack(
              children: [
                !provider.isJoined ?
                Center(
                  child: CircularProgressIndicator(),
                ): RtcLocalView.SurfaceView(),

                _toolbar(),

                provider.isJoined ? Positioned(
                  top: 20,
                  right: 40,
                  child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          children: [
                            Icon(MdiIcons.eyeOutline, color: AppColors.white),
                            Spaces.horizontalSmall(),
                            Text('Live', style: kNormalStyle.copyWith(color: AppColors.white),),
                          ],
                        ),
                      )),
                ) : Container()

              ],
            )

            ,
          );
        }
    );



  }

  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: ()=> provider.onToggleMute(),
            child: Icon(
              provider.muted ? Icons.mic_off : Icons.mic,
              color: provider.muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: provider.muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed:  () => provider.onSwitchCamera(),
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),

        ],
      ),
    );
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }



}

