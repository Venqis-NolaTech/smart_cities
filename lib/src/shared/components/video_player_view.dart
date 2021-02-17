import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:video_player/video_player.dart';

import '../../di/injection_container.dart' as di;
import '../../core/util/string_util.dart';
import '../app_images.dart';
import 'circular_button.dart';

enum VideoDownloadState { Idle, GettingReference, GettingURL, Done, Error }

class FirebaseStoreVideoPlayerView extends StatefulWidget {
  FirebaseStoreVideoPlayerView({
    Key key,
    @required this.referenceUrl,
    @required this.errorWidget,
    this.fallbackWidget,
    this.placeholderImage,
    this.width,
    this.height,
  }) : super(key: key);

  final String referenceUrl;

  final Widget fallbackWidget;

  final Widget errorWidget;

  final ImageProvider placeholderImage;

  final double width;

  final double height;

  @override
  _FirebaseStoreVideoPlayerViewState createState() =>
      _FirebaseStoreVideoPlayerViewState(
        referenceUrl: referenceUrl,
        fallbackWidget: fallbackWidget,
        errorWidget: errorWidget,
        placeholderImage: placeholderImage,
        height: height,
        width: width,
      );
}

class _FirebaseStoreVideoPlayerViewState
    extends State<FirebaseStoreVideoPlayerView> {
  _FirebaseStoreVideoPlayerViewState({
    String referenceUrl,
    this.fallbackWidget,
    this.errorWidget,
    this.placeholderImage,
    this.width,
    this.height,
  }) {
    if (referenceUrl.isNullOrEmpty) {
      this._setError();

      return;
    }

    final reference = _storage.getReferenceFromUrl(referenceUrl);

    this._videoDownloadState = VideoDownloadState.GettingReference;

    reference.then(this._getReferenceByUrl).catchError((err) {
      this._setError();
    });
  }

  final _storage = di.sl<FirebaseStorage>();

  final Widget fallbackWidget;

  final Widget errorWidget;

  final ImageProvider placeholderImage;

  final double width;

  final double height;

  VideoDownloadState _videoDownloadState = VideoDownloadState.Idle;

  String videoUrl;

  Widget _buildPlaceholder() => this.placeholderImage != null
      ? Image(image: this.placeholderImage, fit: BoxFit.cover)
      : Center(child: this.fallbackWidget);

  void _getReferenceByUrl(StorageReference reference) {
    final url = reference.getDownloadURL();

    this._videoDownloadState = VideoDownloadState.GettingURL;

    url.then(this._setData).catchError((err) {
      this._setError();
    });
  }

  void _setData(dynamic url) {
    videoUrl = url;

    if (mounted)
      setState(() => this._videoDownloadState = VideoDownloadState.Done);
  }

  void _setError() {
    if (mounted)
      setState(() => this._videoDownloadState = VideoDownloadState.Error);
  }

  @override
  Widget build(BuildContext context) {
    Widget widget = Container();

    switch (this._videoDownloadState) {
      case VideoDownloadState.Idle:
      case VideoDownloadState.GettingReference:
      case VideoDownloadState.GettingURL:
        widget = _buildPlaceholder();
        break;
      case VideoDownloadState.Error:
        widget = this.errorWidget ?? AppImages.defaultImage;
        break;
      case VideoDownloadState.Done:
        widget = VideoPlayerView(url: videoUrl);
        break;
      default:
        widget = this.errorWidget;
    }

    return SizedBox(
      height: height,
      width: width,
      child: widget,
    );
  }
}

class VideoPlayerView extends StatefulWidget {
  VideoPlayerView({
    Key key,
    this.file,
    this.url,
    this.showMainPlayButton = false,
  })  : assert((file != null && url == null) || (file == null && url != null)),
        super(key: key);

  final File file;
  final String url;
  final bool showMainPlayButton;

  @override
  _VideoPlayerViewState createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();

    _videoPlayerController = widget.file != null
        ? VideoPlayerController.file(widget.file)
        : VideoPlayerController.network(widget.url);

    _initVideoPlayer();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();

    super.dispose();
  }

  Future<void> _initVideoPlayer() async {
    await _videoPlayerController.initialize();

    setState(() {
      _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          aspectRatio: _videoPlayerController.value.aspectRatio * 1.6,
          showControls: !widget.showMainPlayButton,
          looping: true,
          autoInitialize: true,
          allowFullScreen: true,
          deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Center(
          child: _videoPlayerController?.value?.initialized ?? false
              ? Chewie(
                  controller: _chewieController,
                )
              : new CircularProgressIndicator(),
        ),
        widget.showMainPlayButton ? _buildPlayButton() : Container(),
      ],
    );
  }

  Widget _buildPlayButton() {
    final isPlaying =
        _chewieController?.videoPlayerController?.value?.isPlaying ?? false;

    return Container(
      child: Center(
        child: CircularButton(
          size: 60,
          color: Colors.white.withOpacity(0.6),
          child: Icon(
            isPlaying ? MdiIcons.pause : MdiIcons.play,
          ),
          onPressed: () => setState(() {
            isPlaying
                ? _videoPlayerController.pause()
                : _videoPlayerController.play();
          }),
        ),
      ),
    );
  }
}
