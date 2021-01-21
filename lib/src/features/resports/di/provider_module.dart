import 'package:get_it/get_it.dart';
import 'package:smart_cities/src/features/resports/presentation/list/provider/general_report_provider.dart';
import 'package:smart_cities/src/features/resports/presentation/list/provider/my_report_provider.dart';
import 'package:smart_cities/src/features/resports/presentation/list/provider/nearby_report_provider.dart';
import 'package:smart_cities/src/features/resports/presentation/list/provider/report_location_provider.dart';
import 'package:smart_cities/src/features/resports/presentation/report_comments/providers/report_comments_provider.dart';
import 'package:smart_cities/src/features/resports/presentation/report_details/providers/report_details_provider.dart';


import '../presentation/new_report/providers/create_report_provider.dart';


initProvider(GetIt sl) {

  sl.registerFactory(
    () => CreateReportProvider(
      createReportUseCase: sl(),
      updateReportUseCase: sl(),
      uploadReportFileUseCase: sl(),
      getAllCategoryUseCase: sl(),
      getSectoresUseCase: sl(),
      getNeighborhoodUseCase: sl(),
      getCurrentLocationUseCase: sl(),
      loggedUserUseCase: sl(),
    ),
  );

  sl.registerFactory(
        () => NearbyReportProvider(
      getCurrentLocationUseCase: sl(),
      getNearbyReportsUseCase: sl(),
      loggedUserUseCase: sl(),
      likeReportUseCase: sl()
    ),
  );

  sl.registerFactory(
    () => GeneralReportProvider(
      getGeneralReportsUseCase: sl(),
      loggedUserUseCase: sl(),
      likeReportUseCase: sl(),
      setFiltresUseCase: sl(),
      getAllFiltresUseCase: sl(),
    ),
  );

  sl.registerFactory(
        () => MyReportProvider(
      getMyReportsUseCase: sl(),
    ),
  );


  sl.registerFactory(
    () => ReportLocationProvider(
      getCurrentLocationUseCase: sl(),
      googleMapsPlaces: sl(),
      loggedUserUseCase: sl()
    ),
  );

  sl.registerFactory(
        () => ReportDetailsProvider(
      getReportByIdUseCase: sl(),
      createReportCommentUseCase: sl(),
      updateReportCommentUseCase: sl(),
      likeReportUseCase: sl(),
      uploadReportFileUseCase: sl(),
      getReportCommentsUseCase: sl()
    ),
  );

  sl.registerFactory(
        () => ReportCommentsProvider(
      getReportCommentsUseCase: sl(),
      createReportCommentUseCase: sl(),
    ),
  );


}
