import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/core/util/file_util.dart';
import 'package:smart_cities/src/features/places/domain/entities/place.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/components/circular_button.dart';
import 'package:smart_cities/src/shared/components/image_gallery.dart';
import 'package:smart_cities/src/shared/components/image_gallery_with_zoom.dart';
import 'package:smart_cities/src/shared/components/read_more_text.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';

class PlaceDetailHeader extends StatefulWidget {
  final Place place;

  PlaceDetailHeader({Key key, @required this.place}) : super(key: key);

  @override
  _PlaceDetailHeaderState createState() => _PlaceDetailHeaderState();
}

class _PlaceDetailHeaderState extends State<PlaceDetailHeader> {
  List<String> _images = [];

  @override
  void initState() {
    super.initState();
    _images = _getImages();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImageGallery(
          imageUrls: _images,
          height: 220.0,
          onTap: (index) => _showImageDetail(index),
        ),
        Spaces.verticalSmall(),

        /// TITULO

        Container(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        widget.place?.name,
                        textAlign: TextAlign.start,
                        style: kBigTitleStyle.copyWith(
                          color: AppColors.blueBtnRegister,
                        ),
                      ),
                      Spaces.verticalSmall(),
                      Text(
                        widget.place?.address,
                        textAlign: TextAlign.start,
                        style: kSmallTextStyle.copyWith(
                          color: AppColors.blueBtnRegister,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              CircularButton(
                  child: Icon(Icons.call),
                  onPressed: null,
                  color: AppColors.greyButtom.withOpacity(0.2)),
            ],
          ),
        ),

        Spaces.verticalSmall(),
        Container(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          child: Row(
            children: [
              RatingBar.builder(
                initialRating: widget.place.rating,
                ignoreGestures: true,
                minRating: 1,
                itemCount: 5,
                itemSize: 20,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  print(rating);
                },
              ),
              Expanded(child: Container())
            ],
          ),
        ),
        Spaces.verticalLarge(),
        Container(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          child: Text(
            S.of(context).aboutTitle,
            textAlign: TextAlign.start,
            style: kTitleStyle.copyWith(
                fontWeight: FontWeight.bold, color: AppColors.blueButton),
          ),
        ),
        Spaces.verticalSmall(),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: ReadMoreText(
            widget.place?.aboutDescription ?? "",
            trimCollapsedText: S.of(context).showMore.toLowerCase(),
            trimExpandedText: S.of(context).showLess.toLowerCase(),
            trimLines: 4,
            trimMode: TrimMode.Line,
            colorClickableText: AppColors.blue,
            style: kSmallTextStyle.copyWith(color: AppColors.blueBtnRegister),
          ),
        ),
        Spaces.verticalSmall(),
      ],
    );
  }

  void _showImageDetail(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.white.withOpacity(0.6),
          appBar: AppBar(
            backgroundColor: Colors.white.withOpacity(0.2),
            elevation: 0,
            leading: IconButton(
              icon: Icon(MdiIcons.close),
              color: Colors.black,
              onPressed: () => Navigator.pop(context),
            ),
          ),
          extendBodyBehindAppBar: true,
          body: ImageGalleryWithZoom(
            imageUrls: _images,
            initialIndex: index,
            loadingBuilder: (_, __) =>
                Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }

  List<String> _getImages() {
    return widget.place?.images?.where((file) {
          if (file != null) {
            final extensionName = file
                .substring(file.lastIndexOf(".") + 1)
                .replaceAll(RegExp(r'["\]]'), '');

            final fileType = FileTypeExtension.find(extensionName);

            return fileType == FileType.image;
          }
          return false;
        })?.toList() ??
        [];
  }
}
