import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:smart_cities/src/shared/provider/base_provider.dart';



/// Get your own App ID at https://dashboard.agora.io/
const appId = "a6e6f01685ed48bca67ccc6dd51d46f3";

/// Please refer to https://docs.agora.io/en/Agora%20Platform/token
const token =
    "006a6e6f01685ed48bca67ccc6dd51d46f3IABOzmYIGzG5Gc5e2jR12xQyBtZ5rP8dpMecYm/Lfdbq0mgs5bibjtJtIgBK0bgawTbJYAQAAQDANslgAgDANslgAwDANslgBADANslg";

/// Your channel ID
const channelId = "smart_cities_video";

const uid = 3;

class StreamingProvider extends BaseProvider{

  bool _isJoined = false;

  set isJoined(bool newValue){
    _isJoined=newValue;
    notifyListeners();
  }
  get isJoined=> _isJoined;

  bool _muted = false;

  set muted(bool newValue){
    _muted=newValue;
    notifyListeners();
  }
  get muted=> _muted;



  ClientRole role = ClientRole.Broadcaster;
  List<int> remoteUid=[];
  RtcEngine _engine;
  bool isLowAudio = true;


  Future<void> initialize({bool isVideo}) async {

    _engine = await RtcEngine.createWithConfig(RtcEngineConfig(appId));

    this._addListener();

    if(isVideo)
      // enable video module and set up video encoding configs
      await _engine.enableVideo();
    else
      await _engine.enableAudio();



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
    await _engine.joinChannel(token, channelId, null, uid, null);
  }


  _addListener() {
    _engine.setEventHandler(RtcEngineEventHandler(warning: (warningCode) {
      print('Warning ${warningCode}');
    }, error: (errorCode) {
      print('Warning ${errorCode}');
    }, joinChannelSuccess: (channel, uid, elapsed) {
      print('joinChannelSuccess ${channel} ${uid} ${elapsed}');
      isJoined = true;
    }, userJoined: (uid, elapsed) {
      print('userJoined $uid $elapsed');
      remoteUid.add(uid);
    }, userOffline: (uid, reason) {
      print('userOffline $uid $reason');
      remoteUid.add(uid);
    }));
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


  void onSwitchCamera() {
    _engine.switchCamera();
  }


  void onToggleMute() {
    muted = !muted;
    _engine.muteLocalAudioStream(muted);
  }


  @override
  void dispose() {
    super.dispose();
    _engine?.destroy();

  }


}


