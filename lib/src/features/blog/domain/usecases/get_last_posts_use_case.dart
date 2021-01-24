import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import '../entities/post.dart';
import '../repositories/blog_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';

class GetLastPostsUseCase extends UseCase<PostListings, ListingsParams> {
  final BlogRepository blogRepository;

  GetLastPostsUseCase({@required this.blogRepository});

  @override
  Future<Either<Failure, PostListings>> call(
    ListingsParams params, {
    Callback callback,
  }) =>
      blogRepository.getLastPosts(
        page: params.page,
        count: params.count,
      );
}
