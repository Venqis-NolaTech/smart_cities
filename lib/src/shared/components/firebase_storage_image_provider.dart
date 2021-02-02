import 'dart:async' show Future;
import 'dart:io' show File;
import 'dart:typed_data';
import 'dart:ui' as ui show instantiateImageCodec, Codec;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../di/injection_container.dart';

typedef void ErrorListener();

final _storage = sl<FirebaseStorage>();

class FirebaseStoreImageProvider
    extends ImageProvider<FirebaseStoreImageProvider> {
  const FirebaseStoreImageProvider(
    this.ref, {
    this.scale: 1.0,
    this.errorListener,
    this.cacheManager,
  })  : assert(ref != null),
        assert(scale != null);

  final BaseCacheManager cacheManager;

  /// firebase ref of the image to load
  final String ref;

  /// Scale of the image
  final double scale;

  /// Listener to be called when images fails to load.
  final ErrorListener errorListener;

  @override
  ImageStreamCompleter load(FirebaseStoreImageProvider key, decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key),
      scale: key.scale,
    );
  }

  @override
  Future<FirebaseStoreImageProvider> obtainKey(
      ImageConfiguration configuration) {
    return SynchronousFuture<FirebaseStoreImageProvider>(this);
  }

  Future<String> _getImageUrl() async {
    final gsReference = await _storage.refFromURL(ref);
    final String url = await gsReference.getDownloadURL();
    return url;
  }

  Future<ui.Codec> _loadAsync(FirebaseStoreImageProvider key) async {
    var manager = cacheManager ?? DefaultCacheManager();
    var url = await _getImageUrl();

    var file = await manager.getSingleFile(url, headers: null);
    if (file == null) {
      if (errorListener != null) errorListener();
      return Future<ui.Codec>.error("Couldn't download or retrieve file.");
    }
    return await _loadAsyncFromFile(key, file);
  }

  Future<ui.Codec> _loadAsyncFromFile(
      FirebaseStoreImageProvider key, File file) async {
    assert(key == this);

    final Uint8List bytes = await file.readAsBytes();

    if (bytes.lengthInBytes == 0) {
      if (errorListener != null) errorListener();
      throw Exception("File was empty");
    }

    return await ui.instantiateImageCodec(bytes);
  }
}
