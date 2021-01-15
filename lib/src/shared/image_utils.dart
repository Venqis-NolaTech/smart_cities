import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../generated/i18n.dart';
import '../core/util/string_util.dart';
import '../di/injection_container.dart' as di;

class ImageUtil {
  static Future<BitmapDescriptor> getImage(String path,
      {int width = 30, int height = 30}) async {
    final Uint8List asset = await _getBytesFromAsset(
      path,
      width,
      height,
    );
    return BitmapDescriptor.fromBytes(asset);
  }

  static Future<Uint8List> _getBytesFromAsset(
      String path, int width, int height) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
      targetHeight: height,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  static Future showPhotoDialog(
    BuildContext context,
    Function(File) callback, {
    Function loadingBuilder,
  }) async {
    showDialog(
      context: context,
      child: SimpleDialog(
        title: Text(S.of(context).select),
        children: <Widget>[
          SimpleDialogOption(
            child: Text(S.of(context).camera),
            padding: const EdgeInsets.all(16.0),
            onPressed: () => _handlePhoto(
                context, ImageSource.camera, loadingBuilder, callback),
          ),
          SimpleDialogOption(
            child: Text(S.of(context).gallery),
            padding: const EdgeInsets.all(16.0),
            onPressed: () => _handlePhoto(
                context, ImageSource.gallery, loadingBuilder, callback),
          )
        ],
      ),
    );
  }

  static void getImagePicker(
    BuildContext context,
    ImageSource source,
    Function loadingBuilder,
    Function(File) getPhoto, {
    bool allow = true,
    bool cropImage = true,
    int imageQuality: 80,
  }) async {
    if (!allow) return;

    allow = false;

    if (loadingBuilder != null) loadingBuilder();

    final pickedFile = await di.sl<ImagePicker>().getImage(
          source: source,
          imageQuality: imageQuality,
        );

    if (pickedFile == null || pickedFile.path.isNullOrEmpty) {
      allow = true;

      getPhoto(null);

      return;
    }

    File image = File(pickedFile.path);

    File croppedImage = cropImage
        ? await _cropImage(
            context,
            image,
            imageQuality,
          )
        : image;

    getPhoto(croppedImage);
  }

  static Future<File> _cropImage(
    BuildContext context,
    File image,
    int compressQuality,
  ) async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: image.path,
      compressQuality: 80,
      maxHeight: 700,
      maxWidth: 700,
      compressFormat: ImageCompressFormat.jpg,
      androidUiSettings: AndroidUiSettings(
        toolbarColor: Colors.white,
        toolbarTitle: S.of(context).crop,
        backgroundColor: Colors.white,
      ),
      iosUiSettings: IOSUiSettings(
        title: S.of(context).crop,
      ),
    );

    return croppedImage;
  }

  static void _handlePhoto(
    BuildContext context,
    ImageSource source,
    Function loadingBuilder,
    Function(File) callback,
  ) {
    Navigator.pop(context);

    getImagePicker(context, source, loadingBuilder, callback);
  }
}
