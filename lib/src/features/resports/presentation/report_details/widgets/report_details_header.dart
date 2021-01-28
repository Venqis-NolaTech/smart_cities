import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_cities/generated/i18n.dart';

import '../../../../../core/util/file_util.dart';
import '../../../../../core/util/string_util.dart';
import '../../../../../shared/app_colors.dart';
import '../../../../../shared/components/image_gallery.dart';
import '../../../../../shared/components/image_gallery_with_zoom.dart';
import '../../../../../shared/constant.dart';
import '../../../../../shared/spaces.dart';
import '../../../domain/entities/report.dart';
import '../providers/report_details_provider.dart';

class ReportDetailsHeader extends StatefulWidget {
  ReportDetailsHeader({
    Key key,
    @required this.report,
    @required this.addPhoto,
    @required this.provider,
  }) : super(key: key);

  final Report report;
  final Function addPhoto;
  final ReportDetailsProvider provider;

  @override
  ReportDetailsHeaderState createState() => ReportDetailsHeaderState();
}

class ReportDetailsHeaderState extends State<ReportDetailsHeader> {
  List<String> _images = [];

  @override
  void initState() {
    super.initState();
    _images = _getImages();
  }

  String _creatAtFormatted(BuildContext context) => DateFormat('MMMM d, y')
      .format(DateTime.parse(widget.report.createdAt).toLocal());


  List<String> _getImages() {
    return widget.report?.images?.where((file) {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ImageGallery(
          imageUrls: _images,
          height: 220.0,
          onTap: (index) => _showImageDetail(index),
        ),
        Spaces.verticalSmall(),
        /// TITULO
        Container(
          padding: EdgeInsets.only(top: 24.0, left: 24.0, right: 24.0),
          child: Text(
            widget.report?.title,
            textAlign: TextAlign.start,
            style: kBigTitleStyle.copyWith(
              color: AppColors.blueBtnRegister,
            ),
          ),
        ),
        //Spaces.verticalSmall(),

        Container(
          padding: EdgeInsets.only(top: 24.0, left: 24.0, right: 24.0),
          child: Row(
            children: [
              Expanded(
                child: buildCreatedAt(context),
              ),
              buildAddPhoto(context),
            ],
          ),
        ),

        Spaces.verticalSmall(),
        Divider(),
      ],
    );
  }

  Widget buildCreatedAt(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          _creatAtFormatted(context).capitalize,
          style: kSmallestTextStyle.copyWith(
            color: AppColors.blueBtnRegister.withOpacity(0.5),
          ),
        ),
        Spaces.verticalMedium(),
        buildAuthor(context)
      ],
    );
  }

  Widget buildAuthor(BuildContext context) {
    return Row(
      children: [
        Text(
          '${S.of(context).author} : ',
          style: kSmallTextStyle.copyWith(
            color: AppColors.blueBtnRegister,
          ),
        ),
        Expanded(
          child: Text(
            widget.report?.createdBy?.displayName ?? '',
            style: kSmallTextStyle.copyWith(
              color: AppColors.blueBtnRegister,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildAddPhoto(BuildContext context) {
    return GestureDetector(
      onTap: widget.addPhoto,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.photo_camera, color: AppColors.blueLight),
          Text(
            S.of(context).addPhoto,
            style: kSmallestTextStyle.copyWith(
              color: AppColors.blue,
            ),
          )
        ],
      ),
    );
  }
}
