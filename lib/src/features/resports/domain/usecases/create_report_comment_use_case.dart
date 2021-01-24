import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import '../entities/report.dart';
import '../repositories/report_repository.dart';

class CreateReportCommentUseCase
    extends UseCase<ReportComment, CreateReportCommentParams> {
  CreateReportCommentUseCase({@required this.reportRepository});

  final ReportRepository reportRepository;

  @override
  Future<Either<Failure, ReportComment>> call(
    CreateReportCommentParams params, {
    Callback callback,
  }) async {
    return await reportRepository.createComment(
      reportId: params.reportId,
      request: params.comment,
    );
  }
}

class CreateReportCommentParams extends Equatable {
  final String reportId;
  final Map<String, dynamic> comment;

  CreateReportCommentParams({
    this.reportId,
    this.comment,
  });

  @override
  List<Object> get props => [
        reportId,
        comment,
      ];
}
