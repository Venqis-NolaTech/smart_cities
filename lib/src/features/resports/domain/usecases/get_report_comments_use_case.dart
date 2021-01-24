import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import '../entities/report.dart';
import '../repositories/report_repository.dart';

class GetReportCommentsUseCase
    extends UseCase<ReportCommentListing, CommentsParams> {
  final ReportRepository reportRepository;

  GetReportCommentsUseCase({@required this.reportRepository});

  @override
  Future<Either<Failure, ReportCommentListing>> call(
    CommentsParams params, {
    Callback callback,
  }) {
    return reportRepository.getReportComments(
      params.id,
      page: params.page,
      count: params.count,
    );
  }
}

class CommentsParams extends ListingsParams {
  final String id;

  CommentsParams(this.id, {int page, int count})
      : super(
          page: page,
          count: count,
        );

  @override
  List<Object> get props => [
        id,
        ...super.props,
      ];
}
