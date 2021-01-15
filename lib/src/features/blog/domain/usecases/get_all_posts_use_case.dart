import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import '../entities/post.dart';
import '../repositories/blog_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';

class GetAllPostsUseCase extends UseCase<PostListings, GetAllPostParams> {
  final BlogRepository blogRepository;

  GetAllPostsUseCase({@required this.blogRepository});

  @override
  Future<Either<Failure, PostListings>> call(
    GetAllPostParams params, {
    Callback callback,
  }) =>
      blogRepository.getAllPosts(
        kind: params.kind,
        page: params.page,
        count: params.count,
      );
}

class GetAllPostParams extends ListingsParams {
  final PostKind kind;

  GetAllPostParams(
    this.kind, {
    int page,
    int count,
  }) : super(
          page: page,
          count: count,
        );

  @override
  List<Object> get props => [
        kind,
        ...super.props,
      ];
}
