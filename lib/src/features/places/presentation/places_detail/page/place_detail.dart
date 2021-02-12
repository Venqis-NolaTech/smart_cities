import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/places/domain/entities/place.dart';
import 'package:smart_cities/src/features/places/presentation/places_detail/provider/place_detail_provider.dart';
import 'package:smart_cities/src/features/places/presentation/places_detail/widget/place_content_comment.dart';
import 'package:smart_cities/src/features/places/presentation/places_detail/widget/place_content_services.dart';
import 'package:smart_cities/src/features/places/presentation/places_detail/widget/place_content_ubication.dart';
import 'package:smart_cities/src/features/places/presentation/places_detail/widget/place_header.dart';
import 'package:smart_cities/src/features/places/presentation/new_review/page/new_review_page.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/components/base_view.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';
import 'package:smart_cities/src/shared/components/rounded_button.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';
import 'package:smart_cities/src/shared/rating_bar_card.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../places_detail/widget/place_content_video_player.dart';
import '../../place_comment/page/place_comment_page.dart';



class PlaceDetailsPage extends StatefulWidget {
  static const id = "places_details_page";
  final Place place;

  PlaceDetailsPage({Key key, @required this.place}) : super(key: key);

  @override
  _PlaceDetailsPageState createState() => _PlaceDetailsPageState();
}

class _PlaceDetailsPageState extends State<PlaceDetailsPage> {
  bool _placeLoaded = false;
  Place _place;
  bool _isDisposed = false;

  set place(Place newPlace) {
    if (_isDisposed) return;

    setState(() {
      _place = newPlace;
    });
  }

  @override
  void initState() {
    _place = widget.place;
    super.initState();
  }

  @override
  void dispose() {
    _place = null;
    _isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<PlaceDetailsProvider>(
      onProviderReady: (provider) => provider.getPlaceById(widget.place.id),
      builder: (context, provider, child) {
        final currentState = provider.currentState;

        if (!_placeLoaded && currentState is Loaded<Place>) {
          Future.delayed(
            Duration(milliseconds: 250),
            () => place = currentState.value,
          );

          _placeLoaded = true;
        }

        return ModalProgressHUD(
          inAsyncCall: currentState is Loading,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.red,
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Text(S.of(context).sitesTourist),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  PlaceDetailHeader(place: _place),
                  PlaceContentService(place: _place),
                  PlaceContentVideo(place: _place),
                  Spaces.verticalLarge(),
                  PlaceContentUbication(place: _place),
                  Spaces.verticalLarge(),
                  Container(
                    padding: EdgeInsets.only(left: 24.0, right: 24.0),
                    child: RantingBarCard(
                      initialRating: 5,
                      onRatingUpdate: (ranting) {},
                    ),
                  ),
                  Spaces.verticalSmall(),
                  _buildNewReview(),
                  Spaces.verticalLarge(),
                  InkWell(
                      onTap: () => Navigator.pushNamed(context, PlaceCommentPage.id, arguments: _place), 
                      child: PlaceContentComment(place: _place)),
                  Spaces.verticalLarge(),
                  btnNewReport(),
                  Spaces.verticalLarge(),
                  btnComment(),
                  Spaces.verticalLarge(),
                  btnGetDirection(),
                  Spaces.verticalLarge()
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget btnNewReport() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Row(
          children: [
            Flexible(child: Text(S.of(context).reportInPlace)),
            Container(
                decoration: BoxDecoration(
                  color: AppColors.greyButtom.withOpacity(.1),
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(S.of(context).newReport,
                      style: kNormalStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText)),
                ))
          ],
        ));
  }

  Widget btnComment() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: RoundedButton(
            color: AppColors.red,
            title: S.of(context).seeComment.toUpperCase(),
            style: kTitleStyle.copyWith(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                color: AppColors.white),
            onPressed: () {}));
  }

  Widget btnGetDirection() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: RoundedButton(
            color: AppColors.blueBtnRegister,
            title: S.of(context).getDirection.toUpperCase(),
            style: kTitleStyle.copyWith(
              fontWeight: FontWeight.w400,
              color: AppColors.white,
            ),
            onPressed: () {}));
  }

  Widget _buildNewReview() {
    return InkWell(
      onTap: () =>
          Navigator.pushNamed(context, NewReviewPage.id, arguments: _place),
      child: Row(
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
    );
  }
}
