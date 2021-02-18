import 'package:get_it/get_it.dart';
import 'package:smart_cities/src/features/reports/domain/usecases/get_all_category_use_case.dart';
import 'package:smart_cities/src/features/reports/domain/usecases/get_all_filtres_use_case.dart';
import 'package:smart_cities/src/features/reports/domain/usecases/get_neighborhood_use_case.dart';
import 'package:smart_cities/src/features/reports/domain/usecases/get_sectores_use_case.dart';
import 'package:smart_cities/src/features/reports/domain/usecases/like_report_use_case.dart';
import 'package:smart_cities/src/features/reports/domain/usecases/set_filtres_use_case.dart';
import 'package:smart_cities/src/features/reports/domain/usecases/update_report_comment_use_case.dart';
import 'package:smart_cities/src/features/reports/domain/usecases/upload_comment_report_file_use_case.dart';


import '../domain/usecases/create_report_comment_use_case.dart';
import '../domain/usecases/create_report_use_case.dart';
import '../domain/usecases/get_general_reports_use_case.dart';
import '../domain/usecases/get_my_reports_use_case.dart';
import '../domain/usecases/get_nearby_reports_use_case.dart';
import '../domain/usecases/get_report_by_id_use_case.dart';
import '../domain/usecases/get_report_comments_use_case.dart';
import '../domain/usecases/update_report_use_case.dart';
import '../domain/usecases/upload_report_file_use_case.dart';

initUseCase(GetIt sl) {
  sl.registerLazySingleton(
    () => GetGeneralReportsUseCase(
      reportRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetNearbyReportsUseCase(
      reportRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetMyReportsUseCase(
      reportRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetReportByIdUseCase(
      reportRepository: sl(),
      userLocalRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetReportCommentsUseCase(
      reportRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => CreateReportCommentUseCase(
      reportRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetAllCategoryUseCase(
      reportRepository: sl(),
    ),
  );



  sl.registerLazySingleton(
    () => CreateReportUseCase(
      reportRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => UpdateReportUseCase(
      reportRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => UploadReportFileUseCase(
      firebaseStorage: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetSectoresUseCase(
        userRepository: sl(),
        userLocalRepository: sl()
    ),
  );

  sl.registerLazySingleton(
        () => GetNeighborhoodUseCase(
      userRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
        () => LikeReportUseCase(
          reportRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
          () => UpdateReportCommentUseCase(
            reportRepository: sl()
          ));

  sl.registerLazySingleton(
          () => UploadCommentReportFileUseCase(
              firebaseStorage: sl()
          ));


  sl.registerLazySingleton(
          () => GetAllFiltresUseCase(
          reportRepository: sl()
      ));

  sl.registerLazySingleton(
          () => SetFiltresUseCase(
          reportRepository: sl()
      ));
}
