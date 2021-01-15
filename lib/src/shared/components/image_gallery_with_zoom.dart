import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../app_colors.dart';
import 'firebase_storage_image_provider.dart';

class ImageGalleryWithZoom extends StatefulWidget {
  ImageGalleryWithZoom({
    Key key,
    this.loadingBuilder,
    this.backgroundDecoration = const BoxDecoration(color: Colors.transparent),
    this.minScale,
    this.maxScale,
    this.initialIndex,
    @required this.imageUrls,
    this.scrollDirection = Axis.horizontal,
  })  : pageController = PageController(initialPage: initialIndex),
        super(key: key);

  final LoadingBuilder loadingBuilder;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<String> imageUrls;
  final Axis scrollDirection;

  @override
  _ImageGalleryWithZoomState createState() => _ImageGalleryWithZoomState();
}

class _ImageGalleryWithZoomState extends State<ImageGalleryWithZoom> {
  int _currentIndex = 0;

  @override
  void initState() {
    _currentIndex = widget.initialIndex;

    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  List<T> _map<T>(List<String> images, Function(int, String) handler) {
    List<T> result = [];
    for (var i = 0; i < images.length; i++) {
      result.add(handler(i, images[i]));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: <Widget>[
        Container(
          decoration: widget.backgroundDecoration,
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: _buildItem,
            itemCount: widget.imageUrls.length,
            loadingBuilder: widget.loadingBuilder,
            backgroundDecoration: widget.backgroundDecoration,
            pageController: widget.pageController,
            onPageChanged: onPageChanged,
            scrollDirection: widget.scrollDirection,
          ),
        ),
        /*Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _map<Widget>(
            widget.imageUrls,
            (index, _) {
              var size = _currentIndex == index ? 9.0 : 8.0;
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: size,
                height: size,
                margin: EdgeInsets.symmetric(vertical: 24.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _currentIndex == index
                        ? AppColors.blueButton
                        : AppColors.divider,
                    width: 2,
                  ),
                  color:
                      _currentIndex == index ? Colors.white : AppColors.divider,
                ),
              );
            },
          ),
        ),*/
      ],
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final String url = widget.imageUrls[index];

    return PhotoViewGalleryPageOptions(
      imageProvider: FirebaseStoreImageProvider(url),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained,
      maxScale: PhotoViewComputedScale.covered * 1.1,
      heroAttributes: PhotoViewHeroAttributes(tag: url),
    );
  }
}
