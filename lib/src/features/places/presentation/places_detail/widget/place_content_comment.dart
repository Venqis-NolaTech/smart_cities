import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/places/domain/entities/place.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';
import 'package:smart_cities/src/features/places/presentation/places_detail/widget/rating_item.dart';
import '../../../../../shared/components/comment_item_place.dart';



class PlaceContentComment extends StatelessWidget {
  final Place place;
  final formatter = new NumberFormat("##.#");

  PlaceContentComment({Key key, this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        child:  Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.greyButtom.withOpacity(0.5)),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            children: [

      
            Spaces.verticalMedium(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spaces.horizontalMedium(),
                Text('${formatter.format(place.rating).replaceAll(',', '.')}', style: kMenuBigTitleStyle.copyWith(color: AppColors.primaryText, fontWeight: FontWeight.bold),),
                Spaces.horizontalMedium(),

                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(S.of(context).averageMark, style: kNormalStyle.copyWith(color: AppColors.primaryText, fontWeight: FontWeight.bold),),
                      Text('${place.votes.toInt()} ${S.of(context).vote}', style: kNormalStyle.copyWith(color: AppColors.primaryText),),
                    ],
                  ),
                ),
              ],
            ),
            Spaces.verticalMedium(),
            
            RatingItem(vote: place.votes5, ranting: 5),
            RatingItem(vote: place.votes4, ranting: 4),
            RatingItem(vote: place.votes3, ranting: 3),
            RatingItem(vote: place.votes2, ranting: 2),
            RatingItem(vote: place.votes1, ranting: 1),

            Spaces.verticalMedium(),
            place.lastComment != null ? PlaceCommentItem(comment: place.lastComment) : Container()

            ],
          ),
        ),
    );
  }
}
