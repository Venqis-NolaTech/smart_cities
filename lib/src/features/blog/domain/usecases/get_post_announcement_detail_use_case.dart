import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import '../entities/post_training.dart';
import '../repositories/blog_repository.dart';

class GetPostAnnouncementDetailUseCase extends UseCase<PostTraining, String> {
  final BlogRepository blogRepository;

  GetPostAnnouncementDetailUseCase({@required this.blogRepository});

  @override
  Future<Either<Failure, PostTraining>> call(
    String postId, {
    Callback callback,
  }) =>
      blogRepository.getPostAnnouncementDetail(postId);
}
