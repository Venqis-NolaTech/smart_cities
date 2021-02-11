
import 'package:get_it/get_it.dart';
import 'package:smart_cities/src/features/places/presentation/places_detail/provider/place_detail_provider.dart';
import 'package:smart_cities/src/features/places/presentation/places_list/provider/all_places_provider.dart';
import 'package:smart_cities/src/features/places/presentation/places_list/provider/nearby_places_provider.dart';
import 'package:smart_cities/src/features/places/presentation/places_list/provider/places_provider.dart';

initProvider(GetIt sl) async {

    sl.registerFactory(
    () => PlacesProvider(
        getAllCategoryPlacesUseCase: sl(),
        getNearbyPlacesByCategoryUseCase: sl(),
        getPlacesByCategoryUseCase: sl(),
        getCurrentLocationUseCase: sl()
    ),
  );

    sl.registerFactory(() => AllPlacesProvider(
        getPlacesByCategoryUseCase: sl()
    ));


    sl.registerFactory(() => NearbyPlacesProvider(
        getCurrentLocationUseCase: sl(),
        getNearbyPlacesByCategoryUseCase: sl()
    ));

    sl.registerFactory(() => PlaceDetailsProvider(
        getPlaceByIdUseCase: sl()
    ));
}