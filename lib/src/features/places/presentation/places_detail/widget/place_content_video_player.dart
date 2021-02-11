import 'package:flutter/material.dart';
import 'package:smart_cities/src/features/places/domain/entities/place.dart';
import 'package:video_player/video_player.dart';
import 'package:smart_cities/src/shared/components/custom_card.dart';
//import '../../../../../shared/spaces.dart';



class PlaceContentVideo extends StatefulWidget {
  final Place place;

  const PlaceContentVideo({Key key, this.place}) : super(key: key);

  @override
  _PlaceContentVideoState createState() => _PlaceContentVideoState();
}

class _PlaceContentVideoState extends State<PlaceContentVideo> {
  VideoPlayerController _controller;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }


   @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        CustomCard(
          margin: EdgeInsets.only(left: 24.0, right: 24.0),
          child: _controller.value.initialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Container(
                  height: 120,
                ),

        ),
      ],
    );
  }
}
