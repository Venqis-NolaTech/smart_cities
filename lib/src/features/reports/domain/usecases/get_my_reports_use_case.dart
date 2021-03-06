import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import '../entities/report.dart';
import '../repositories/report_repository.dart';

class GetMyReportsUseCase extends UseCase<ReportListing, ListingsParams> {
  final ReportRepository reportRepository;

  GetMyReportsUseCase({@required this.reportRepository});

  @override
  Future<Either<Failure, ReportListing>> call(
    ListingsParams params, {
    Callback callback,
  }) {
    return reportRepository.getMyReports(
      page: params.page,
      count: params.count,
    );
  }
}
