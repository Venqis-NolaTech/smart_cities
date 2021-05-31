import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'dart:io' as io;

class HelpLinePage extends StatefulWidget {
  static const id = "help_line_page";
  final LocalFileSystem localFileSystem;

  HelpLinePage({Key key, localFileSystem}) : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  _HelpLinePageState createState() => _HelpLinePageState();
}

class _HelpLinePageState extends State<HelpLinePage> {
  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          Expanded(
              child: Container(
                color: AppColors.red,
                child: Center(
                  child: buildIcon(MdiIcons.videoVintage, AppColors.white, AppColors.blueDark),
                ),
              )
          ),


          Expanded(
            child: Container(
              color: AppColors.white,
              child: Center(
                child: InkWell(
                  onTap: (){

                    switch (_currentStatus) {
                      case RecordingStatus.Initialized:
                        {
                          _start();
                          break;
                        }
                      case RecordingStatus.Recording:
                        {
                          _pause();
                          break;
                        }
                      case RecordingStatus.Paused:
                        {
                          _resume();
                          break;
                        }
                      case RecordingStatus.Stopped:
                        {
                          _init();
                          break;
                        }
                      default:
                        break;
                    }


                  },
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildIcon(MdiIcons.microphone, AppColors.blueDark, AppColors.white),
                        _buildTimer(_currentStatus),
                      ],
                    )
                ),
              ),
            )
          )


        ],
      ),
    );
  }

  NumberFormat f = new NumberFormat("00");

  Widget _buildTimer(RecordingStatus status){

    return Text(
      '00:${f.format(_current.duration.inSeconds)}',
      style: Theme.of(context).textTheme.headline2,
    );
  }



  Widget buildIcon(IconData icon, Color color,  Color iconColor) {
    return Container(
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle
              ),
              child: Padding(
                padding: EdgeInsets.all(60.0),
                child: Icon(icon, size: 50, color: iconColor),
              )
            );
  }


  _init() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        String customPath = '/flutter_audio_recorder_';
        io.Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder =
            FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await _recorder.initialized;
        // after initialization
        var current = await _recorder.current(channel: 0);
        print(current);
        // should be "Initialized", if all working fine
        setState(() {
          _current = current;
          _currentStatus = current.status;
          print(_currentStatus);
        });
      } else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  _start() async {
    try {
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);
      setState(() {
        _current = recording;
      });

      const tick = const Duration(milliseconds: 1000);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current;
          _currentStatus = _current.status;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  _resume() async {
    await _recorder.resume();
    setState(() {});
  }

  _pause() async {
    await _recorder.pause();
    setState(() {});
  }

  _stop() async {
    var result = await _recorder.stop();
    print("Stop recording: ${result.path}");
    print("Stop recording: ${result.duration}");
    File file = widget.localFileSystem.file(result.path);
    print("File length: ${await file.length()}");
    setState(() {
      _current = result;
      _currentStatus = _current.status;
    });
  }

  Widget _buildText(RecordingStatus status) {
    var text = "";
    switch (_currentStatus) {
      case RecordingStatus.Initialized:
        {
          text = 'Start';
          break;
        }
      case RecordingStatus.Recording:
        {
          text = 'Pause';
          break;
        }
      case RecordingStatus.Paused:
        {
          text = 'Resume';
          break;
        }
      case RecordingStatus.Stopped:
        {
          text = 'Init';
          break;
        }
      default:
        break;
    }
    return Text(text, style: TextStyle(color: Colors.white));
  }

  /*void onPlayAudio() async {
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(_current.path, isLocal: true);
  }*/

}


