import 'package:smart_cities/src/features/help_line/domain/entities/streaming.dart';

class StreamingModel extends Streaming {
  StreamingModel({
    String appId,
    String channel,
    String token,
    int uid
  }): super(
    appId: appId,
    channel: channel,
    token: token,
    uid: uid
  );


  factory StreamingModel.fromJson(Map<String, dynamic> json) => StreamingModel(
    appId: json["appID"],
    channel: json["channel"],
    token: json["token"],
    uid: json["uid"],
  );

  Map<String, dynamic> toJson() => {
    "appID": appId,
    "channel": channel,
    "token": token,
    "uid": uid,
  };

}