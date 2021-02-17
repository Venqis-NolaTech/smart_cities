import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/places/domain/entities/place.dart';
import 'package:smart_cities/src/features/places/presentation/place_schedule/widget/schedule_item.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/components/place_title_header.dart';
import 'package:smart_cities/src/shared/spaces.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SchedulePlacePage extends StatelessWidget {
  static const id = "places_schedule_page";
  final Place place;

  String _currentDay() => DateFormat('EEEE').format(DateTime.now().toLocal());

  const SchedulePlacePage({Key key, this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(_currentDay().toUpperCase());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.red,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(S.of(context).sitesTourist),
        leading: IconButton(
          icon: Icon(MdiIcons.arrowLeft),
          color: AppColors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spaces.verticalMedium(),
              PlaceTitleHeader(place: place),
              Spaces.verticalMedium(),
              _buildRating(),
              Spaces.verticalMedium(),
              Row(
                children: [
                  Icon(MdiIcons.clockOutline, color: AppColors.blueBtnRegister),
                  Spaces.horizontalSmall(),
                  Expanded(child: Text(S.of(context).scheduleSite, style: kNormalStyle.copyWith(color: AppColors.blueBtnRegister)))
                ],
              ),
              Spaces.verticalMedium(),
              Column(
                children: _buildList(),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildList() {
    List<Widget> list = [];

    place.schedule.asMap().forEach((index, value) {
      list.add(ScheduleItem(
        item: place.schedule[index],
        selected: _currentDay().toUpperCase() ==
            place.schedule[index].dayEs.toUpperCase(),
      ));
    });

    return list;

    /*return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: place.schedule.length,
      itemBuilder: (context, index) => ScheduleItem(
        item: place.schedule[index],
        //isLast: index == comments.length - 1,
      ),
    );*/
  }

  Widget _buildRating() {
    return RatingBar.builder(
      initialRating: place.rating,
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
      onRatingUpdate: (rating) {
        print(rating);
      },
    );
  }
}
