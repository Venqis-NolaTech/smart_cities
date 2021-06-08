import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_cities/src/features/help_line/provider/streaming_provider.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/components/base_view.dart';
import 'package:smart_cities/src/shared/constant.dart';

import 'audio_streaming_page.dart';
import 'live_video_streaming_page.dart';



class OptionHelpLinePage extends StatelessWidget {
  static const id = "option_help_line_page";
  OptionHelpLinePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Help Line', style: kMediumTitleStyle.copyWith(color: AppColors.red),),
            FlatButton(onPressed: () =>_optionLiveVideo(context), child: Text('live Video')),
            FlatButton(onPressed: () =>_optionAudionStreaming(context), child: Text('Audio Streaming'))
          ],
        ),
      ),
    );


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
