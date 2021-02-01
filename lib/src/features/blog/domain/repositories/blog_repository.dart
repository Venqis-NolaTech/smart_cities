import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/post.dart';
import '../entities/post_training.dart';

abstract class BlogRepository {
  Future<Either<Failure, PostListings>> getAllPosts({
    PostKind kind,
    int page,
    int count,
  });

  Future<Either<Failure, PostListings>> getGeneralPosts({
    PostKind kind,
    int page,
    int count,
  });


  Future<Either<Failure, PostListings>> getLastPosts({
    int page,
    int count,
  });

  Future<Either<Failure, Post>> getPostNewsDetail(String postId);

  Future<Either<Failure, PostTraining>> getPostAnnouncementDetail(
      String postId);

  Future<Either<Failure, PostTraining>> getPostTrainingDetail(String postId);

  Future<Either<Failure, Post>> like(String postId);
}
