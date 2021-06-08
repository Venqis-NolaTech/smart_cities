import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:smart_cities/src/features/help_line/config/agora_config.dart' as config;
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';




class AudioStreamingPage extends StatefulWidget {
  static const id = "audio_streaming_page";

  AudioStreamingPage({Key key}) : super(key: key);

  @override
  _AudioStreamingPageState createState() => _AudioStreamingPageState();
}

class _AudioStreamingPageState extends State<AudioStreamingPage> {
  bool validatePermission= false;
  RtcEngine _engine;
  bool isJoined = false;
  ClientRole role = ClientRole.Broadcaster;
  List<int> remoteUid=[];
  bool isLowAudio = true;
  bool muted = false;
  var uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _engine?.destroy();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          !validatePermission ?
          Center(
            child: CircularProgressIndicator(),
          ): RtcLocalView.SurfaceView(),

          _toolbar(),

          validatePermission ? Positioned(
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

  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
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
            onPressed: _onSwitchCamera,
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

  void _onSwitchCamera() {
    _engine.switchCamera();
  }


  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  Future<void> initialize() async {
    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);

    _engine = await RtcEngine.createWithConfig(RtcEngineConfig(config.appId));

    this._addListener();

    // enable video module and set up video encoding configs
    await _engine.enableVideo();

    // make this room live broadcasting room
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await this._updateClientRole(role);

    // Set audio route to speaker
    await _engine.setDefaultAudioRoutetoSpeakerphone(true);

    // start joining channel
    // 1. Users can only see each other after they join the
    // same channel successfully using the same app id.
    // 2. If app certificate is turned on at dashboard, token is needed
    // when joining channel. The channel name and uid used to calculate
    // the token has to match the ones used for channel join
    await _engine.joinChannel(config.token, config.channelId, null, 0, null);
    setState(() {
      validatePermission=true;
    });
  }

  _updateClientRole(ClientRole role) async {
    var option;
    if (role == ClientRole.Broadcaster) {
      await _engine.setVideoEncoderConfiguration(VideoEncoderConfiguration(
          dimensions: VideoDimensions(640, 360),
          frameRate: VideoFrameRate.Fps30,
          orientationMode: VideoOutputOrientationMode.Adaptative));
      // enable camera/mic, this will bring up permission dialog for first time
      await _engine.enableLocalAudio(true);
      await _engine.enableLocalVideo(true);
    } else {
      // You have to provide client role options if set to audience
      option = ClientRoleOptions(isLowAudio
          ? AudienceLatencyLevelType.LowLatency
          : AudienceLatencyLevelType.UltraLowLatency);
    }
    await _engine.setClientRole(role, option);
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

  _addListener() {
    _engine.setEventHandler(RtcEngineEventHandler(warning: (warningCode) {
      print('Warning ${warningCode}');
    }, error: (errorCode) {
      print('Warning ${errorCode}');
    }, joinChannelSuccess: (channel, uid, elapsed) {
      print('joinChannelSuccess ${channel} ${uid} ${elapsed}');
      setState(() {
        isJoined = true;
      });
    }, userJoined: (uid, elapsed) {
      print('userJoined $uid $elapsed');
      this.setState(() {
        remoteUid.add(uid);
      });
    }, userOffline: (uid, reason) {
      print('userOffline $uid $reason');
      this.setState(() {
        remoteUid.remove(uid);
      });
    }));
  }
}

