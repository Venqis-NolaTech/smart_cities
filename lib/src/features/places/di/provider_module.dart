
import 'package:get_it/get_it.dart';
import 'package:smart_cities/src/features/places/presentation/provider/places_provider.dart';

initProvider(GetIt sl) async {

    sl.registerFactory(
    () => PlacesProvider(
        getAllCategoryPlacesUseCase: sl(),
        getNearbyPlacesByCategoryUseCase: sl(),
        getPlacesByCategoryUseCase: sl()
    ),
  );

}