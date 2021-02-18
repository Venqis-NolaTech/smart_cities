
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:smart_cities/src/core/error/failure.dart';
import 'package:smart_cities/src/core/usecases/use_case.dart';
import 'package:smart_cities/src/features/places/data/models/place_model.dart';
import 'package:smart_cities/src/features/places/domain/repositories/places_repository.dart';

class GetPlaceCommentUseCase extends UseCase<PlaceCommentListingModel, PlaceCommentsParams>{
  final PlacesRepository placeRepository;

  GetPlaceCommentUseCase({@required this.placeRepository});

  @override
  Future<Either<Failure, PlaceCommentListingModel>> call(PlaceCommentsParams params, {callback}) {
    return placeRepository.getComments(params.id, page: params.page, count: params.count);
  }

}

class PlaceCommentsParams extends ListingsParams {
  final String id;

  PlaceCommentsParams(this.id, {int page, int count})
      : super(
          page: page,
          count: count,
        );

  @override
  List<Object> get props => [
        id,
        ...super.props,
      ];
}