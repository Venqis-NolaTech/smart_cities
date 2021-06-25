import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:meta/meta.dart';
import 'package:smart_cities/src/core/usecases/use_case.dart';
import 'package:smart_cities/src/features/auth/domain/entities/user.dart';
import 'package:smart_cities/src/features/auth/domain/usecases/get_current_location_use_case.dart';
import 'package:smart_cities/src/features/auth/domain/usecases/logged_user_use_case.dart';
import 'package:smart_cities/src/features/help_line/domain/entities/streaming.dart';
import 'package:smart_cities/src/features/help_line/domain/usescase/get_data_streaming_use_case.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/provider/current_user_provider.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';

/*
const appId = "a6e6f01685ed48bca67ccc6dd51d46f3";

const token =
    "006a6e6f01685ed48bca67ccc6dd51d46f3IACh0jCvDaGGz+0fZwcLFAuLt0uiBcK8q2UbNa0307NnxNHAX9zTrYavIgC0phOguWDKYAQAAQC4YMpgAgC4YMpgAwC4YMpgBAC4YMpg";

const channelId = "smart_cities_audio";

const uid = 18;*/

class StreamingProvider extends CurrentUserProvider {
  final GetDataStreamingUseCase getDataStreamingUseCase;
  final GetCurrentLocationUseCase getCurrentLocationUseCase;

  StreamingProvider(
      {@required this.getDataStreamingUseCase,
      @required this.getCurrentLocationUseCase,
      @required LoggedUserUseCase loggedUserUseCase})
      : super(loggedUserUseCase: loggedUserUseCase);

  final String canalVideo = 'smart_cities_video';

  bool _isJoined = false;
  set isJoined(bool newValue) {
    _isJoined = newValue;
    notifyListeners();
  }

  get isJoined => _isJoined;

  bool _muted = false;
  set muted(bool newValue) {
    _muted = newValue;
    notifyListeners();
  }

  get muted => _muted;

  bool _cameraOff = false;
  set cameraOff(bool newValue) {
    _cameraOff = newValue;
    notifyListeners();
  }

  get cameraOff => _cameraOff;

  ClientRole role = ClientRole.Broadcaster;
  RtcEngine _engine;
  bool isLowAudio = true;

  Position currentLocation;

  Future initialize({bool isVideo}) async {
    state = Loading();

    if (currentLocation == null) 
      await getCurrentLocation(notify: false);

    var result = await getDataStreamingUseCase(GetDataStreamingParams(
        canal: canalVideo,
        latitude: currentLocation.latitude,
        longitude: currentLocation.longitude));


    result.fold(
      (failure) => state = Error(failure: failure),
      (valueData) => connectLive(valueData),
    );

  }

  Future<Position> getCurrentLocation({bool notify = true}) async {
    final failureOrLocation = await getCurrentLocationUseCase(NoParams());

    final location = failureOrLocation.fold(
      (_) => Position(
        latitude: kDefaultLocation.latitude,
        longitude: kDefaultLocation.longitude,
      ),
      (location) => location,
    );

    currentLocation = location;
    return currentLocation;
  }

  Future connectLive(Streaming valueData) async {
    _engine =
        await RtcEngine.createWithConfig(RtcEngineConfig(valueData.appId));
    this._addListener();
    /*if (isVideo)
      await _engine.enableVideo();
    else*/

    await _engine.enableAudio();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await this._updateClientRole(role);

    // Set audio route to speaker
    await _engine.setDefaultAudioRoutetoSpeakerphone(true);

    await _engine.joinChannel(
        valueData.token, valueData.channel, null, valueData.uid, null);
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
    }, userOffline: (uid, reason) {
      print('userOffline $uid $reason');
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
    _engine?.muteLocalAudioStream(muted);
  }

  void onToggleCamera() {
    cameraOff = !cameraOff;
    if (cameraOff)
      _engine?.enableVideo();
    else
      _engine?.disableVideo();
  }

  @override
  void dispose() async {
    _engine?.destroy();
  }
}
