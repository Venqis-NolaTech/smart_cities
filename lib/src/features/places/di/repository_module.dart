


import 'package:get_it/get_it.dart';
import 'package:smart_cities/src/features/places/data/repositories/places_repository_impl.dart';
import 'package:smart_cities/src/features/places/domain/repositories/places_repository.dart';

initRepository(GetIt sl) async {
  sl.registerLazySingleton<PlacesRepository>(
      () => PlaceRepositoryImpl(
      placesDataSource: sl(),
    ));
}