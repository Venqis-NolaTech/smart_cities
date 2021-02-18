import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:smart_cities/src/features/auth/domain/usecases/logged_user_use_case.dart';
import 'package:smart_cities/src/core/usecases/use_case.dart';

import '../../../../core/error/failure.dart';
import '../../../../shared/provider/paginated_provider.dart';
import '../../domain/entities/post.dart';
import '../../domain/usecases/get_all_posts_use_case.dart';
import '../../domain/usecases/get_general_posts_use_case.dart';
import '../../domain/usecases/like_post_use_case.dart';

class BlogListProvider extends PaginatedProvider<Post> {
  BlogListProvider({
    @required this.getAllPostsUseCase,
    @required this.geGeneralPostsUseCase,
    @required this.likePostUseCase,
    @required this.loggedUserUseCase,
  });

  final GetAllPostsUseCase getAllPostsUseCase;
  final GetGeneralPostsUseCase geGeneralPostsUseCase;
  final LikePostUseCase likePostUseCase;
  final LoggedUserUseCase loggedUserUseCase;


  @override
  get count => 4;

  PostKind _kind;

  bool isLogged;

  void loadData(PostKind kind) async {
    _kind = kind;
    if(isLogged==null) {
      final logged = await loggedUserUseCase(NoParams());
      await logged.fold((failure) {
        isLogged = false;
      }, (user) {
        if (user != null) isLogged = true;
        isLogged = false;
      });
    }
    super.fetchData();
  }

  @override
  Future<Either<Failure, PageData<Post>>> get processRequest async {
    final params = GetAllPostParams(
      _kind,
      page: page,
      count: count,
    );

    final failureOrListings = isLogged
        ? await getAllPostsUseCase(params)
        : await geGeneralPostsUseCase(params);

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
