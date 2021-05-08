import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:smart_cities/src/core/error/failure.dart';

import '../../../../../shared/provider/paginated_provider.dart';
import '../../../domain/usescase/get_place_comment_use_case.dart';
import '../../../domain/entities/place.dart';

class PlaceCommentProvider extends PaginatedProvider<LastComment>{
  final GetPlaceCommentUseCase getPlaceCommentUseCase;

  PlaceCommentProvider({
     @required this.getPlaceCommentUseCase
  });

  String _placeId;

  @override
  Future<Either<Failure, PageData<LastComment>>> processRequest() async  {
    
    
    final params = PlaceCommentsParams(
      _placeId,
      page: page,
      count: count,
    );

    final failureOrListings = await getPlaceCommentUseCase(params);

    return failureOrListings.fold(
      (failure) => Left(failure),
      (listings) => Right(
        PageData(
          totalCount: listings.totalCount,
          items: listings.comments,
        ),
      ),
    );
 
  }


  void getComments(String id) {
    _placeId = id;

    fetchData();
  }

}