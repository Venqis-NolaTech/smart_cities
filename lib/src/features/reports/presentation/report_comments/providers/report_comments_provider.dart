import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../shared/provider/paginated_provider.dart';
import '../../../../../shared/provider/view_state.dart';
import '../../../domain/entities/report.dart';
import '../../../domain/usecases/create_report_comment_use_case.dart';
import '../../../domain/usecases/get_report_comments_use_case.dart';

class ReportCommentsProvider extends PaginatedProvider<ReportComment> {
  ReportCommentsProvider({
    @required this.getReportCommentsUseCase,
    @required this.createReportCommentUseCase,
  });

  final GetReportCommentsUseCase getReportCommentsUseCase;
  final CreateReportCommentUseCase createReportCommentUseCase;

  String _reportId;

  ViewState commentPostState = Idle();

  String _comment = "";

  String get comment => _comment;

  set comment(String comment) {
    _comment = comment;

    notifyListeners();
  }

  @override
  Future<Either<Failure, PageData<ReportComment>>> processRequest() async {
    final params = CommentsParams(
      _reportId,
      page: page,
      count: count,
    );

    final failureOrListings = await getReportCommentsUseCase(params);

    return failureOrListings.fold(
      (failure) => Left(failure),
      (listings) => Right(
        PageData(
          totalCount: listings.totalCount,
          items: listings.comments,
        ),
      ),
    );
  }

  void getComments(String id) {
    _reportId = id;

    fetchData();
  }

  /*void createComment() async {
    commentPostState = Loading();

    final params = CreateReportCommentParams(
      reportId: _reportId,
      comment: comment,
    );

    final failureOrCommentCreated = await createReportCommentUseCase(params);

    await failureOrCommentCreated.fold(
      (failure) {
        commentPostState = Error(failure: failure);
      },
      (commentCreated) {
        commentPostState = Loaded<ReportComment>(value: commentCreated);

        _comment = "";

        refreshData();
      },
    );
  }*/
}
