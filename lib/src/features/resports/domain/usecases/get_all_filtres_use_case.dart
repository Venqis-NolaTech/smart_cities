import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:smart_cities/src/features/resports/domain/entities/report.dart';
import 'package:smart_cities/src/features/resports/domain/repositories/report_filter_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';

class GetAllFiltresUseCase extends UseCase<List<FilterReportItem>, NoParams> {
  final ReportFilterRepository reportRepository;

  GetAllFiltresUseCase({@required this.reportRepository});

  @override
  Future<Either<Failure,  List<FilterReportItem>>> call(
    NoParams params, {
    Callback callback,
  }) {
    return reportRepository.createParam();
  }
}
