import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:smart_cities/src/features/reports/domain/entities/report.dart';
import 'package:smart_cities/src/features/reports/domain/repositories/report_filter_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';

class SetFiltresUseCase extends UseCase<bool, FilterReportItem> {
  final ReportFilterRepository reportRepository;

  SetFiltresUseCase({@required this.reportRepository});

  @override
  Future<Either<Failure, bool>> call(
    FilterReportItem params, {
    Callback callback,
  }) async {
    return Right(await reportRepository.setParam(params));
  }
}

