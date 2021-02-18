
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:smart_cities/src/core/error/failure.dart';
import 'package:smart_cities/src/features/places/domain/entities/place.dart';
import 'package:smart_cities/src/features/places/domain/usescase/get_places_by_category_use_case.dart';
import 'package:smart_cities/src/shared/provider/paginated_provider.dart';

class AllPlacesProvider extends PaginatedProvider<Place>{

  AllPlacesProvider({
    @required this.getPlacesByCategoryUseCase
  });

  final GetPlacesByCategoryUseCase getPlacesByCategoryUseCase;

  String municipality;
  String category;


  @override
  Future<Either<Failure, PageData<Place>>> get processRequest async {

    final params= GetPlacesParams(municipality: municipality, category: category);
    final failureOrListings = await getPlacesByCategoryUseCase(params);


    return failureOrListings.fold(
          (failure) => Left(failure),
          (listings) => Right(
        PageData(
          totalCount: listings.totalCount,
          items: listings.places,
        ),
      ),
    );

  }

}