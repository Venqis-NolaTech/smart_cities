import 'package:flutter/material.dart';

import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingItem extends StatelessWidget {
  final double vote;
  final double ranting;
  const RatingItem({Key key, this.vote, this.ranting}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
         /*SizedBox(
            width: MediaQuery.of(context).size.width/2,
            child: LinearProgressIndicator(
                value: vote,
                backgroundColor: AppColors.greyButtom.withOpacity(0.5)),
          ),*/
          
        
        Container(width: MediaQuery.of(context).size.width/3, decoration: BoxDecoration(
          color: AppColors.greyButtom,{
            
          }
        )), 

          /*RatingBar.builder(
            initialRating: ranting,
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
            onRatingUpdate: (value) {},
          ),*/

          Text('${vote.toInt()} %')
        ],
      ),
    );
  }
}
