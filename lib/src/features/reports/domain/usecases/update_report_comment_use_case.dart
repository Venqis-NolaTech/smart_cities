import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import '../entities/report.dart';
import '../repositories/report_repository.dart';

class UpdateReportCommentUseCase extends UseCase<ReportComment, UpdateReportCommentParams> {
  UpdateReportCommentUseCase({@required this.reportRepository});

  final ReportRepository reportRepository;

  @override
  Future<Either<Failure, ReportComment>> call(
    UpdateReportCommentParams params, {
    Callback callback,
  }) async {
    return await reportRepository.updateComment(
      reportId: params.reportId,
      commentId: params.commentId,
      request: params.request
    );
  }
}

class UpdateReportCommentParams extends Equatable {
  final String reportId;
  final String commentId;
  final Map<String, dynamic> request;

  UpdateReportCommentParams({
    this.reportId,
    this.commentId,
    this.request,
  });

  @override
  List<Object> get props => [
        reportId,
        request,
      ];
}
