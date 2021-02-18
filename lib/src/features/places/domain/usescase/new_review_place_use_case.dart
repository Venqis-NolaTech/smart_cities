

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_cities/src/core/error/failure.dart';
import 'package:smart_cities/src/core/usecases/use_case.dart';
import 'package:smart_cities/src/features/places/data/models/place_model.dart';
import 'package:smart_cities/src/features/places/domain/repositories/places_repository.dart';

class NewReviewPlaceUseCase extends UseCase<LastCommentModel, NewReviewParams>{

  final PlacesRepository placeRepository;

  NewReviewPlaceUseCase({this.placeRepository});

  @override
  Future<Either<Failure, LastCommentModel>> call(NewReviewParams params, {callback}) {
    return placeRepository.sendComment(placeId: params.placeId, request: params.request);
  }

}


class NewReviewParams extends Equatable{
  final String placeId;
  final Map<String, dynamic> request;

  NewReviewParams({this.placeId, this.request});

  @override
  List<Object> get props => [];
}