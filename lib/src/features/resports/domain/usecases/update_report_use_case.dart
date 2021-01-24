import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import '../entities/report.dart';
import '../repositories/report_repository.dart';

class UpdateReportUseCase extends UseCase<Report, UpdateReportParams> {
  UpdateReportUseCase({@required this.reportRepository});

  final ReportRepository reportRepository;

  @override
  Future<Either<Failure, Report>> call(
    UpdateReportParams params, {
    Callback callback,
  }) async {
    return await reportRepository.updateReport(
      params.reportId,
      params.request,
    );
  }
}

class UpdateReportParams extends Equatable {
  final String reportId;
  final Map<String, dynamic> request;

  UpdateReportParams({
    this.reportId,
    this.request,
  });

  @override
  List<Object> get props => [
        reportId,
        request,
      ];
}
