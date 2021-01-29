import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_cities/src/core/util/file_util.dart';
import 'package:smart_cities/src/features/resports/domain/entities/report.dart';
import 'package:smart_cities/src/shared/components/firebase_storage_image.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/components/image_gallery_with_zoom.dart';

import '../../../generated/i18n.dart';
import '../../core/util/string_util.dart';
import '../constant.dart';
import '../spaces.dart';

class CommentItemAdmin extends StatelessWidget {
  CommentItemAdmin({
    Key key,
    @required this.comment,
    this.isLast = false,
  }) : super(key: key);

  final ReportComment comment;
  final bool isLast;

  String _creatAtFormatted(BuildContext context) => DateFormat('MMMM d, y')
      .format(DateTime.parse(comment.createdAt).toLocal());

  @override
  Widget build(BuildContext context) {
    final user = comment?.user;

    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, right: 8.0, left: 8.0),
      child: Card(
        child: Container(
          //padding: EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[


              ListTile(
                leading: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      child: ClipOval(
                        child: user?.pictureUrl?.isNotNullOrNotEmpty ?? false
                            ? FirebaseStorageImage(
                          referenceUrl: user?.pictureUrl,
                          fallbackWidget: CircularProgressIndicator(),
                          errorWidget: AppImages.defaultImage,
                          fit: BoxFit.cover,
                        ) : Image.asset(AppImagePaths.defaultImage, fit: BoxFit.fitWidth),
                      ),
                    ),
                    Spaces.verticalSmallest(),
                    Text(
                      user?.displayName ?? "",
                      style: kSmallTextStyle,
                    )


                  ],
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        user?.displayName ?? "",
                        style: kNormalStyle.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      _creatAtFormatted(context).capitalize,
                      style: kSmallestTextStyle.copyWith(
                        color: AppColors.blueButton,
                      ),
                      textAlign: TextAlign.end,
                    )
                  ],
                ),
                subtitle: Text(
                  comment?.comment ?? "",
                  style: kNormalStyle,
                ),
              ),

              comment.pictureUrl.isNotEmpty ? buildGallery(context) : Container()


            ],
          ),
        ),
      ),
    );
  }

  InkWell buildGallery(BuildContext context) {
    return InkWell(
              onTap: ()=> _showImageDetail(context, 0),
              child: Container(
                padding:  EdgeInsets.only(right: 12, left:12, top: 15, bottom: 15),
                color: AppColors.background.withOpacity(0.3),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        color: comment.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Spaces.horizontalSmall(),
                    Expanded(
                      child: Text(comment.nameStatus,
                          style: TextStyle(
                              color: AppColors.greenCompleted,
                              fontWeight: FontWeight.bold)
                      ),
                    ),
                    Text(S.of(context).seeGallery,
                      style: TextStyle(
                          color: AppColors.blueLight,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            );
  }


  void _showImageDetail(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.white.withOpacity(0.6),
          appBar: AppBar(
            backgroundColor: Colors.white.withOpacity(0.2),
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.close),
              color: Colors.black,
              onPressed: () => Navigator.pop(context),
            ),
          ),
          extendBodyBehindAppBar: true,
          body: ImageGalleryWithZoom(
            imageUrls: _getImages(),
            initialIndex: index,
            loadingBuilder: (_, __) =>
                Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }

  List<String> _getImages() {
    return comment?.pictureUrl?.where((file) {
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
