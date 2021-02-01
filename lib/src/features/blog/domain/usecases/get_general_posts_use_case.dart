import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import '../entities/post.dart';
import '../repositories/blog_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import 'get_all_posts_use_case.dart';

class GetGeneralPostsUseCase extends UseCase<PostListings, GetAllPostParams> {
  final BlogRepository blogRepository;

  GetGeneralPostsUseCase({@required this.blogRepository});

  @override
  Future<Either<Failure, PostListings>> call(
    GetAllPostParams params, {
    Callback callback,
  }) =>
      blogRepository.getGeneralPosts(
        kind: params.kind,
        page: params.page,
        count: params.count,
      );
}

