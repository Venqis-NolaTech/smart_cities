import 'package:equatable/equatable.dart';

class Streaming  extends Equatable{
  Streaming({
    this.appId,
    this.channel,
    this.token,
    this.uid,
  });

  final String appId;
  final String channel;
  final String token;
  final int uid;


  @override
  List<Object> get props => [appId, uid];
}

