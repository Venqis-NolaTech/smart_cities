import 'package:dartz/dartz.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/post.dart';
import '../../domain/entities/post_training.dart';
import '../../domain/repositories/blog_repository.dart';
import '../datasources/remote/blog_data_source.dart';

class BlogRepositoryImpl extends BlogRepository {
  BlogRepositoryImpl({@required this.blogDataSource});

  final BlogDataSource blogDataSource;

  @override
  Future<Either<Failure, PostListings>> getAllPosts(
          {PostKind kind, int page, int count}) =>
      _process(
        () => blogDataSource.getAllPosts(
          kind: kind,
          page: page,
          count: count,
        ),
      );

  @override
  Future<Either<Failure, PostListings>> getGeneralPosts({PostKind kind, int page, int count}) =>
    _process(
            () => blogDataSource.getGeneralPosts(
          kind: kind,
          page: page,
          count: count,
        ),
    );


  @override
  Future<Either<Failure, PostListings>> getLastPosts(
          {PostKind kind, int page, int count}) =>
      _process(
        () => blogDataSource.getLastPosts(
          page: page,
          count: count,
        ),
      );

  @override
  Future<Either<Failure, PostTraining>> getPostAnnouncementDetail(
          String postId) =>
      _process(
        () => blogDataSource.getPostAnnouncementDetail(postId),
      );

  @override
  Future<Either<Failure, Post>> getPostNewsDetail(String postId) => _process(
        () => blogDataSource.getPostNewsDetail(postId),
      );

  @override
  Future<Either<Failure, PostTraining>> getPostTrainingDetail(String postId) =>
      _process(
        () => blogDataSource.getPostTrainingDetail(postId),
      );

  @override
  Future<Either<Failure, Post>> like(String postId) => _process(
        () => blogDataSource.like(postId),
      );

  // private methods --
  Future<Either<Failure, T>> _process<T>(Future<T> Function() action) async {
    try {
      final result = await action();

      if (result == null) {
        return Left(UnexpectedFailure());
      }

      return Right(result);
    } catch (e, s) {
      switch (e.runtimeType) {
        case NotConnectionException:
          return Left(NotConnectionFailure());
        default:
          FirebaseCrashlytics.instance.recordError(e, s);

          return Left(UnexpectedFailure());
      }
    }
  }
  // -- private methods
}
