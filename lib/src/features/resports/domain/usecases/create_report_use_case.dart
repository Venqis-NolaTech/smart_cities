import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import '../entities/report.dart';
import '../repositories/report_repository.dart';

class CreateReportUseCase extends UseCase<Report, Map<String, dynamic>> {
  CreateReportUseCase({@required this.reportRepository});

  final ReportRepository reportRepository;

  @override
  Future<Either<Failure, Report>> call(
    Map<String, dynamic> params, {
    Callback callback,
  }) async {
    return await reportRepository.createReport(params);
  }
}
