import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:smart_cities/src/features/help_line/presentation/widget/circle_painter.dart';
import 'package:smart_cities/src/features/help_line/presentation/widget/curve_wave.dart';
import 'package:smart_cities/src/features/help_line/provider/streaming_provider.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/components/base_view.dart';




class AudioStreamingPage extends StatefulWidget {
  static const id = "audio_streaming_page";

  AudioStreamingPage({Key key}) : super(key: key);

  @override
  _AudioStreamingPageState createState() => _AudioStreamingPageState();
}

class _AudioStreamingPageState extends State<AudioStreamingPage> with TickerProviderStateMixin {

  AnimationController _controller;
  StreamingProvider provider;



  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    super.initState();
  }


  @override
  void dispose() {
    //_engine?.destroy();
    _controller.dispose();
    provider.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size.width*0.7;

    return BaseView<StreamingProvider>(
        onProviderReady: (provider) {
          this.provider = provider;
          provider.initialize(isVideo: false);
        },

        builder: (context, provider, child) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.red,
                leading: Icon(MdiIcons.close),
              ),
              body: Stack(
                children: [
                  !provider.isJoined ?
                  Center(
                    child: CircularProgressIndicator(),
                  ):
                  Center(
                    child: CustomPaint(
                      painter: CirclePainter(
                        _controller,
                        color: AppColors.red,
                      ),
                      child: SizedBox(
                        width: size * 4.125,
                        height: size * 4.125,
                        child: _button(size),
                      ),
                    ),
                  ),

                  _toolbar()
                ],
              )
          );


        }
    );


  }


  Widget _button(double size) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: <Color>[
                AppColors.red,
                Color.lerp(AppColors.red, Colors.black, .05)
              ],
            ),
          ),
          child: ScaleTransition(
              scale: Tween(begin: 0.95, end: 1.0).animate(
                CurvedAnimation(
                  parent: _controller,
                  curve: const CurveWave(),
                ),
              ),
              child: Icon(Icons.speaker_phone, color: AppColors.white, size: 44,)
          ),
        ),
      ),
    );
  }

  Widget _buidlMute(){
    return RawMaterialButton(
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
    );
  }

  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buidlMute(),

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
            onPressed:  () => {},
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

