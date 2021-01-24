import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import '../entities/post.dart';
import '../repositories/blog_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';

class GetPostNewsDetailUseCase extends UseCase<Post, String> {
  final BlogRepository blogRepository;

  GetPostNewsDetailUseCase({@required this.blogRepository});

  @override
  Future<Either<Failure, Post>> call(
    String postId, {
    Callback callback,
  }) =>
      blogRepository.getPostNewsDetail(postId);
}
