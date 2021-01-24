import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

import '../../../generated/i18n.dart';
import '../../core/util/flavor_config.dart';
import '../../core/util/object_id.dart';
import '../constant.dart';

class GooglePlacesSearchPage extends PlacesAutocompleteWidget {
  static const id = "google_places_search_page";

  GooglePlacesSearchPage()
      : super(
          apiKey: FlavorConfig.instance.values.googlePlacesApiKey,
          sessionToken: ObjectId().toHexString(),
          language: "es",
          components: [Component(Component.country, "pa")],
        );

  @override
  _CustomSearchScaffoldState createState() => _CustomSearchScaffoldState();
}

class _CustomSearchScaffoldState extends PlacesAutocompleteState {
  final searchScaffoldKey = GlobalKey<ScaffoldState>();

  GoogleMapsPlaces _places;

  @override
  void initState() {
    super.initState();

    _places = GoogleMapsPlaces(
        apiKey: FlavorConfig.instance.values.googlePlacesApiKey);
  }

  Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;

      scaffold.showSnackBar(
        SnackBar(content: Text("${p.description} - $lat/$lng")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: searchScaffoldKey,
      appBar: AppBar(
        title: AppBarPlacesAutoCompleteTextField(
          textDecoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            hintText: '${S.of(context).search}...',
            hintStyle: kNormalStyle.copyWith(
              color: Colors.grey,
            ),
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20.0),
          ),
        ),
      ),
      body: PlacesAutocompleteResult(
        onTap: (p) => displayPrediction(p, searchScaffoldKey.currentState),
      ),
    );
  }

  @override
  void onResponseError(PlacesAutocompleteResponse response) {
    super.onResponseError(response);

    searchScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  @override
  void onResponse(PlacesAutocompleteResponse response) {
    super.onResponse(response);
    if (response != null && response.predictions.isNotEmpty) {
      searchScaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Got answer")),
      );
    }
  }
}
