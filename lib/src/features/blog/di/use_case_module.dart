import 'package:get_it/get_it.dart';

import '../domain/usecases/get_all_posts_use_case.dart';
import '../domain/usecases/get_last_posts_use_case.dart';
import '../domain/usecases/get_post_announcement_detail_use_case.dart';
import '../domain/usecases/get_post_new_detail_use_case.dart';
import '../domain/usecases/get_post_training_detail_use_case.dart';
import '../domain/usecases/like_post_use_case.dart';

initUseCase(GetIt sl) {
  sl.registerLazySingleton(
    () => GetAllPostsUseCase(
      blogRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetLastPostsUseCase(
      blogRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetPostNewsDetailUseCase(
      blogRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetPostAnnouncementDetailUseCase(
      blogRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetPostTrainingDetailUseCase(
      blogRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => LikePostUseCase(
      blogRepository: sl(),
    ),
  );
}
