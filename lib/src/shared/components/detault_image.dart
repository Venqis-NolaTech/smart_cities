import 'package:flutter/material.dart';

class DefaultImage extends StatelessWidget {
  DefaultImage({
    Key key,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'res/images/default_image.png',
      fit: fit,
    );
  }
}
