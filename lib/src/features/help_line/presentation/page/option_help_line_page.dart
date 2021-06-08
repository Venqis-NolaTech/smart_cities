import 'package:flutter/material.dart';



class OptionHelpLinePage extends StatelessWidget {
  static const id = "option_help_line_page";


  OptionHelpLinePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text('Help Line'),
          FlatButton(onPressed: _optionLiveVideo, child: Text('live Video')),
          FlatButton(onPressed: _optionAudionStreaming, child: Text('Audio Streaming'))
        ],
      ),
    );
  }

  void _optionAudionStreaming() {



  }

  void _optionLiveVideo() {
  }
}
