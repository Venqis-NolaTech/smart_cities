import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_cities/src/features/places/domain/entities/place.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/components/firebase_storage_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:smart_cities/src/shared/components/read_more_text.dart';
import 'package:smart_cities/generated/i18n.dart';

import '../../core/util/string_util.dart';
import '../constant.dart';
import '../spaces.dart';

class PlaceCommentItem extends StatelessWidget {
  PlaceCommentItem({
    Key key,
    @required this.comment,
    this.isLast = false,
  }) : super(key: key);

  final LastComment comment;
  final bool isLast;

  String _creatAtFormatted(BuildContext context) => DateFormat('MMMM d, y')
      .format(DateTime.parse(comment.createdAt).toLocal());

  @override
  Widget build(BuildContext context) {
    final user = comment?.user;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            _creatAtFormatted(context).capitalize,
            style: kSmallestTextStyle.copyWith(
              color: AppColors.blueBtnRegister,
            ),
            textAlign: TextAlign.end,
          ),
          Row(
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
                        )
                      : Image.asset(AppImagePaths.defaultImage,
                          fit: BoxFit.fitWidth),
                ),
              ),
              Spaces.horizontalSmall(),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.displayName ?? "",
                      style: kNormalStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.blueBtnRegister),
                    ),
                    Spaces.verticalSmall(),
                    RatingBar.builder(
                      initialRating: comment.rating,
                      ignoreGestures: true,
                      minRating: 1,
                      itemCount: 5,
                      itemSize: 15,
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
                  ],
                ),
              ),
            ],
          ),
          Spaces.verticalSmall(),
          ReadMoreText(
            comment?.comment ?? "",
            style: kNormalStyle.copyWith(color: AppColors.blueBtnRegister),
            trimCollapsedText: S.of(context).showMore.toLowerCase(),
            trimExpandedText: S.of(context).showLess.toLowerCase(),
            trimLines: 4,
            trimMode: TrimMode.Line,
            colorClickableText: AppColors.blue,
          ),
          Spaces.verticalSmall(),
        ],
      ),
    );
  }
}
