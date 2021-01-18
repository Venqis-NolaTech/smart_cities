import 'package:dartz/dartz.dart';
import 'package:smart_cities/app.dart';
import 'package:smart_cities/src/features/auth/domain/usecases/logged_user_use_case.dart';
import 'package:smart_cities/src/features/resports/domain/usecases/get_all_filtres_use_case.dart';
import 'package:smart_cities/src/features/resports/domain/usecases/like_report_use_case.dart';
import 'package:smart_cities/src/features/resports/domain/usecases/set_filtres_use_case.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';
import 'package:meta/meta.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecases/use_case.dart';
import '../../../../../shared/provider/paginated_provider.dart';
import '../../../domain/entities/report.dart';
import '../../../domain/usecases/get_general_reports_use_case.dart';

class GeneralReportProvider extends PaginatedProvider<Report> {
  GeneralReportProvider( {
    @required this.loggedUserUseCase,
    @required this.likeReportUseCase,
    @required this.getGeneralReportsUseCase,
    @required this.getAllFiltresUseCase,
    @required this.setFiltresUseCase,
  });

  final GetGeneralReportsUseCase getGeneralReportsUseCase;
  final LoggedUserUseCase loggedUserUseCase;
  final LikeReportUseCase likeReportUseCase;

  final GetAllFiltresUseCase getAllFiltresUseCase;
  final SetFiltresUseCase setFiltresUseCase;


  @override
  Future<Either<Failure, PageData<Report>>> processRequest() async {

    final params = ListingsParams(
        page: page,
        count: count,
        municipality: currentUser?.municipality?.key
    );

    final failureOrListings = await getGeneralReportsUseCase(params);

    return failureOrListings.fold(
          (failure) => Left(failure),
          (listings) => Right(
        PageData(
          totalCount: listings.totalCount,
          items: listings.reports,
        ),
      ),
    );





    /*final logged = await loggedUserUseCase(NoParams());

    await logged.fold(
          (failure) =>(failure) => Left(failure),
          (user) async {
            if (user != null) {

              final params = ListingsParams(
                  page: page,
                  count: count,
                  municipality: user.municipality
              );

              final failureOrListings = await getGeneralReportsUseCase(params);

              return failureOrListings.fold(
                    (failure) => Left(failure),
                    (listings) => Right(
                  PageData(
                    totalCount: listings.totalCount,
                    items: listings.reports,
                  ),
                ),
              );


            }
      },
    );*/




  }



  void followReport(Report report) async {

    state = Loading();

    final failureOrSuccess = await likeReportUseCase(report.id);

    failureOrSuccess.fold(
          (failure) => state = Error(failure: failure),
          (report) => state = Loaded<Report>(value: report),
    );

  }


  Future getParam() async {

    state = Loading();

    final failureOrSuccess = await getAllFiltresUseCase(NoParams());

    failureOrSuccess.fold(
          (_) {},
          (list) => state = Loaded<List<FilterReportItem>>(value: list),
    );

  }

  Future setParam(FilterReportItem filter) async {

    state = Loading();

    final failureOrSuccess = await setFiltresUseCase(filter);

    getParam();
  }


}
