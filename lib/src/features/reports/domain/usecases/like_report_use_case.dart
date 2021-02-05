import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import '../entities/report.dart';
import '../repositories/report_repository.dart';

class LikeReportUseCase extends UseCase<Report, String> {
  final ReportRepository reportRepository;

  LikeReportUseCase({@required this.reportRepository});

  @override
  Future<Either<Failure, Report>> call(String reportId, {Callback callback}) {
    return reportRepository.likeReport(reportId);
  }
}
