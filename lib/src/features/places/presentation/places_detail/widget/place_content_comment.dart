import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/places/domain/entities/place.dart';
import 'package:smart_cities/src/features/places/presentation/new_review/page/new_review_page.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/rating_bar_card.dart';
import 'package:smart_cities/src/shared/spaces.dart';
import 'package:smart_cities/src/features/places/presentation/places_detail/widget/rating_item.dart';

class PlaceContentComment extends StatelessWidget {
  final Place place;

  PlaceContentComment({Key key, this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => Navigator.pushNamed(context, NewReviewPage.id,arguments: place),
        child: Container(
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        child: Column(
          children: [
            RantingBarCard(initialRating: 5, onRatingUpdate: (ranting) {  }, ),

            Spaces.verticalSmall(),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(MdiIcons.squareEditOutline, color: AppColors.blueButton),
                Spaces.horizontalMedium(),
                Text(
                  S.of(context).writeReview,
                  textAlign: TextAlign.start,
                  style: kTitleStyle.copyWith(
                      fontWeight: FontWeight.bold, color: AppColors.blueButton),
                ),
              ],
            ),


          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spaces.horizontalMedium(),
              Text('${place.votes}', style: kMenuBigTitleStyle.copyWith(color: AppColors.primaryText, fontWeight: FontWeight.bold),),
              Spaces.horizontalMedium(),

              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.of(context).averageMark, style: kNormalStyle.copyWith(color: AppColors.primaryText, fontWeight: FontWeight.bold),),
                    Text('34 ${S.of(context).vote}', style: kNormalStyle.copyWith(color: AppColors.primaryText),),
                  ],
                ),
              ),
            ],
          ),
          RatingItem(vote: place.votes5, ranting: 5),
          RatingItem(vote: place.votes4, ranting: 4),
          RatingItem(vote: place.votes3, ranting: 3),
          RatingItem(vote: place.votes2, ranting: 2),
          RatingItem(vote: place.votes1, ranting: 1),



          ],
        ),
      ),
    );
  }
}
