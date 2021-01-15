import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_images.dart';
import 'firebase_storage_image.dart';

class ImageGallery extends StatefulWidget {
  ImageGallery({
    Key key,
    @required this.imageUrls,
    this.height = 222.0,
    this.autoPlay = false,
    this.onTap,
  }) : super(key: key);

  final List<String> imageUrls;
  final double height;
  final bool autoPlay;
  final Function(int) onTap;

  @override
  _ImageGalleryState createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery>
    with TickerProviderStateMixin<ImageGallery> {
  int _currentIndex = 0;

  void onPageChanged(int index, CarouselPageChangedReason reason) {
    setState(() {
      _currentIndex = index;
    });
  }

  List<Widget> _buildImages() {
    List<Widget> children = widget.imageUrls.isNotEmpty
        ? _map<Widget>(
            widget.imageUrls,
            (index, url) {
              return InkWell(
                onTap: () {
                  if (widget.onTap != null) widget.onTap(index);
                },
                child: Container(
                  height: widget.height,
                  child: FirebaseStorageImage(
                    referenceUrl: url,
                    fallbackWidget: CircularProgressIndicator(),
                    errorWidget: AppImages.defaultImage,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          )
        : [
            Container(
              color: Colors.white,
              child: Center(
                child: SizedBox(
                  height: 40,
                  width: 80,
                  child: AppImages.defaultImage,
                ),
              ),
            ),
          ];

    return children;
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
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CarouselSlider(
            items: _buildImages(),
            options: CarouselOptions(
              viewportFraction: 1.0,
              autoPlay: widget.autoPlay,
              onPageChanged: onPageChanged,
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
                    color: _currentIndex == index
                        ? Colors.white
                        : AppColors.divider,
                  ),
                );
              },
            ),
          ),*/
        ],
      ),
    );
  }
}
