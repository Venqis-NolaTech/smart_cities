import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share/share.dart';
import 'package:smart_cities/generated/i18n.dart';

import '../../../../../core/util/file_util.dart';
import '../../../../../core/util/flavor_config.dart';
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
    @required this.provider,
  }) : super(key: key);

  final Report report;
  final ReportDetailsProvider provider;

  @override
  ReportDetailsHeaderState createState() => ReportDetailsHeaderState();
}

class ReportDetailsHeaderState extends State<ReportDetailsHeader> {
  List<String> _images = [];
  bool _liked = false;

  @override
  void initState() {
    super.initState();

    _images = _getImages();
    _liked = widget?.report?.follow ?? false;
  }

  void setLiked(bool value) {
    setState(() {
      _liked = value;
    });
  }

  String _creatAtFormatted(BuildContext context) => DateFormat('MMMM d, y')
      .format(DateTime.parse(widget.report.createdAt).toLocal());

  void _onShareReport() {
    String urlShareReport = FlavorConfig.instance.values.baseApiUrl;
    String shareLink = '$urlShareReport/share/report/${widget.report.id}';

    Share.share(shareLink);
  }

  void _onLikeReport() {
    setLiked(!_liked);

    widget.provider?.likeReport();
  }

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
    return Container(
      padding: EdgeInsets.only(top: 24.0, left: 24.0, right: 24.0),
      child: Column(
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
          Text(
            widget.report?.title,
            textAlign: TextAlign.start,
            style: kBigTitleStyle.copyWith(
              color: AppColors.blueBtnRegister,
            ),
          ),
          //Spaces.verticalSmall(),

          Row(
            children: [
              Expanded(
                child: buildCreatedAt(context),
              ),
              buildAddPhoto(context),
            ],
          ),

          Spaces.verticalSmall(),
          Divider(),
        ],
      ),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.photo_camera, color: AppColors.blueLight),
          onPressed: null,
        ),
        Text(
          S.of(context).addPhoto,
          style: kSmallestTextStyle.copyWith(
            color: AppColors.blue,
          ),
        )
      ],
    );
  }
}
