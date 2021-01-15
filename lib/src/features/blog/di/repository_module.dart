import 'package:get_it/get_it.dart';
import '../data/repositories/blog_repository_impl.dart';
import '../domain/repositories/blog_repository.dart';


initRepository(GetIt sl) {
  sl.registerLazySingleton<BlogRepository>(
    () => BlogRepositoryImpl(
      blogDataSource: sl(),
    ),
  );
}
