import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/places/domain/entities/place.dart';
import 'package:smart_cities/src/shared/app_colors.dart';


class PlaceDetailsPage extends StatelessWidget {
  static const id = "places_details_page";

  final Place place;

  const PlaceDetailsPage({Key key, @required this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.red,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(S.of(context).sitesTourist),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [




          ],
        ),
      ),
    );
  }
}
