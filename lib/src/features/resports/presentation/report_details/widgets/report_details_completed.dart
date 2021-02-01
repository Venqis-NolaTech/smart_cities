
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_cities/src/core/util/file_util.dart';
import 'package:smart_cities/src/shared/components/image_gallery.dart';
import 'package:smart_cities/src/shared/components/image_gallery_with_zoom.dart';

import '../../../../../../generated/i18n.dart';
import '../../../../../shared/app_colors.dart';
import '../../../../../shared/constant.dart';
import '../../../../../shared/spaces.dart';
import '../../../domain/entities/report.dart';

class ReportDetailsCompleted extends StatefulWidget {
  ReportDetailsCompleted({
    Key key,
    @required this.report,
  }) : super(key: key);

  final Report report;

  @override
  _ReportDetailsCompletedState createState() => _ReportDetailsCompletedState();
}

class _ReportDetailsCompletedState extends State<ReportDetailsCompleted> {
  List<String> _images = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _images = _getImages();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Spaces.verticalMedium(),
          Container(
            color: Colors.grey.withOpacity(0.1),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    S.of(context).galleryPhoto,
                    style: kNormalStyle.copyWith(
                        color: AppColors.primaryTextLight),
                  )),
                ],
              ),
            ),
          ),

          ImageGallery(
            imageUrls: _images,
            height: 220.0,
            onTap: (index) => _showImageDetail(index),
          ),

        ],
      ),
    );
  }
  List<String> _getImages() {
    return widget.report?.imagesClosed?.where((file) {
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


}
