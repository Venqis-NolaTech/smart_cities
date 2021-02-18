import 'package:get_it/get_it.dart';
import 'package:smart_cities/src/features/places/domain/usescase/get_all_category_places_use_case.dart';
import 'package:smart_cities/src/features/places/domain/usescase/get_nearby_places_by_category_use_case.dart';
import 'package:smart_cities/src/features/places/domain/usescase/get_place_by_id_use_case.dart';
import 'package:smart_cities/src/features/places/domain/usescase/get_places_by_category_use_case.dart';
import 'package:smart_cities/src/features/places/domain/usescase/new_review_place_use_case.dart';
import 'package:smart_cities/src/features/places/domain/usescase/get_place_comment_use_case.dart';

initUseCase(GetIt sl) async{


  sl.registerLazySingleton(
    () => GetAllCategoryPlacesUseCase(
      placeRepository: sl(),
    ),
  );


  sl.registerLazySingleton(
        () => GetPlacesByCategoryUseCase(
      placeRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
        () => GetNearbyPlacesByCategoryUseCase(
      placeRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
        () => GetPlaceByIdUseCase(
      placeRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
        () => NewReviewPlaceUseCase(
      placeRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
        () => GetPlaceCommentUseCase(
      placeRepository: sl(),
    ),
  );



}