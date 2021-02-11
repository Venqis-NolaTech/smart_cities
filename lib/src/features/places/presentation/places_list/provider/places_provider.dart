import 'package:meta/meta.dart';
import 'package:smart_cities/src/core/entities/catalog_item.dart';
import 'package:smart_cities/src/core/usecases/use_case.dart';
import 'package:smart_cities/src/features/auth/domain/entities/user.dart';
import 'package:smart_cities/src/features/auth/domain/usecases/get_current_location_use_case.dart';
import 'package:smart_cities/src/features/places/domain/entities/place.dart';
import 'package:smart_cities/src/features/places/domain/usescase/get_all_category_places_use_case.dart';
import 'package:smart_cities/src/features/places/domain/usescase/get_nearby_places_by_category_use_case.dart';
import 'package:smart_cities/src/features/places/domain/usescase/get_places_by_category_use_case.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';

import '../../../../../shared/provider/base_provider.dart';

class PlacesProvider extends BaseProvider{
  final GetAllCategoryPlacesUseCase getAllCategoryPlacesUseCase;
  final GetNearbyPlacesByCategoryUseCase getNearbyPlacesByCategoryUseCase;
  final GetPlacesByCategoryUseCase getPlacesByCategoryUseCase;
  final GetCurrentLocationUseCase getCurrentLocationUseCase;

  PlacesProvider({
    @required this.getAllCategoryPlacesUseCase,
    @required this.getNearbyPlacesByCategoryUseCase,
    @required this.getPlacesByCategoryUseCase,
    @required this.getCurrentLocationUseCase,
  });

  CatalogItem _selectedCategory;

  CatalogItem get selectedCategory => _selectedCategory;

  Position currentLocation;
  final distance = 5000.0;
  List<Place> placesList=[];

  set selectedCategory(CatalogItem value) {
    _selectedCategory=value;
    notifyListeners();
  }

  Future<void> loadCategory() async {
    state= Loading();

    final failureOrReport = await getAllCategoryPlacesUseCase(NoParams());

    failureOrReport.fold(
      (failure) => state = Error(failure: failure),
      (listCategory) => state = Loaded<List<CatalogItem>>(value: listCategory),
    );


  }

  Future loadNearbyPlace({String municipality, String category}) async {
    state = Loading();
    if (currentLocation == null)
      await getCurrentLocation(notify: false);
    final params = GetPlacesParams(
        latitude: currentLocation.latitude,
        longitude: currentLocation.longitude,
        distance: distance,
        municipality: municipality,
        category: category
    );

    final failureOrReports = await getNearbyPlacesByCategoryUseCase(params);

    failureOrReports.fold(
          (failure) => state = Error(failure: failure),
          (places) {
            placesList= places.places;
            state = Loaded();
          },
    );
    state = Loaded();
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


}