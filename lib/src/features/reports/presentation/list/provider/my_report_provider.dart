import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecases/use_case.dart';
import '../../../../../shared/provider/paginated_provider.dart';
import '../../../domain/entities/report.dart';
import '../../../domain/usecases/get_my_reports_use_case.dart';

class MyReportProvider extends PaginatedProvider<Report> {
  MyReportProvider({@required this.getMyReportsUseCase});

  final GetMyReportsUseCase getMyReportsUseCase;

  @override
  Future<Either<Failure, PageData<Report>>> processRequest() async {
    final params = ListingsParams(
      page: page,
      count: count,
    );

    final failureOrListings = await getMyReportsUseCase(params);

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
}
