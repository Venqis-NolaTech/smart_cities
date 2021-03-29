import 'dart:collection';

import 'package:smart_cities/src/core/usecases/use_case.dart';
import 'package:smart_cities/src/features/auth/domain/usecases/logged_user_use_case.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';

import '../../../../shared/provider/base_provider.dart';
import '../../domain/entities/post.dart';
import '../../domain/usecases/get_last_posts_use_case.dart';
import '../../../../core/util/list_util.dart';

class BlogHeaderProvider extends BaseProvider {
  BlogHeaderProvider({
    this.getLastPostsUseCase,
    this.loggedUserUseCase,
  });

  final GetLastPostsUseCase getLastPostsUseCase;
  final LoggedUserUseCase loggedUserUseCase;

  final _lastPosts = List<Post>();

  UnmodifiableListView<Post> get lastPosts => UnmodifiableListView(_lastPosts);

  bool isLogged;

  void loadData() async {
    state = Loading();

    if(isLogged==null) {
      final logged = await loggedUserUseCase(NoParams());
      await logged.fold((failure) {
        isLogged = false;
      }, (user) {
        if (user != null) isLogged = true;
        isLogged = false;
      });
    }


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
