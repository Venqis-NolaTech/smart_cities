import 'package:meta/meta.dart';
import 'package:smart_cities/src/core/usecases/use_case.dart';
import 'package:smart_cities/src/features/auth/domain/usecases/logged_user_use_case.dart';
import 'package:smart_cities/src/features/blog/domain/usecases/get_all_posts_use_case.dart';
import 'package:smart_cities/src/features/blog/domain/usecases/get_feature_posts_use_case.dart';

import '../../../../shared/provider/base_provider.dart';
import '../../../../shared/provider/view_state.dart';

class BlogFeaturedProvider extends BaseProvider {
  BlogFeaturedProvider({
    @required this.getFeaturePostsUseCase,
    @required this.loggedUserUseCase
  });

  final GetFeaturePostsUseCase getFeaturePostsUseCase;
  final LoggedUserUseCase loggedUserUseCase;

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


    final params = GetAllPostParams(
      null,
      page: 1,
      count: 5,
    );

    final failureOrPostDetail = await getFeaturePostsUseCase(params);

    failureOrPostDetail.fold(
      (failure) => state = Error(failure: failure),
      (postDetail){
        state = Loaded(value: postDetail.posts);
        print('nueva noticia destacada');
      },
    );
  }

}
