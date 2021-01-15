import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import '../../domain/usecases/like_post_use_case.dart';

import '../../../../core/error/failure.dart';
import '../../../../shared/provider/base_provider.dart';
import '../../../../shared/provider/view_state.dart';
import '../../domain/entities/post.dart';
import '../../domain/usecases/get_post_announcement_detail_use_case.dart';
import '../../domain/usecases/get_post_new_detail_use_case.dart';
import '../../domain/usecases/get_post_training_detail_use_case.dart';

class BlogDetailProvider extends BaseProvider {
  BlogDetailProvider({
    @required this.getPostNewsDetailUseCase,
    @required this.getPostAnnouncementDetailUseCase,
    @required this.getPostTrainingDetailUseCase,
    @required this.likePostUseCase,
  });

  final GetPostNewsDetailUseCase getPostNewsDetailUseCase;
  final GetPostAnnouncementDetailUseCase getPostAnnouncementDetailUseCase;
  final GetPostTrainingDetailUseCase getPostTrainingDetailUseCase;
  final LikePostUseCase likePostUseCase;

  void loadData(Post post) async {
    state = Loading();

    final failureOrPostDetail = await _getPostDetail(post);

    failureOrPostDetail.fold(
      (failure) => state = Error(failure: failure),
      (postDetail) => state = Loaded(value: postDetail),
    );
  }

  Future<Post> likePost(String postId) async {
    final failureOrSuccess = await likePostUseCase(postId);

    return failureOrSuccess.fold(
      (failure) => null,
      (postLiked) => postLiked,
    );
  }

  Future<Either<Failure, dynamic>> _getPostDetail(Post post) async {
    final postKind = post.kind;

    switch (postKind) {
      case PostKind.training:
        return getPostTrainingDetailUseCase(post.id);
      case PostKind.announcement:
        return getPostAnnouncementDetailUseCase(post.id);
      case PostKind.news:
      default:
        return getPostNewsDetailUseCase(post.id);
    }
  }
}
