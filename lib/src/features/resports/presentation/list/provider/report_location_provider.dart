import 'package:google_maps_webservice/places.dart';
import 'package:meta/meta.dart';
import 'package:smart_cities/src/features/auth/domain/usecases/logged_user_use_case.dart';

import '../../../../../core/usecases/use_case.dart';
import '../../../../../shared/constant.dart';
import '../../../../../shared/provider/base_provider.dart';
import '../../../../../shared/provider/view_state.dart';
import '../../../../auth/domain/entities/user.dart';
import '../../../../auth/domain/usecases/get_current_location_use_case.dart';

class ReportLocationProvider extends BaseProvider {
  ReportLocationProvider({
    @required this.getCurrentLocationUseCase,
    @required this.googleMapsPlaces,
    @required this.loggedUserUseCase,
  });

  final GetCurrentLocationUseCase getCurrentLocationUseCase;
  final GoogleMapsPlaces googleMapsPlaces;
  final LoggedUserUseCase loggedUserUseCase;

  Position currentLocation;

  Position _placesSearched;
  Position get placesSearched => _placesSearched;

  void notify() {
    if (!isDispose) notifyListeners();
  }

  Future initData() async {
    state = Loading();
    final logged = await loggedUserUseCase(NoParams());

    await logged.fold(
      (failure) {
        state = Error(failure: failure);
      },
      (user) async {
        await getCurrentLocation(notify: false);
        state = Loaded();
      },
    );
  }

  Future<Position> getCurrentLocation({bool notify = true}) async {
    if (notify) state = Loading();

    final failureOrLocation = await getCurrentLocationUseCase(NoParams());

    final location = failureOrLocation.fold(
      (_) => Position(
        latitude: kDefaultLocation.latitude,
        longitude: kDefaultLocation.longitude,
      ),
      (location) => location,
    );

    currentLocation = location;

    if (notify) state = Loaded();

    return currentLocation;
  }

  Future displayPrediction(Prediction prediction) async {
    if (prediction != null) {
      PlacesDetailsResponse detail =
          await googleMapsPlaces.getDetailsByPlaceId(prediction.placeId);

      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;

      _placesSearched = Position(latitude: lat, longitude: lng);
    }
  }
}
