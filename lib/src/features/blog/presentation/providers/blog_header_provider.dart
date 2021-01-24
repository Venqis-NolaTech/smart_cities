import 'dart:collection';

import 'package:smart_cities/src/core/usecases/use_case.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';

import '../../../../shared/provider/base_provider.dart';
import '../../domain/entities/post.dart';
import '../../domain/usecases/get_last_posts_use_case.dart';
import '../../../../core/util/list_util.dart';

class BlogHeaderProvider extends BaseProvider {
  BlogHeaderProvider({this.getLastPostsUseCase});

  final GetLastPostsUseCase getLastPostsUseCase;

  final _lastPosts = List<Post>();

  UnmodifiableListView<Post> get lastPosts => UnmodifiableListView(_lastPosts);

  void loadData() async {
    state = Loading();

    final failureOrLastPosts = await getLastPostsUseCase(ListingsParams());

    failureOrLastPosts.fold(
      (failure) => state = Error(failure: failure),
      (listings) {
        if (listings.posts.isNotNullOrNotEmpty) {
          _lastPosts.clear();
          _lastPosts.addAll(listings.posts);
        }

        state = Loaded();
      },
    );
  }
}
