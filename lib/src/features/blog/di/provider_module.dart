import 'package:get_it/get_it.dart';

import '../presentation/providers/blog_detail_provider.dart';
import '../presentation/providers/blog_header_provider.dart';
import '../presentation/providers/blog_list_provider.dart';
import '../presentation/providers/blog_provider.dart';

initProvider(GetIt sl) {
  sl.registerFactory(
    () => BlogProvider(),
  );

  sl.registerFactory(
    () => BlogHeaderProvider(
      getLastPostsUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => BlogListProvider(
      getAllPostsUseCase: sl(),
      likePostUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => BlogDetailProvider(
      getPostAnnouncementDetailUseCase: sl(),
      getPostNewsDetailUseCase: sl(),
      getPostTrainingDetailUseCase: sl(),
      likePostUseCase: sl(),
    ),
  );
}
