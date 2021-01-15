import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../di/injection_container.dart' as di;
import '../../core/util/string_util.dart';
import '../app_images.dart';

class FirebaseStoreCircularAvatar extends StatelessWidget {
  const FirebaseStoreCircularAvatar({
    Key key,
    @required this.referenceUrl,
    this.height = 40.0,
    this.width = 40.0,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  final String referenceUrl;
  final double height;
  final double width;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      child: Material(
        shape: CircleBorder(),
        child: ClipOval(
          child: referenceUrl != null
              ? FirebaseStorageImage(
                  referenceUrl: referenceUrl,
                  fallbackWidget: CircularProgressIndicator(),
                  errorWidget: AppImages.defaultImage,
                )
              : AppImages.defaultImage,
        ),
      ),
    );
  }
}

enum ImageDownloadState { Idle, GettingReference, GettingURL, Done, Error }

class FirebaseStorageImage extends StatefulWidget {
  /// The reference url of the image that has to be loaded.
  final String referenceUrl;

  /// The widget that will be displayed when loading if no [placeholderImage] is set.
  final Widget fallbackWidget;

  /// The widget that will be displayed if an error occurs.
  final Widget errorWidget;

  /// The image that will be displayed when loading if no [fallbackWidget] is set.
  final ImageProvider placeholderImage;

  final BoxFit fit;

  final double width;

  final double height;

  FirebaseStorageImage({
    Key key,
    @required this.referenceUrl,
    @required this.errorWidget,
    this.fallbackWidget,
    this.placeholderImage,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  }) {
    assert(
        (this.fallbackWidget == null && this.placeholderImage != null) ||
            (this.fallbackWidget != null && this.placeholderImage == null),
        "Either [fallbackWidget] or [placeholderImage] must not be null.");
  }

  @override
  _FirebaseStorageImageState createState() => _FirebaseStorageImageState(
        referenceUrl,
        fallbackWidget,
        errorWidget,
        placeholderImage,
        fit,
        width,
        height,
      );
}

class _FirebaseStorageImageState extends State<FirebaseStorageImage>
    with SingleTickerProviderStateMixin {
  _FirebaseStorageImageState(
    String referenceUrl,
    this.fallbackWidget,
    this.errorWidget,
    this.placeholderImage,
    this.fit,
    this.width,
    this.height,
  );

  final BoxFit fit;

  final double width;

  final double height;

  // Storage firebase.
  final _storage = di.sl<FirebaseStorage>();

  /// The widget that will be displayed when loading if no [placeholderImage] is set.
  final Widget fallbackWidget;

  /// The widget that will be displayed if an error occurs.
  final Widget errorWidget;

  /// The image that will be displayed when loading if no [fallbackWidget] is set.
  final ImageProvider placeholderImage;

  /// The image that will be/has been downloaded from the [reference].
  CachedNetworkImage _networkImage;

  /// The state of the [_networkImage].
  ImageDownloadState _imageDownloadState = ImageDownloadState.Idle;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 100), () => getReferenceFromUrl());
  }

  void getReferenceFromUrl() {
    if (widget.referenceUrl.isNullOrEmpty) {
      this._setError();

      return;
    }

    final reference = _storage.getReferenceFromUrl(widget.referenceUrl);

    this._imageDownloadState = ImageDownloadState.GettingReference;

    reference.then(this._getReferenceByUrl).catchError((err) {
      this._setError();
    });
  }

  Widget _buildPlaceholder() => this.placeholderImage != null
      ? Image(image: this.placeholderImage, fit: fit)
      : Center(child: this.fallbackWidget);

  /// Gets reference from reference url.
  void _getReferenceByUrl(StorageReference reference) {
    final url = reference.getDownloadURL();

    this._imageDownloadState = ImageDownloadState.GettingURL;

    url.then(this._setImageData).catchError((err) {
      this._setError();
    });
  }

  /// Sets the [_networkImage] to the image downloaded from [url].
  void _setImageData(dynamic url) {
    this._networkImage = CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      placeholder: (_, __) => _buildPlaceholder(),
      errorWidget: (_, __, ___) => errorWidget,
    );

    if (mounted)
      setState(() => this._imageDownloadState = ImageDownloadState.Done);
  }

  /// Sets the [_imageDownloadState] to [ImageDownloadState.Error] and redraws the UI.
  void _setError() {
    if (mounted)
      setState(() => this._imageDownloadState = ImageDownloadState.Error);
  }

  @override
  Widget build(BuildContext context) {
    Widget widgetRender = Container();

    switch (this._imageDownloadState) {
      case ImageDownloadState.Idle:
      case ImageDownloadState.GettingReference:
      case ImageDownloadState.GettingURL:
        widgetRender = _buildPlaceholder();
        break;
      case ImageDownloadState.Error:
        widgetRender = this.errorWidget ?? AppImages.defaultImage;
        break;
      case ImageDownloadState.Done:
        widgetRender = this._networkImage;
        break;
      default:
        widgetRender = this.errorWidget;
    }

    return SizedBox(
      height: height,
      width: width,
      child: widgetRender,
    );
  }
}
