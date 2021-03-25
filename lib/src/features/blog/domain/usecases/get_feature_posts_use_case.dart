import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import '../entities/post.dart';
import '../repositories/blog_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import 'get_all_posts_use_case.dart';

class GetFeaturePostsUseCase extends UseCase<PostListings, GetAllPostParams> {
  final BlogRepository blogRepository;

  GetFeaturePostsUseCase({@required this.blogRepository});

  @override
  Future<Either<Failure, PostListings>> call(
    GetAllPostParams params, {
    Callback callback,
  }) =>
      blogRepository.getPostFeature(
        kind: params.kind,
        page: params.page,
        count: params.count,
      );
}

