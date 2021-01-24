import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/failure.dart';
import '../../../../shared/provider/paginated_provider.dart';
import '../../domain/entities/post.dart';
import '../../domain/usecases/get_all_posts_use_case.dart';
import '../../domain/usecases/like_post_use_case.dart';

class BlogListProvider extends PaginatedProvider<Post> {
  BlogListProvider({
    @required this.getAllPostsUseCase,
    @required this.likePostUseCase,
  });

  final GetAllPostsUseCase getAllPostsUseCase;
  final LikePostUseCase likePostUseCase;

  @override
  get count => 4;

  PostKind _kind;

  void loadData(PostKind kind) {
    _kind = kind;

    super.fetchData();
  }

  @override
  Future<Either<Failure, PageData<Post>>> processRequest() async {
    final params = GetAllPostParams(
      _kind,
      page: page,
      count: count,
    );

    final failureOrListings = await getAllPostsUseCase(params);

    return failureOrListings.fold(
      (failure) => Left(failure),
      (listings) => Right(
        PageData(
          totalCount: listings.total,
          items: listings.posts,
        ),
      ),
    );
  }

  void likePost(String postId) async {
    final failureOrSuccess = await likePostUseCase(postId);

    failureOrSuccess.fold(
      (failure) => null,
      (postLiked) => updatePostOnList(postLiked),
    );
  }

  void updatePostOnList(Post post) {
    final element = items.firstWhere((i) => i.id == post.id);
    final index = items.indexOf(element);

    items.replaceRange(index, index + 1, [post]);

    notifyListeners();
  }
}
