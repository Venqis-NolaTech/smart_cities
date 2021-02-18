import 'package:flutter/material.dart';

import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:smart_cities/src/shared/spaces.dart';

class RatingItem extends StatelessWidget {
  final double vote;
  final double ranting; // numero de estrellas para este
  const RatingItem({Key key, this.vote, this.ranting}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /*SizedBox(
            width: MediaQuery.of(context).size.width/2,
            child: LinearProgressIndicator(
                value: vote,
                backgroundColor: AppColors.greyButtom.withOpacity(0.5)),
          ),*/
   
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          width: MediaQuery.of(context).size.width / 3,
          height: 10,
          child: ClipRRect(
            //borderRadius: BorderRadius.all(Radius.circular(10)),
            child: LinearProgressIndicator(
              value: vote/100,
              valueColor: new AlwaysStoppedAnimation<Color>(AppColors.greyButtom),
              backgroundColor: Color(0xffD6D6D6),
            ),
          ),
        ),
          /*Expanded(
            child: Stack(
              children: [
                Container(
                    //width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
    
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade300,
                          width: 10,
                        ),
                      ),
                    )),

                   Container(
                    width: (MediaQuery.of(context).size.width / 2)*0.5,
                    decoration: BoxDecoration(
         
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.greyButtom,
                          width: 10,
                        ),
                      ),
                    )),
              ],
            ),
          ),*/

          /*Expanded(
            child: Spaces.horizontalSmall(),
          )*/

          RatingBar.builder(
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
            ),
          Spaces.horizontalSmall(),

          Flexible(child: Text('${vote.toInt()} %'))
        ],
      ),
    );
  }
}
