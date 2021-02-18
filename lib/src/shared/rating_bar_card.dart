import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';

import 'components/custom_card.dart';

class RantingBarCard extends StatelessWidget {
  final Function(double) onRatingUpdate;
  final double initialRating;
  final bool ignoreGestures;

  RantingBarCard({Key key, 
   @required this.onRatingUpdate, 
   @required this.initialRating, 
   this.ignoreGestures= true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
              backgroundColor: AppColors.greyButtom.withOpacity(0.05),
              child: Container(
                padding: EdgeInsets.only(top: 24.0, bottom: 24.0),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        S.of(context).qualifySitie,
                        textAlign: TextAlign.center,
                        style: kTitleStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.blueButton),
                      ),
                    ),
                    Spaces.verticalSmall(),
                    RatingBar.builder(
                      initialRating: initialRating,
                      ignoreGestures: ignoreGestures,
                      minRating: 1,
                      itemCount: 5,
                      itemSize: 40,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: onRatingUpdate,
                    ),

                    Spaces.verticalSmall(),

                    Text(
                      S.of(context).tapStart,
                      textAlign: TextAlign.start,
                      style: kSmallTextStyle.copyWith(
                        color: AppColors.blueBtnRegister,
                      ),
                    ),

                  ],
                ),
              )
    );
  }
}

