import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_cities/src/core/util/file_util.dart';
import 'package:smart_cities/src/features/reports/domain/entities/report.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/components/comment_item_admin.dart';
import 'package:smart_cities/src/shared/components/firebase_storage_image.dart';
import 'package:smart_cities/src/shared/components/image_gallery_with_zoom.dart';

import '../../../generated/i18n.dart';
import '../../core/util/string_util.dart';
import '../constant.dart';
import '../spaces.dart';

class CommentItem extends StatelessWidget {
  CommentItem({
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

    if(user.isAdmin)
      return CommentItemAdmin(comment: comment);
    else
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        comment.isAnonymous ? S.of(context).messageIsAnonymous : user?.displayName ?? "" ,
                        style: kNormalStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.blueBtnRegister
                        ),
                      ),
                    ),

                    Text(
                      _creatAtFormatted(context).capitalize,
                      style: kSmallestTextStyle.copyWith(
                        color: AppColors.blueButton,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
                Spaces.verticalSmall(),

                Text(
                  comment?.comment ?? "",
                  style: kNormalStyle.copyWith(
                      color: AppColors.blueBtnRegister.withOpacity(0.5)
                  ),
                ),
                Spaces.verticalSmall(),
                comment.pictureUrl.isNotEmpty ?
                    _buildGallery(context) : Container()

              ],
            )
          ],
        ),
      );
  }

  Widget _buildGallery(BuildContext context) {

    var listWidget= List.generate(comment.pictureUrl.length, (index) => _buildItem(referenceUrl: comment.pictureUrl.elementAt(index)));

    return GestureDetector(
      onTap: ()=> _showImageDetail(context, 0),
      child: Container(
        child: GridView.count(
            shrinkWrap: true,
            primary: false,
            padding: const EdgeInsets.all(10),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 3,
            children: listWidget
        ),
      ),
    );


  }

  Widget _buildItem({String referenceUrl}) {
    return GestureDetector(
        onTap: null,
        child: Container(
          height: 60,
          child: Material(
            child: referenceUrl != null
                ? FirebaseStorageImage(
                    referenceUrl: referenceUrl,
                    fit: BoxFit.fitWidth,
                    fallbackWidget: CircularProgressIndicator(),
                    errorWidget: AppImages.defaultImage,
                  )
                : AppImages.defaultImage,
          ),
        ));
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
